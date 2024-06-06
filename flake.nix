# flake.nix, using serokell's template for cabal2nix
# https://github.com/serokell/templates/blob/master/haskell-cabal2nix/flake.nix
{
  description = "static site generator using hakyll";

  inputs = {
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
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
    devenv-root,
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
        devenv.flakeModule
        treefmt-nix.flakeModule
      ];

      perSystem = {
        config,
        pkgs,
        system,
        ...
      }: {
        devenv.shells.default = {pkgs, ...}: {
          devenv.root = let
            devenvRootFileContent = builtins.readFile devenv-root.outPath;
          in
            pkgs.lib.mkIf (devenvRootFileContent != "") devenvRootFileContent;

          # https://github.com/cachix/devenv/issues/528
          containers = pkgs.lib.mkForce {};

          languages.haskell.package = pkgs.haskell.packages.${"ghc" + ghcVersion}.ghc;

          programs.treefmt.package = config.treefmt.build.wrapper;

          imports = [./devenv.nix];
        };

        packages = {
          my-hakyll-blog = self.packages.${system}.default;

          default = pkgs.callPackage ./default.nix {inherit ghcVersion;};
        };

        treefmt = import ./treefmt.nix;
      };
    };
}
