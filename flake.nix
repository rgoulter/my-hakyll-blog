# flake.nix, using serokell's template for cabal2nix
# https://github.com/serokell/templates/blob/master/haskell-cabal2nix/flake.nix
{
  description = "static site generator using hakyll";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = (import nixpkgs {inherit system;}).pkgs;
      # c.f. pkgs/top-level/haskell-packages.nix
      compiler = "ghc92";
    in rec {
      packages = {
        my-hakyll-blog =
          pkgs.haskell.packages.${compiler}.callPackage ./my-hakyll-blog.nix {};

        default = self.packages.${system}.my-hakyll-blog;
      };

      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs.haskellPackages; [
          haskell-language-server
          ghcid
          cabal-install
          unordered-containers
        ];
        inputsFrom = [self.packages.${system}.default];
      };
    });
}
