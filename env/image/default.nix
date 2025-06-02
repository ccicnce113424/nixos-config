{
  pkgs,
  lib,
  host,
  ...
}:
let
  gimp-base = pkgs.gimp3;
  xsane = pkgs.xsane.override {
    gimpSupport = true;
    gimp = gimp-base;
  };
  gimp-combined = pkgs.gimp3-with-plugins.override {
    plugins =
      lib.filter (
        pkg: lib.isDerivation pkg && !pkg.meta.broken or false && pkgs.gimp3Plugins.lightning != pkg
      ) (lib.attrValues pkgs.gimp3Plugins)
      ++ [
        (pkgs.runCommand "gimp-plugin-xsane" { buildInputs = [ xsane ]; } ''
          mkdir -p $out/${gimp-base.targetPluginDir}/xsane
          ln -s ${xsane}/bin/xsane $out/${gimp-base.targetPluginDir}/xsane
        '')
      ];
  };
in
{
  environment.systemPackages = [
    gimp-combined
    xsane
  ];

  programs.weylus = {
    enable = true;
    openFirewall = true;
    users = host.users;
  };
}
