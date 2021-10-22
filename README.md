### My Hakyll Blog.

If you found this repo looking for cool things to "borrow", feel free;
I'd recommend looking at the commits which improved the site rather than
the `site.hs` as a whole.

I've added onto `site.hs` which the default does have include:

* Tags, Categories for posts.

* Pagination and Teaser text. This was done slightly differently from Hakyll's
  in-built pagination/teasers.

* Next/Previous Post links in the post.

## Runtime Configuration

The following environment variables can be set,
corresponding to the similarly named options in
Hakyll's [Configuration](https://hackage.haskell.org/package/hakyll-4.12.4.0/docs/Hakyll-Core-Configuration.html#t:Configuration):

- `HAKYLL_DESTINATION_DIRECTORY`
- `HAKYLL_STORE_DIRECTORY`
- `HAKYLL_TMP_DIRECTORY`
- `HAKYLL_PROVIDER_DIRECTORY`
- `HAKYLL_DEPLOY_COMMAND`
- `HAKYLL_IN_MEMORY_CACHE`
- `HAKYLL_PREVIEW_HOST`
- `HAKYLL_PREVIEW_PORT`

A default value will be used for the configuration
option if it is not set.

## Website Source Files Layout

The content of `posts/` is a tree of files named:

```
posts/<category>/YYYY-MM-DD-title.markdown
```

## Installing from Nix Shell

With [nix](https://nixos.org/) installed, this hakyll static site generator
can be run in a nix-shell. e.g. if `shell.nix` has contents:

```
{ pkgs ? import <nixpkgs> {} }:
with pkgs;
let
  my-hakyll-blog = callPackage (fetchFromGitHub {
      owner = "rgoulter";
      repo = "my-hakyll-blog";
      rev = "a3962299f14944a0e9ccf8fd84bd7be524b74cd6";
      sha256 = "06p69fwk6v8hgwhr37rl3qlbpdx8mv66dngpljzichh2ak35x9nm";
    }) {};
in
mkShell {
  buildInputs = [
    my-hakyll-blog
  ];
}
```

Then, the `my-hakyll-blog` program will be available from `nix-shell`.

The benefit of this approach is it avoids requiring manually cloning and building
the static site generator.

## Instructions to Build

### Using Nixpkgs

With [nix](https://nixos.org/) installed, this hakyll static site generator
can be built by running:

```
nix-build
```

and the resulting program can be run from `result/bin`, e.g.:

```
./result/bin/my-hakyll-blog build
```

##### Installing to Nix User Environment

If you want the program installed to your Nix user environment,
run:

```
nix-env --install --file default.nix
```

And this can be uninstalled with:

```
nix-env --uninstall my-hakyll-blog
```

### Using Stack

Using stack, the program can be run with e.g.:

```
stack run -- build
```

Alternatively, the program can be built with:

```
stack build
```

Then the `hakyll` site executable can be `exec`'d using `stack`, e.g.:

```
stack exec my-hakyll-blog -- build
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
