{ pkgs ? import <nixpkgs> {}
, ghcVersion ? "92"
}:
pkgs.haskell.packages.${"ghc" + ghcVersion}.callPackage ./my-hakyll-blog.nix {}
