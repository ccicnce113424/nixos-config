{ pkgs, ... }:
{
  fonts.fontconfig.enable = false;

  home.packages = builtins.attrValues {
    inherit (pkgs) shijima-qt;
    inherit (pkgs.kdePackages) francis skanpage;
    # winboat
    # llm-agents.hermes-agent
    # llm-agents.hermes-desktop
  };
}
