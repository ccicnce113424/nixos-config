{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem =
    { pkgs, ... }:
    {
      treefmt = {
        projectRootFile = "flake.nix";
        programs.deadnix = {
          enable = true;
          priority = 0;
        };
        programs.statix = {
          enable = true;
          priority = 1;
        };
        programs.nixfmt = {
          enable = true;
          package = pkgs.nixfmt-rfc-style;
          priority = 2;
        };
        programs.prettier.enable = true;
        programs.just.enable = true;
        programs.shfmt.enable = true;
      };
    };
}
