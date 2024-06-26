{
  pkgs ? import <nixpkgs> {},
  my-hakyll-blog ? import ./default.nix {},
  ghcVersion ? "965",
}:
pkgs.mkShell {
  packages = with pkgs; [
    (haskell-language-server.override {supportedGhcVersions = [ghcVersion];})
    ghcid
    cabal-install
  ];
  inputsFrom = [my-hakyll-blog];
}
