--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}

import Data.Monoid (mappend)
import Hakyll

import Data.List (isPrefixOf, tails, findIndex, intercalate, sortBy)
import Data.Maybe (fromMaybe, isNothing)
import Control.Applicative (Alternative (..))
import Control.Monad ((>=>), forM_, zipWithM_, liftM)
import GHC.IO.Encoding (setLocaleEncoding, utf8)
import System.Environment (lookupEnv)
import System.FilePath (takeFileName)

import Data.Time.Format (parseTimeM, defaultTimeLocale)
import Data.Time.Clock (UTCTime)

import Text.Blaze.Html.Renderer.String (renderHtml)
import Text.Blaze.Html ((!), preEscapedString, toHtml, toValue)
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

import Data.Hashable (Hashable, hashWithSalt)
import qualified Data.HashMap.Strict as HM

-- for tags, follow tutorial from:
-- http://javran.github.io/posts/2014-03-01-add-tags-to-your-hakyll-blog.html

-- Glob for matching the *.markdown posts under subdirectories of /posts/<category>/
postsGlob :: Pattern
postsGlob = "posts/**.markdown"

blogPageForPageNumber :: Int -> Identifier
blogPageForPageNumber index = fromFilePath $ (if index==1 then "" else show index ++ "/") ++ "index.html"

--------------------------------------------------------------------------------
hakyllConfigFromEnvironment :: IO Configuration
hakyllConfigFromEnvironment = do
  maybeDestinationDirectory <- lookupEnv "HAKYLL_DESTINATION_DIRECTORY"
  maybeStoreDirectory       <- lookupEnv "HAKYLL_STORE_DIRECTORY"
  maybeTmpDirectory         <- lookupEnv "HAKYLL_TMP_DIRECTORY"
  maybeProviderDirectory    <- lookupEnv "HAKYLL_PROVIDER_DIRECTORY"
  maybeDeployCommand        <- lookupEnv "HAKYLL_DEPLOY_COMMAND"
  maybeInMemoryCacheStr     <- lookupEnv "HAKYLL_IN_MEMORY_CACHE"
  maybePreviewHost          <- lookupEnv "HAKYLL_PREVIEW_HOST"
  maybePreviewPortStr       <- lookupEnv "HAKYLL_PREVIEW_PORT"
  -- inMemoryCache = False only if the env variable is set to "false".
  let maybeInMemoryCache = ("false" ==) <$> maybeInMemoryCacheStr
  let maybePreviewPort = read <$> maybePreviewPortStr
  return defaultConfiguration
         { destinationDirectory = fromMaybe (destinationDirectory defaultConfiguration) maybeDestinationDirectory
         , storeDirectory = fromMaybe (storeDirectory defaultConfiguration) maybeStoreDirectory
         , tmpDirectory = fromMaybe (tmpDirectory defaultConfiguration) maybeTmpDirectory
         , providerDirectory = fromMaybe (providerDirectory defaultConfiguration) maybeProviderDirectory
         , deployCommand = fromMaybe (deployCommand defaultConfiguration) maybeDeployCommand
         , inMemoryCache = fromMaybe (inMemoryCache defaultConfiguration) maybeInMemoryCache
         , previewHost = fromMaybe (previewHost defaultConfiguration) maybePreviewHost
         , previewPort = fromMaybe (previewPort defaultConfiguration) maybePreviewPort
         }

