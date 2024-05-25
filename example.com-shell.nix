{
  nixpkgs ? import <nixpkgs> {},
  compiler ? "ghc92",
}:
nixpkgs.mkShell {
  buildInputs = with nixpkgs;
    [
      zlib
      pkgs.haskell.packages.${compiler}.ghc
    ]
    ++ (with darwin.apple_sdk.frameworks; [
      Cocoa
      CoreServices
    ]);

  HAKYLL_PROVIDER_DIRECTORY = "provider-example.com";
}
