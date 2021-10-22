{ nixpkgs ? import ./nixpkgs-with-ghc843.nix
, compiler ? "ghc843"
}:

(import ./default.nix { inherit nixpkgs compiler; }).env