--------------------------------------------------------------------------------
main :: IO ()
main = do
  setLocaleEncoding utf8
  hakyllConfig <- hakyllConfigFromEnvironment
  hakyllWith hakyllConfig $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "js/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "pages/*" $ do
        route   $ gsubRoute "pages/" (const "") `composeRoutes` setExtension "html"
        compile $ pandocCompiler'
            >>= loadAndApplyTemplate "templates/page-body.html" defaultContext
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    -- build up tags
    tags <- buildTags postsGlob (fromCapture "tags/*.html")

    categories <- buildCategories postsGlob (fromCapture "categories/*.html")

    allPosts <- getMatches postsGlob
    let sortedPosts = sortIdentifiersByDate allPosts
        -- build hashmap of prev/next posts
        (prevPostHM, nextPostHM) = buildAdjacentPostsHashMap sortedPosts

    match postsGlob $ do
        route $ setExtension "html"
        compile $ do
            let postContext =
                    field "nextPost" (lookupPostUrl nextPostHM) `mappend`
                    field "prevPost" (lookupPostUrl prevPostHM) `mappend`
                    postContextWithTags tags

            pandocCompiler'
                >>= saveSnapshot "postContent"
                >>= loadAndApplyTemplate "templates/post-body.html" postContext
                >>= loadAndApplyTemplate "templates/default.html" postContext
                >>= relativizeUrls

    paginate <- buildPaginateWith
                    (sortRecentFirst >=>
                         \identifiers -> return $ paginateEvery 10 identifiers)
                    postsGlob
                    blogPageForPageNumber

    paginateRules paginate $ \index itemsForPage -> do
        route idRoute
        compile $ do
            let allContext =
                    constField "title" "Blog" `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/paginated_previews-body.html" (paginatedPreviewsContext paginate index itemsForPage tags categories)
                >>= loadAndApplyTemplate "templates/default.html" allContext
                >>= relativizeUrls


    tagsRules tags $ \tag postsPattern -> do
        route idRoute
        postListRules ("Posts tagged \"" ++ tag ++ "\"") postsPattern


    tagsRules categories $ \tag postsPattern -> do
        route idRoute
        postListRules ("Posts in category \"" ++ tag ++ "\"") postsPattern


    create ["archive.html"] $ do
        route idRoute
        postListRules "Archives" postsGlob


    create ["atom.xml"] $ do
        route idRoute
        compile $ do
            -- Use the blogpost's body as its $description$ in the Atom feed.
            let feedItemContext = defaultContext `mappend` bodyField "description"
            posts <- fmap (take 10) . recentFirst =<<
                loadAllSnapshots postsGlob "postContent"
            renderAtom feedConfiguration feedItemContext posts


    match "templates/*" $ compile templateCompiler


--------------------------------------------------------------------------------
-- | Pandoc compiler settings.
--
pandocCompiler' :: Compiler (Item String)
pandocCompiler' = pandocCompilerWith
  defaultHakyllReaderOptions
  defaultHakyllWriterOptions


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
-- | A context (for the tag-body, archive-body templates) that contains
--
--     - A @$date$@ field (formatted <Month name> <day of month>, <year>)
--     - A @$body$@ field
--     - Metadata fields
--     - A @$url$@ 'urlField'
--     - A @$path$@ 'pathField'
--     - A @$title$@ 'titleField'
postListContext :: String -> Compiler [Item String] -> Context String
postListContext title posts =
    constField "title" title `mappend`
    listField "posts" postListItemContext posts `mappend`
    defaultContext
  where
    postListItemContext = dateField "date" "%B %e, %Y" `mappend`
                          defaultContext


-- | A context that contains
--
--     - A @$tags$@ 'tagsField'
--     - A @$date$@ field (formatted <Month name> <day of month>, <year>)
--     - A @$body$@ field
--     - Metadata fields
--     - A @$url$@ 'urlField'
--     - A @$path$@ 'pathField'
--     - A @$title$@ 'titleField'
postContextWithTags :: Tags -> Context String
postContextWithTags tags =
    tagsField "tags" tags `mappend`
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext


-- | A context that contains
--
--     - A @$teaser$@ field
--     - A @$tags$@ 'tagsField'
--     - A @$date$@ field (formatted <Month name> <day of month>, <year>)
--     - A @$body$@ field
--     - Metadata fields
--     - A @$url$@ 'urlField'
--     - A @$path$@ 'pathField'
--     - A @$title$@ 'titleField'
teaserContext :: Tags -> Context String
teaserContext tags =
    field "teaser" teaserBody `mappend`
    postContextWithTags tags


-- | A context that contains
--
--     - A @$posts$@ field, which is HTML which contains all the post previews
--     - A @$navlinkolder$@ field, which links to the older page.
--     - A @$navlinkolder$@ field, which links to the newer page.
--     - A @$taglist$@ field, which is HTML which contains the tag cloud.
--     - A @$categorylist$@ field, which is HTML which contains the list of categories.
paginatedPreviewsContext :: Paginate -> Int -> Pattern -> Tags -> Tags -> Context String
paginatedPreviewsContext paginate index itemsForPagePattern tags categories =
    field "posts"
          (const concatenatedPostTeaserBodies) `mappend`
    tagCloudField "taglist" 80 200 tags `mappend`
    tagListLinesField "categorylist" categories `mappend`
    paginateContext paginate index
  where
    allSnapshots :: Compiler [Item String]
    allSnapshots = recentFirst =<< loadAllSnapshots itemsForPagePattern "postContent"
    itemBodyForTeaser :: Item String -> Compiler String
    itemBodyForTeaser item = itemBody <$> loadAndApplyTemplate "templates/teaser.html" (teaserContext tags) item
    concatenatedPostTeaserBodies :: Compiler String
    concatenatedPostTeaserBodies =
        allSnapshots
        >>= (fmap concat . mapM itemBodyForTeaser)


--------------------------------------------------------------------------------
postListRules :: String -> Pattern -> Rules ()
postListRules title postsPattern =
    compile $ do
        let context = postListContext title (recentFirst =<< loadAll postsPattern)

        makeItem ""
            >>= loadAndApplyTemplate "templates/post_list-body.html" context
            >>= loadAndApplyTemplate "templates/default.html" context
            >>= relativizeUrls

--------------------------------------------------------------------------------
type AdjPostHM = HM.HashMap Identifier Identifier


instance Hashable Identifier where
    hashWithSalt salt = hashWithSalt salt . show


buildAdjacentPostsHashMap :: [Identifier] -> (AdjPostHM, AdjPostHM)
buildAdjacentPostsHashMap posts =
    let buildHM :: [Identifier] -> [Identifier] -> AdjPostHM
        buildHM [] _ = HM.empty
        buildHM _ [] = HM.empty
        buildHM (k:ks) (v:vs) = HM.insert k v $ buildHM ks vs
    in (buildHM (tail posts) posts, buildHM posts (tail posts))


lookupPostUrl :: AdjPostHM -> Item String -> Compiler String
lookupPostUrl hm post =
    let ident = itemIdentifier post
        ident' = HM.lookup ident hm
    in
    (fmap (maybe empty toUrl) . (maybe empty getRoute)) ident'


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
    maxLengthTeaser s = if isNothing (findIndex (isPrefixOf "<!-- more -->") (tails s))
                        then unwords (take 60 (words s))
                        else s

    compactTeaser :: String -> String
    compactTeaser =
        -- Composition of
        -- (replaceAll <PAT> (const ""))
        let toReplace =
                [ "<iframe [^>]*>" , "<img [^>]*>" , "<p>" , "</p>"
                , "<blockquote>" , "</blockquote>" , "<strong>"
                , "</strong>" , "<ol>" , "</ol>" , "<ul>" , "</ul>"
                , "<li>" , "</li>" , "<h[0-9][^>]*>" , "</h[0-9]>"
                , "<pre.*" , "<a [^>]*>" , "</a>"
                ]
        in foldr (\pat f -> (replaceAll pat (const "")) . f) id toReplace


--------------------------------------------------------------------------------
sortIdentifiersByDate :: [Identifier] -> [Identifier]
sortIdentifiersByDate identifiers =
    sortBy (flip byDate) identifiers
      where
    byDate id1 id2 =
        let fn1 = takeFileName $ toFilePath id1
            fn2 = takeFileName $ toFilePath id2
            parseTime' fn = parseTimeM True defaultTimeLocale "%Y-%m-%d" $ intercalate "-" $ take 3 $ splitAll "-" fn
        in compare (parseTime' fn1 :: Maybe UTCTime) (parseTime' fn2 :: Maybe UTCTime)


--------------------------------------------------------------------------------
-- | Render a simple tag list in HTML, with the tag count next to the item
renderTagListLines :: Tags -> Compiler String
renderTagListLines =
    renderTags makeLink (intercalate ",<br>")
  where
    makeLink tag url count _ _ = renderHtml $
        H.a ! A.href (toValue url) $ toHtml (tag ++ " (" ++ show count ++ ")")


-- | Render a simple tag list in HTML, with the tag count next to the item
--   (<a> links, separated with ",<br>").
tagListLinesField :: String -> Tags -> Context String
tagListLinesField key tags =
   field key $ \_ -> renderTagListLines tags
