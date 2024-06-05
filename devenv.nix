{
  pkgs,
  config,
  ...
}: {
  packages = with pkgs; [
    treefmt
  ];

  languages = {
    haskell.enable = true;
    nix.enable = true;
    python.enable = true;
  };
}
