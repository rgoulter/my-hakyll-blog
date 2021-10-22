{ nixpkgs ? import ./nixpkgs-with-ghc843.nix
, compiler ? "ghc843"
}:

nixpkgs.pkgs.haskell.packages.${compiler}.callPackage ./my-hakyll-blog.nix { }
