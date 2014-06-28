--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll

import Data.List (isPrefixOf, tails, findIndex, intercalate, sortBy)
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

-- for tags, follow tutorial from:
-- http://javran.github.io/posts/2014-03-01-add-tags-to-your-hakyll-blog.html

-- postsGlob :: Pattern
-- postsGlob = "posts/*"

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match (fromList ["about.rst", "contact.markdown"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    -- build up tags
    tags <- buildTags "posts/**.markdown" (fromCapture "tags/*.html")

    categories <- buildCategories "posts/**.markdown" (fromCapture "categories/*.html")

    rulesForTags categories (\tag -> "Posts in category \"" ++ tag ++ "\"")

    rulesForTags tags (\tag -> "Posts tagged \"" ++ tag ++ "\"")

    match "posts/**.markdown" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= saveSnapshot "teaser"
            >>= loadAndApplyTemplate "templates/post.html"    (postCtxWithTags tags)
            >>= loadAndApplyTemplate "templates/default.html" (postCtxWithTags tags)
            >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/**.markdown"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Archives"            `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls


    paginate 5 $ \index maxIndex itemsForPage -> do
        let id = fromFilePath $ (if index==1 then "" else show index ++ "/") ++ "index.html"
        create [id] $ do
            route idRoute
            compile $ do
                let allCtx =
                        field "recent" (\_ -> recentPostList) `mappend`
                        field "title" (\_ -> return "Blog") `mappend`
                        defaultContext
                    loadTeaser id = loadSnapshot id "teaser"
                                        >>= loadAndApplyTemplate "templates/teaser.html" (teaserCtx tags)
                                        >>= relativizeUrls
                items <- sequence $ map loadTeaser itemsForPage
                let itembodies = map itemBody items
                    postsCtx =
                        constField "posts" (concat itembodies) `mappend`
                        field "navlinkolder" (\_ -> return $ indexNavLink index 1 maxIndex) `mappend`
                        field "navlinknewer" (\_ -> return $ indexNavLink index (-1) maxIndex) `mappend`
                        field "recent" (\_ -> recentPostList) `mappend`
                        defaultContext
 
                makeItem ""
                    >>= loadAndApplyTemplate "templates/blogpage.html" postsCtx
                    >>= loadAndApplyTemplate "templates/default.html" allCtx
                    >>= relativizeUrls


{-
    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/**.markdown"
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Home"                `mappend`
                    field "taglist" (\_ -> renderTagList tags) `mappend`
                    field "categorylist" (\_ -> renderTagList categories) `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls
-}

    match "templates/*" $ compile templateCompiler


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
recentPostList :: Compiler String
recentPostList = do
    posts   <- fmap (take 10) . recentFirst =<< recentPosts
    itemTpl <- loadBody "templates/indexpostitem.html"
    list    <- applyTemplateList itemTpl defaultContext posts
    return list


--------------------------------------------------------------------------------
recentPosts :: Compiler [Item String]
recentPosts = do
    identifiers <- getMatches "posts/*"
    return [Item identifier "" | identifier <- identifiers]


--------------------------------------------------------------------------------
rulesForTags :: Tags -> (String -> String) -> Rules ()
rulesForTags tags titleForTag =
    tagsRules tags $ \tag pattern -> do
    let title = titleForTag tag -- "Posts tagged \"" ++ tag ++ "\""
    route idRoute
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
indexNavLink :: Int -> Int -> Int -> String
indexNavLink n d maxn = renderHtml ref
  where ref = if (refPage == "") then ""
              else H.a ! A.href (toValue $ toUrl $ refPage) $ 
                   (preEscapedString lab)
        lab = if (d > 0) then "Older Entries &raquo;" else "&laquo; Newer Entries"
        refPage = if (n + d < 1 || n + d > maxn) then ""
                  else case (n + d) of
                    1 -> "index.html"
                    _ -> (show $ n + d) ++ "/index.html"


--------------------------------------------------------------------------------
paginate:: Int -> (Int -> Int -> [Identifier] -> Rules ()) -> Rules ()
paginate itemsPerPage rules = do
    identifiers <- getMatches "posts/**.markdown"

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
