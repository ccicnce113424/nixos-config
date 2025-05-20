{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      treefmt = {
        projectRootFile = "flake.nix";
        programs.nixfmt = {
          enable = true;
          package = pkgs.nixfmt-rfc-style;
        };
        programs.prettier.enable = true;
      };
    };
}
