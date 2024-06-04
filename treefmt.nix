{pkgs, ...}: {
  projectRootFile = "flake.nix";
  programs.alejandra.enable = true;
  programs.cabal-fmt.enable = true;
  programs.ormolu.enable = true; # Haskell formatter
  programs.shellcheck.enable = true;
  programs.shfmt.enable = true;
}
