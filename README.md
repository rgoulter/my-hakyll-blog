### My Hakyll Blog.

If you found this repo looking for cool things to "borrow", feel free;
I'd recommend looking at the commits which improved the site rather than
the `site.hs` as a whole.

"Cool things" I've added onto `site.hs` (not necessarily my creativity, mind)
which the default does have include:

* Tags, Categories for posts.

* Pagination and Teaser text. This was done slightly differently from Hakyll's
  in-built pagination/teasers.

* Next/Previous Post links in the post.

* Disqus comments. (Not really a Hakyll thing, but still).

Not really an HTML/CSS kinda guy.


## Instructions to Build
(More for me, than for you). Since I'm inclined to forget,  
I have my posts in a git submodule, so:

```
git submodule init
git submodule update
```

and then to make the side:

```
cabal sandbox init
cabal install hakyll-4.5.3.0
cabal exec ghc -- --make -threaded site.hs
```
