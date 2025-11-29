{
  nixpkgs ? import <nixpkgs> {},
  compiler ? "ghc98",
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
}
