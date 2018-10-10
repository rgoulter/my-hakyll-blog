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

I have my `posts` in a git submodule, so:

```
git submodule init
git submodule update
```

and then to make the site:

### Using Stack

I've found it easiest to just use Haskell Stack.

```
stack build
```

Then the `hakyll` site executable can be `exec`'d using `stack`:

```
stack exec site build
```

#### Running on Windows

cf. https://stackoverflow.com/questions/27616611/run-time-exception-when-attempting-to-print-a-unicode-character

It's best to run:

```
chcp.com 65001
```
