{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem = {
    treefmt = {
      projectRootFile = "flake.nix";
      programs.nixfmt = {
        enable = true;
        priority = 0;
      };
      programs.nixf-diagnose = {
        enable = true;
        priority = 1;
      };
      settings.formatter.nixf-diagnose.options = [ "--auto-fix" ];
      programs.prettier.enable = true;
      programs.just.enable = true;
      programs.shfmt.enable = true;
    };
  };
}
