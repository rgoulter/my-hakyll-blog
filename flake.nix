# flake.nix, using serokell's template for cabal2nix
# https://github.com/serokell/templates/blob/master/haskell-cabal2nix/flake.nix
{
  description = "static site generator using hakyll";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs { inherit system; }).pkgs;
        compiler = "ghc902";
      in rec {
        packages.my-hakyll-blog =
          pkgs.haskell.packages.${compiler}.callPackage ./my-hakyll-blog.nix { };

        defaultPackage = self.packages.${system}.my-hakyll-blog;

        apps = {
          default = apps.my-hakyll-blog;
          my-hakyll-blog = flake-utils.lib.mkApp { drv = packages.my-hakyll-blog; };
        };

        defaultApp = apps.my-hakyll-blog;

        devShell = pkgs.mkShell {
          buildInputs = with pkgs.haskellPackages; [
            haskell-language-server
            ghcid
            cabal-install
          ];
          inputsFrom = builtins.attrValues self.packages.${system};
        };
      });
}

