{
  pkgs ? import <nixpkgs> {},
  ghcVersion ? "965",
}:
pkgs.haskell.packages.${"ghc" + ghcVersion}.callPackage ./my-hakyll-blog.nix {}
