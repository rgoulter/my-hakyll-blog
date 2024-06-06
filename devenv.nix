{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    programs.treefmt = {
      package = lib.mkOption {
        defaultText = lib.literalMD "package for running `treefmt` in devshell";
      };
    };
  };

  config = {
    packages = with pkgs; [
      config.programs.treefmt.package
    ];

    languages = {
      haskell.enable = true;
      nix.enable = true;
      python.enable = true;
    };
  };
}
