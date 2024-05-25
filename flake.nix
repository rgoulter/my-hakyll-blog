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
      ghcVersion = "965";
    in rec {
      packages = {
        my-hakyll-blog = self.packages.${system}.default;

        default = pkgs.callPackage ./default.nix {inherit ghcVersion;};
      };

      devShells.default = import ./shell.nix {
        inherit pkgs ghcVersion;
        my-hakyll-blog = self.packages.${system}.my-hakyll-blog;
      };
    });
}
