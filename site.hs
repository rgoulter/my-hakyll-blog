--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll

import Data.List (isPrefixOf, tails, findIndex, intercalate, sortBy)
import Data.Maybe (fromMaybe)
import Control.Applicative (Alternative (..))
import Control.Monad (forM_, zipWithM_, liftM)
import System.FilePath (takeFileName)

import Data.Time.Format (parseTime)
import System.Locale (defaultTimeLocale)
import Data.Time.Clock (UTCTime)

import Text.Blaze.Html.Renderer.String (renderHtml)
import Text.Blaze.Html ((!), toHtml, toValue)
import Text.Blaze.Internal (preEscapedString)
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

data Blog = Blog { blogPostsGlob :: Pattern
                 , blogPrefix :: String
                 }

cs3216Blog :: Blog
cs3216Blog = Blog { blogPostsGlob = "posts/cs3216/*.markdown"
                  , blogPrefix = "cs3216/"
                  }

personalBlog :: Blog
personalBlog = Blog { blogPostsGlob = "posts/**.markdown"
                    , blogPrefix = "blog/"
                    }

-- Glob for matching the *.markdown posts under subdirectories of /posts/<category>/
-- postsGlob :: Pattern
-- postsGlob = "posts/**.markdown"

blogPageForPageIdx :: Blog -> Int -> String
blogPageForPageIdx blog index = (blogPrefix blog) ++
                                (if index==1 then "" else show index ++ "/") ++
                                "index.html"

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "templates/*" $ compile templateCompiler

    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    -- page about yi, which is specific to the personal blog.
    match (fromList ["yi.markdown"]) $ do
        route   $ prefixRouteWith "blog/" `composeRoutes` setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    -- Per blog, buildup tags, categories, paginated list of posts, posts, etc.
    forM_ [cs3216Blog, personalBlog] $ \ blog -> do
        let postsGlob = blogPostsGlob blog
            blogRoute = prefixRouteWith $ blogPrefix blog

        -- build up tags
        tags <- buildTags postsGlob (fromCapture "tags/*.html")

        categories <- buildCategories postsGlob (fromCapture "categories/*.html")

        rulesForTags blog categories (\tag -> "Posts in category \"" ++ tag ++ "\"")

        rulesForTags blog tags (\tag -> "Posts tagged \"" ++ tag ++ "\"")

        match postsGlob $ do
            route $ blogRoute `composeRoutes` setExtension "html"
            compile $ do 
                let postContext =
                        field "nextPost" (nextPostUrl blog) `mappend`
                        field "prevPost" (previousPostUrl blog) `mappend`
                        postCtxWithTags tags

                pandocCompiler
                    >>= saveSnapshot "teaser"
                    >>= loadAndApplyTemplate "templates/post.html"    postContext
                    >>= saveSnapshot "content"
                    >>= loadAndApplyTemplate "templates/post-with-pagination.html" postContext
                    >>= loadAndApplyTemplate "templates/default.html" postContext
                    >>= relativizeUrls

        create ["archive.html"] $ do
            route blogRoute
            compile $ do
                posts <- recentFirst =<< loadAll postsGlob
                let archiveCtx =
                        listField "posts" postCtx (return posts) `mappend`
                        constField "title" "Archives"            `mappend`
                        defaultContext

                makeItem ""
                    >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                    >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                    >>= relativizeUrls


        paginate blog 5 $ \index maxIndex itemsForPage -> do
            let id = fromFilePath $ blogPageForPageIdx blog index
            create [id] $ do
                route idRoute
                compile $ do
                    let allCtx =
                            field "title" (\_ -> return "Blog") `mappend`
                            defaultContext
                        loadTeaser id = loadSnapshot id "teaser"
                                            >>= loadAndApplyTemplate "templates/teaser.html" (teaserCtx tags)
                                            -- >>= relativizeUrls
                    items <- sequence $ map loadTeaser itemsForPage
                    let itembodies = map itemBody items
                        postsCtx =
                            constField "posts" (concat itembodies) `mappend`
                            field "navlinkolder" (\_ -> return $ indexNavLink blog index 1 maxIndex) `mappend`
                            field "navlinknewer" (\_ -> return $ indexNavLink blog index (-1) maxIndex) `mappend`
                            tagCloudField "taglist" 80 200 tags `mappend`
                            field "categorylist" (\_ -> renderTagListLines categories) `mappend`
                            defaultContext
     
                    makeItem ""
                        >>= loadAndApplyTemplate "templates/blogpage.html" postsCtx
                        >>= loadAndApplyTemplate "templates/default.html" allCtx
                        >>= relativizeUrls


        create ["atom.xml"] $ do
            route blogRoute
            compile $ do
                let feedCtx = postCtx `mappend` bodyField "description"
                posts <- fmap (take 10) . recentFirst =<<
                    loadAllSnapshots postsGlob "content"
                renderAtom feedConfiguration feedCtx posts


