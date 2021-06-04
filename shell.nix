{ pkgs ? import (builtins.fetchGit {
      name = "nixpkgs-with-ghc-8_4_3-a396";
      url = "https://github.com/NixOS/nixpkgs/";
      ref = "refs/heads/nixpkgs-unstable";
      rev = "a3962299f14944a0e9ccf8fd84bd7be524b74cd6";
  }) {}
}:
with pkgs;

mkShell {
  nativeBuildInputs = [
    ghc
    gmp
    zlib
    glibc
  ];
}
