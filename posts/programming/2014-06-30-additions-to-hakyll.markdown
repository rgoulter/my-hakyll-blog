---
title: Additions to Hakyll
author: Richard Goulter
tags: hakyll, haskell
---

The basic Hakyll site is (thankfully) not too glamorous. Some features I wanted
to keep from WordPress include the tags, categories, pagination of posts,
and 'teaser' text for each post.

The repository for this site is at
[rgoulter/my-hakyll-blog](https://github.com/rgoulter/my-hakyll-blog)
if you want to see the actual commits.

### Tags
Doing a Google search for "hakyll tags" probably will lead you to the same
tutorial I found. But you found yourself here, so I'll point out I used
[this tutorial](http://javran.github.io/posts/2014-03-01-add-tags-to-your-hakyll-blog.html)

### Categories
The haddock documention for
[Hakyll.Web.Tags](http://jaspervdj.be/hakyll/reference/Hakyll-Web-Tags.html)
describes that
i. "Categories" are a special kind of "tag"; the only difference being a post
   can only belong to one category, but can have any number of tags.
ii. Hakyll determines a category for a post (by default) using the directory
    structure. e.g.: 
        ```posts/<category>/1970-01-01-a-post.markdown```
    has the category `<category>`.

If you've a reasonable idea of how you get from the tags, to the
context, to the produced HTML, then it should be fairly clear how to
add categories.  
[Here's the commit where I make the changes](https://github.com/rgoulter/my-hakyll-blog/commit/336e3aee488fee2bb9f63eee34c848e9e8f1ad41).
The trickiest part was that the [Glob](http://jaspervdj.be/hakyll/reference/Hakyll-Core-Identifier-Pattern.html)
needed to be "posts/\*\*.markdown" to match posts.

### Pagination and Teasers
These come hand in hand if you "adapt" from the same sites I did.  
The literate-haskell of [EAnalytica's site](http://www.eanalytica.com/site/)
has pretty candid comments discussing the Haskell it uses. In turn, EAnalytica
also borrows from [Danny Su's site](https://github.com/dannysu/hakyll-blog),
which is also useful for this.  
The easiest way to 'adapt' from these was to look first at EAnalytica's,
then at Danny Su's. (The limitation of Danny Su's site is the site's pagination
is only 2 posts per page, and the rule for pagination relies on that, unfortunately).
The more tedious part (unless you've got good control over your Haskell editor)
is getting the imports for the necessary utility functions.

One thing which tripped me up was that the code from these sites has
magic strings for the Posts pattern, and for the pagination URL.
([c.f.](https://github.com/rgoulter/my-hakyll-blog/commit/968b1c0f4e7c586532865ae99b02e08e63c8dc47)).

For a more direct indication of the code to incorporate,
[this is the commit](https://github.com/rgoulter/my-hakyll-blog/commit/990fe87776c5926321d723f938364719036943c5)
where my blog adds pagination and teasers.
