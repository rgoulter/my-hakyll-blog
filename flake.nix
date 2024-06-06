# flake.nix, using serokell's template for cabal2nix
# https://github.com/serokell/templates/blob/master/haskell-cabal2nix/flake.nix
{
  description = "static site generator using hakyll";

  inputs = {
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    devenv,
    flake-parts,
    nixpkgs,
    systems,
    treefmt-nix,
  }: let
    # c.f. pkgs/top-level/haskell-packages.nix
    ghcVersion = "965";
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import systems;

      imports = [
        treefmt-nix.flakeModule
      ];

      perSystem = {
        config,
        pkgs,
        system,
        ...
      }: {
        devShells = {
          default = devenv.lib.mkShell {
            inherit inputs pkgs;

            modules = [
              ({pkgs, ...}: {
                languages.haskell.package = pkgs.haskell.packages.${"ghc" + ghcVersion}.ghc;
              })
              (import ./devenv.nix)
            ];
          };
        };

        packages = {
          my-hakyll-blog = self.packages.${system}.default;

          default = pkgs.callPackage ./default.nix {inherit ghcVersion;};
        };

        treefmt = import ./treefmt.nix;
      };
    };
}
