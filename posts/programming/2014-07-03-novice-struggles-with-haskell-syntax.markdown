---
title: Novice Struggles with Haskell Syntax
author: Richard Goulter
tags: haskell, hakyll
---

I've been trying to augment my Hakyll Site with "next post", "previous post"
links in a post. There's a post in
[Hakyll Google group](https://groups.google.com/forum/#!topic/hakyll/WYPjtWMm9ZU)
asking for the same thing. (Maybe the majority of Hakyll owners just "adapt"
from other Hakyll sites...).

I've run into trouble trying to do this. Hakyll.Web.Template.Context
[source](http://jaspervdj.be/hakyll/reference/src/Hakyll-Web-Template-Context.html)
was a useful start.  
But the trouble I ran into due to lack of experience, or understanding, of
some (fundamental) Haskell concepts.

Ugh.

In this excerpt, `postContext` is out of scope:

```haskell
    match postsGlob $ do
        route $ setExtension "html"
        compile $ do 
            -- Cyclic dependencies here here:
            identifiers <- getMatches postsGlob
            urls <- urlsOfPosts =<< recentFirst =<< return [Item identifier "" | identifier <- identifiers]

            let postContext =
                    field "nextPost" (nextPostUrl urls) `mappend`
                    postCtxWithTags tags

            pandocCompiler
            >>= saveSnapshot "teaser"
            >>= loadAndApplyTemplate "templates/post.html"    postContext
            >>= loadAndApplyTemplate "templates/default.html" postContext
            >>= relativizeUrls
```

(Yeah, I know, it's a heinously long line).  
Whereas in this excerpt, it's in scope:

```haskell
    match postsGlob $ do
        route $ setExtension "html"
        compile $ do 
            -- Cyclic dependencies here here:
            identifiers <- getMatches postsGlob
            urls <- urlsOfPosts =<< recentFirst =<< return [Item identifier "" | identifier <- identifiers]

            let postContext =
                    field "nextPost" (nextPostUrl urls) `mappend`
                    postCtxWithTags tags

            pandocCompiler
                >>= saveSnapshot "teaser"
                >>= loadAndApplyTemplate "templates/post.html"    postContext
                >>= loadAndApplyTemplate "templates/default.html" postContext
                >>= relativizeUrls
```

I guess this is why people don't like Python or other non-C syntaxes
where indentation matters.  
I was able to figure that out, and considering this excerpt:

```haskell
    urlOfPost :: Item String -> Compiler String
    urlOfPost =
        fmap (maybe empty $ toUrl) . getRoute . itemIdentifier
```

But `urlsOfPosts` (used in above excerpt) has type
`urlsOfPosts :: [Item String] -> Compiler [String]`.  
While it's possible to understand `urlOfPost` by looking at the
documentation of each part, it's not clear to me the implementation of
`urlsOfPosts`.