--------------------------------------------------------------------------------
prefixRouteWith :: String -> Routes
prefixRouteWith s =
    customRoute ((\x -> s ++ x) . toFilePath)


--------------------------------------------------------------------------------
-- | RSS feed configuration.
--
feedConfiguration :: FeedConfiguration
feedConfiguration = FeedConfiguration
    { feedTitle       = "Richard Goulter's Blog"
    , feedDescription = "RSS feed for Richard Goulter's blog"
    , feedAuthorName  = "Richard Goulter"
    , feedAuthorEmail = "richard.goulter+blog@gmail.com"
    , feedRoot        = "http://www.rgoulter.com/blog/"
    }


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext


postCtxWithTags :: Tags -> Context String
postCtxWithTags tags = tagsField "tags" tags `mappend` postCtx


teaserCtx :: Tags -> Context String
teaserCtx tags =
    field "teaser" teaserBody `mappend`
    (postCtxWithTags tags)


--------------------------------------------------------------------------------
previousPostUrl :: Blog -> Item String -> Compiler String
previousPostUrl blog post = do
    posts <- getMatches $ blogPostsGlob blog
    let ident = itemIdentifier post
        sortedPosts = sortIdentifiersByDate posts
        ident' = itemBefore sortedPosts ident
    case ident' of
        Just i -> (fmap (maybe empty $ toUrl) . getRoute) i
        Nothing -> empty


nextPostUrl :: Blog -> Item String -> Compiler String
nextPostUrl blog post = do
    posts <- getMatches $ blogPostsGlob blog
    let ident = itemIdentifier post
        sortedPosts = sortIdentifiersByDate posts
        ident' = itemAfter sortedPosts ident
    case ident' of
        Just i -> (fmap (maybe empty $ toUrl) . getRoute) i
        Nothing -> empty


itemAfter :: Eq a => [a] -> a -> Maybe a
itemAfter xs x =
    lookup x $ zip xs (tail xs)


itemBefore :: Eq a => [a] -> a -> Maybe a
itemBefore xs x =
    lookup x $ zip (tail xs) xs


urlOfPost :: Item String -> Compiler String
urlOfPost =
    fmap (maybe empty $ toUrl) . getRoute . itemIdentifier


--------------------------------------------------------------------------------
rulesForTags :: Blog -> Tags -> (String -> String) -> Rules ()
rulesForTags blog tags titleForTag =
    tagsRules tags $ \tag pattern -> do
    let title = titleForTag tag -- "Posts tagged \"" ++ tag ++ "\""
    route $ prefixRouteWith $ blogPrefix blog
    compile $ do
        posts <- recentFirst =<< loadAll pattern
        let ctx = constField "title" title
                  `mappend` listField "posts" postCtx (return posts)
                  `mappend` defaultContext

        makeItem ""
            >>= loadAndApplyTemplate "templates/tag.html" ctx
            >>= loadAndApplyTemplate "templates/default.html" ctx
            >>= relativizeUrls


--------------------------------------------------------------------------------
-- | Split list into equal sized sublists.
-- https://github.com/ian-ross/blog
chunk :: Int -> [a] -> [[a]]
chunk n [] = []
chunk n xs = ys : chunk n zs
    where (ys,zs) = splitAt n xs


