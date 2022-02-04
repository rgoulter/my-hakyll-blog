# flake.nix, using serokell's template for cabal2nix
# https://github.com/serokell/templates/blob/master/haskell-cabal2nix/flake.nix
{
  description = "static site generator using hakyll";

  inputs = {
    # A sufficiently old version of nixpkgs such that
    # it has ghc 8.4.3.
    #
    # Details found by using lazamar's nix package versions tool:
    #   https://lazamar.co.uk/nix-versions/
    nixpkgs = {
      url = "github:NixOS/nixpkgs/a3962299f14944a0e9ccf8fd84bd7be524b74cd6";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs { inherit system; }).pkgs;
        compiler = "ghc843";
      in rec {
        packages.my-hakyll-blog =
          pkgs.haskell.packages.${compiler}.callPackage ./my-hakyll-blog.nix { };

        defaultPackage = self.packages.${system}.my-hakyll-blog;

        apps.my-hakyll-blog = flake-utils.lib.mkApp { drv = packages.my-hakyll-blog; };

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

