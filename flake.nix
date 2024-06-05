# flake.nix, using serokell's template for cabal2nix
# https://github.com/serokell/templates/blob/master/haskell-cabal2nix/flake.nix
{
  description = "static site generator using hakyll";

  inputs = {
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    nixpkgs,
    systems,
    treefmt-nix,
  }: let
    eachSystem = nixpkgs.lib.genAttrs (import systems);
    treefmtEval = eachSystem (system: treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} ./treefmt.nix);
    # c.f. pkgs/top-level/haskell-packages.nix
    ghcVersion = "965";
  in {
    checks = eachSystem (system: {
      formatting = treefmtEval.${system}.config.build.check self;
    });

    formatter = eachSystem (system: treefmtEval.${system}.config.build.wrapper);

    packages = eachSystem (system: let
      pkgs = (import nixpkgs {inherit system;}).pkgs;
    in {
      my-hakyll-blog = self.packages.${system}.default;

      default = pkgs.callPackage ./default.nix {inherit ghcVersion;};
    });

    devShells = eachSystem (system: let
      pkgs = (import nixpkgs {inherit system;}).pkgs;
    in {
      default = devenv.lib.mkShell {
        inherit inputs pkgs;

        modules = [
          ({pkgs, ...}: {
            languages.haskell.package = pkgs.haskell.packages.${"ghc" + ghcVersion}.ghc;
          })
          (import ./devenv.nix)
        ];
      };
    });
  };
}