--------------------------------------------------------------------------------
teaserBody :: Item String -> Compiler String
teaserBody item = do
    let body = itemBody item
    return $ extractTeaser . maxLengthTeaser . compactTeaser $ body
  where
    extractTeaser :: String -> String
    extractTeaser [] = []
    extractTeaser xs@(x : xr)
        | "<!-- more -->" `isPrefixOf` xs = []
        | otherwise                       = x : extractTeaser xr

    maxLengthTeaser :: String -> String
    maxLengthTeaser s = if findIndex (isPrefixOf "<!-- more -->") (tails s) == Nothing
                            then unwords (take 60 (words s))
                            else s

    compactTeaser :: String -> String
    compactTeaser =
        (replaceAll "<iframe [^>]*>" (const "")) .
        (replaceAll "<img [^>]*>" (const "")) .
        (replaceAll "<p>" (const "")) .
        (replaceAll "</p>" (const "")) .
        (replaceAll "<blockquote>" (const "")) .
        (replaceAll "</blockquote>" (const "")) .
        (replaceAll "<strong>" (const "")) .
        (replaceAll "</strong>" (const "")) .
        (replaceAll "<ol>" (const "")) .
        (replaceAll "</ol>" (const "")) .
        (replaceAll "<ul>" (const "")) .
        (replaceAll "</ul>" (const "")) .
        (replaceAll "<li>" (const "")) .
        (replaceAll "</li>" (const "")) .
        (replaceAll "<h[0-9][^>]*>" (const "")) .
        (replaceAll "</h[0-9]>" (const "")) .
        (replaceAll "<pre.*" (const "")) .
        (replaceAll "<a [^>]*>" (const "")) .
        (replaceAll "</a>" (const ""))


--------------------------------------------------------------------------------
-- | Generate navigation link HTML for stepping between index pages.
-- https://github.com/ian-ross/blog
--
indexNavLink :: Blog -> Int -> Int -> Int -> String
indexNavLink blog n d maxn = renderHtml ref
  where ref = if (refPage == "") then ""
              else H.a ! A.href (toValue $ toUrl $ refPage) $ 
                   (preEscapedString lab)
        lab = if (d > 0) then "Older Entries &raquo;" else "&laquo; Newer Entries"
        refPage = if (n + d < 1 || n + d > maxn) then ""
                  else blogPageForPageIdx blog (n + d)


--------------------------------------------------------------------------------
paginate:: Blog -> Int -> (Int -> Int -> [Identifier] -> Rules ()) -> Rules ()
paginate blog itemsPerPage rules = do
    identifiers <- getMatches $ blogPostsGlob blog

    let sorted = reverse $ sortBy byDate identifiers
        chunks = chunk itemsPerPage sorted
        maxIndex = length chunks
        pageNumbers = take maxIndex [1..]
        process i is = rules i maxIndex is
    zipWithM_ process pageNumbers chunks
        where
            byDate id1 id2 =
                let fn1 = takeFileName $ toFilePath id1
                    fn2 = takeFileName $ toFilePath id2
                    parseTime' fn = parseTime defaultTimeLocale "%Y-%m-%d" $ intercalate "-" $ take 3 $ splitAll "-" fn
                in compare ((parseTime' fn1) :: Maybe UTCTime) ((parseTime' fn2) :: Maybe UTCTime)


sortIdentifiersByDate :: [Identifier] -> [Identifier]
sortIdentifiersByDate identifiers =
    reverse $ sortBy byDate identifiers
        where
            byDate id1 id2 =
                let fn1 = takeFileName $ toFilePath id1
                    fn2 = takeFileName $ toFilePath id2
                    parseTime' fn = parseTime defaultTimeLocale "%Y-%m-%d" $ intercalate "-" $ take 3 $ splitAll "-" fn
                in compare ((parseTime' fn1) :: Maybe UTCTime) ((parseTime' fn2) :: Maybe UTCTime)


--------------------------------------------------------------------------------
-- | Render a simple tag list in HTML, with the tag count next to the item
renderTagListLines :: Tags -> Compiler (String)
renderTagListLines = renderTags makeLink (intercalate ",<br>")
  where
      makeLink tag url count _ _ = renderHtml $
          H.a ! A.href (toValue url) $ toHtml (tag ++ " (" ++ show count ++ ")")
