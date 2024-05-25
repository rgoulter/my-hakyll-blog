{
  nixpkgs ? import <nixpkgs> {},
  compiler ? "ghc92",
}:
(import ./default.nix {inherit nixpkgs compiler;}).env
