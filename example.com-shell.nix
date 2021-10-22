{ nixpkgs ? import ./nixpkgs-with-ghc843.nix
, compiler ? "ghc843"
}:

nixpkgs.mkShell {
  inputsFrom = [(import ./default.nix { inherit nixpkgs compiler; }).env];

  HAKYLL_PROVIDER_DIRECTORY = "provider-example.com";
}
