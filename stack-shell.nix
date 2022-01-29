{ nixpkgs ? import ./nixpkgs-with-ghc843.nix
, compiler ? "ghc843"
}:

nixpkgs.mkShell {
  buildInputs = with nixpkgs; [
    zlib
    pkgs.haskell.packages.${compiler}.ghc
  ] ++ (with darwin.apple_sdk.frameworks; [
    Cocoa
    CoreServices
  ]);
}
