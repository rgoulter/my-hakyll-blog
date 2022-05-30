{ nixpkgs ? import <nixpkgs> {}
, compiler ? "ghc902"
}:

nixpkgs.pkgs.haskell.packages.${compiler}.callPackage ./my-hakyll-blog.nix { }
