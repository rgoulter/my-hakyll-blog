{
  pkgs ? import <nixpkgs> {},
  ghcVersion ? "910",
}:
pkgs.haskell.packages.${"ghc" + ghcVersion}.callPackage ./my-hakyll-blog.nix {}
