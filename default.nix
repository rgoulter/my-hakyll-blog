{
  pkgs ? import <nixpkgs> {},
  ghcVersion ? "98",
}:
pkgs.haskell.packages.${"ghc" + ghcVersion}.callPackage ./my-hakyll-blog.nix {}
