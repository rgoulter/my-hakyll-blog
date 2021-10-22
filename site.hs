--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}

import Data.Monoid (mappend)
import Hakyll

import Data.List (isPrefixOf, tails, findIndex, intercalate, sortBy)
import Data.Maybe (fromMaybe)
import Control.Applicative (Alternative (..))
import Control.Monad (forM_, zipWithM_, liftM)
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

blogPageForPageIdx :: Int -> String
blogPageForPageIdx index = (if index==1 then "" else show index ++ "/") ++ "index.html"

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
  let maybeInMemoryCache = ((==) "false") <$> maybeInMemoryCacheStr
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
        route   $ (gsubRoute "pages/" (const "")) `composeRoutes` setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/page-body.html" defaultContext
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    -- build up tags
    tags <- buildTags postsGlob (fromCapture "tags/*.html")

    categories <- buildCategories postsGlob (fromCapture "categories/*.html")

    rulesForTags categories (\tag -> "Posts in category \"" ++ tag ++ "\"")

    rulesForTags tags (\tag -> "Posts tagged \"" ++ tag ++ "\"")

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
                    postCtxWithTags tags

            pandocCompiler
                >>= saveSnapshot "teaser"
                >>= loadAndApplyTemplate "templates/post_content.html"    postContext
                >>= saveSnapshot "content"
                >>= loadAndApplyTemplate "templates/post-body.html" postContext
                >>= loadAndApplyTemplate "templates/default.html" postContext
                >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            let archiveContext =
                    listField "posts" postCtx (loadAll postsGlob >>= recentFirst) `mappend`
                    constField "title" "Archives" `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive-body.html" archiveContext
                >>= loadAndApplyTemplate "templates/default.html" archiveContext
                >>= relativizeUrls


    paginate 10 $ \index maxIndex itemsForPage -> do
        let id = fromFilePath $ blogPageForPageIdx index
        create [id] $ do
            route idRoute
            compile $ do
                let allContext =
                        field "title" (\_ -> return "Blog") `mappend`
                        defaultContext
                    loadTeaser id = loadSnapshot id "teaser"
                                        >>= loadAndApplyTemplate "templates/teaser.html" (teaserCtx tags)
                                        -- >>= relativizeUrls
                items <- sequence $ map loadTeaser itemsForPage
                let itembodies = map itemBody items
                    postsContext =
                        constField "posts" (concat itembodies) `mappend`
                        field "navlinkolder" (\_ -> return $ indexNavLink index 1 maxIndex) `mappend`
                        field "navlinknewer" (\_ -> return $ indexNavLink index (-1) maxIndex) `mappend`
                        tagCloudField "taglist" 80 200 tags `mappend`
                        field "categorylist" (\_ -> renderTagListLines categories) `mappend`
                        defaultContext

                makeItem ""
                    >>= loadAndApplyTemplate "templates/paginated_previews-body.html" postsContext
                    >>= loadAndApplyTemplate "templates/default.html" allContext
                    >>= relativizeUrls


    create ["atom.xml"] $ do
        route idRoute
        compile $ do
            let feedCtx = postCtx `mappend` bodyField "description"
            posts <- fmap (take 10) . recentFirst =<<
                loadAllSnapshots postsGlob "content"
            renderAtom feedConfiguration feedCtx posts


    match "templates/*" $ compile templateCompiler


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
postCtxWithTags tags =
    tagsField "tags" tags `mappend` postCtx


teaserCtx :: Tags -> Context String
teaserCtx tags =
    field "teaser" teaserBody `mappend`
    (postCtxWithTags tags)


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
    (fmap (maybe empty $ toUrl) . (maybe empty getRoute)) ident'


previousPostUrl :: [Identifier] -> Item String -> Compiler String
previousPostUrl sortedPosts post = do
    let ident = itemIdentifier post
        ident' = itemBefore sortedPosts ident
    (fmap (maybe empty $ toUrl) . (maybe empty getRoute)) ident'


nextPostUrl :: [Identifier] -> Item String -> Compiler String
nextPostUrl sortedPosts post = do
    let ident = itemIdentifier post
        ident' = itemAfter sortedPosts ident
    (fmap (maybe empty $ toUrl) . (maybe empty getRoute)) ident'


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
rulesForTags :: Tags -> (String -> String) -> Rules ()
rulesForTags tags titleForTag =
    tagsRules tags $ \tag pattern -> do
    let title = titleForTag tag -- "Posts tagged \"" ++ tag ++ "\""
    route idRoute
    compile $ do
        posts <- recentFirst =<< loadAll pattern
        let tagContext = constField "title" title
                  `mappend` listField "posts" postCtx (return posts)
                  `mappend` defaultContext

        makeItem ""
            >>= loadAndApplyTemplate "templates/tag-body.html" tagContext
            >>= loadAndApplyTemplate "templates/default.html" tagContext
            >>= relativizeUrls


--------------------------------------------------------------------------------
-- | Split list into equal sized sublists.
-- https://github.com/ian-ross/blog
chunk :: Int -> [a] -> [[a]]
chunk n [] = []
chunk n xs =
    ys : chunk n zs
  where
    (ys,zs) = splitAt n xs


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
-- | Generate navigation link HTML for stepping between index pages.
-- https://github.com/ian-ross/blog
--
indexNavLink :: Int -> Int -> Int -> String
indexNavLink n d maxn =
    renderHtml ref
  where
    ref = if (refPage == "")
          then ""
          else H.a ! A.href (toValue $ toUrl $ refPage) $ (preEscapedString lab)
    lab = if (d > 0) then "Older Entries &raquo;" else "&laquo; Newer Entries"
    refPage = if (n + d < 1 || n + d > maxn)
              then ""
              else blogPageForPageIdx (n + d)


--------------------------------------------------------------------------------
paginate:: Int -> (Int -> Int -> [Identifier] -> Rules ()) -> Rules ()
paginate itemsPerPage rules = do
    identifiers <- getMatches postsGlob

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
            parseTime' fn = parseTimeM True defaultTimeLocale "%Y-%m-%d" $ intercalate "-" $ take 3 $ splitAll "-" fn
        in compare ((parseTime' fn1) :: Maybe UTCTime) ((parseTime' fn2) :: Maybe UTCTime)


sortIdentifiersByDate :: [Identifier] -> [Identifier]
sortIdentifiersByDate identifiers =
    reverse $ sortBy byDate identifiers
      where
    byDate id1 id2 =
        let fn1 = takeFileName $ toFilePath id1
            fn2 = takeFileName $ toFilePath id2
            parseTime' fn = parseTimeM True defaultTimeLocale "%Y-%m-%d" $ intercalate "-" $ take 3 $ splitAll "-" fn
        in compare ((parseTime' fn1) :: Maybe UTCTime) ((parseTime' fn2) :: Maybe UTCTime)


--------------------------------------------------------------------------------
-- | Render a simple tag list in HTML, with the tag count next to the item
-- TODO: Maybe produce a Context here
renderTagListLines :: Tags -> Compiler (String)
renderTagListLines =
    renderTags makeLink (intercalate ",<br>")
  where
    makeLink tag url count _ _ = renderHtml $
        H.a ! A.href (toValue url) $ toHtml (tag ++ " (" ++ show count ++ ")")
