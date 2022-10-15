{
  nixpkgs ? import <nixpkgs> {},
  compiler ? "ghc902",
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
