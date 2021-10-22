### My Hakyll Blog.

If you found this repo looking for cool things to "borrow", feel free;
I'd recommend looking at the commits which improved the site rather than
the `site.hs` as a whole.

I've added onto `site.hs` which the default does have include:

* Tags, Categories for posts.

* Pagination and Teaser text. This was done slightly differently from Hakyll's
  in-built pagination/teasers.

* Next/Previous Post links in the post.

## Instructions to Build

I have my `posts` in a git submodule.

The content of `posts/` is a tree of files named:

```
posts/<category>/YYYY-MM-DD-title.markdown
```

### Using Stack

I've found it easiest to just use Haskell Stack.

```
stack build
```

Then the `hakyll` site executable can be `exec`'d using `stack`:

```
stack exec site build
```

### Using Stack, Using Nix

Using [nix](https://nixos.org/) to retrieve the GHC version:

e.g. to run the `build` Hakyll command:

```
stack --nix-shell-file=shell.nix run -- build
```

#### Running on Windows

cf. https://stackoverflow.com/questions/27616611/run-time-exception-when-attempting-to-print-a-unicode-character

It's best to run:

```
chcp.com 65001
```
