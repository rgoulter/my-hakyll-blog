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
    packages = [
      config.programs.treefmt.package
      pkgs.actionlint
      pkgs.just
      pkgs.shellcheck
    ];

    languages = {
      haskell.enable = true;
      nix.enable = true;
      python.enable = true;
    };
  };
}
