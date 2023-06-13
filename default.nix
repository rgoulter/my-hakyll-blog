{
  nixpkgs ? import <nixpkgs> {},
  compiler ? "ghc92",
}:
nixpkgs.pkgs.haskell.packages.${compiler}.callPackage ./my-hakyll-blog.nix {}
