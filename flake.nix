# flake.nix, using serokell's template for cabal2nix
# https://github.com/serokell/templates/blob/master/haskell-cabal2nix/flake.nix
{
  description = "static site generator using hakyll";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    self,
    nixpkgs,
    systems,
  }: let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
      # c.f. pkgs/top-level/haskell-packages.nix
      ghcVersion = "965";
    in {
      packages = eachSystem (system: let
        pkgs = (import nixpkgs {inherit system;}).pkgs;
      in {
        my-hakyll-blog = self.packages.${system}.default;

        default = pkgs.callPackage ./default.nix {inherit ghcVersion;};
      });

      devShells = eachSystem (system: let
        pkgs = (import nixpkgs {inherit system;}).pkgs;
      in {
        default = import ./shell.nix {
          inherit pkgs ghcVersion;
          my-hakyll-blog = self.packages.${system}.my-hakyll-blog;
        };
      });
    };
}
