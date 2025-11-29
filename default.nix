{
  pkgs ? import <nixpkgs> {},
  ghcVersion ? "967",
}:
pkgs.haskell.packages.${"ghc" + ghcVersion}.callPackage ./my-hakyll-blog.nix {}
