{ pkgs, ... }:
{
  fonts.fontconfig.enable = false;

  home.packages = with pkgs; [
    shijima-qt
    kdePackages.francis
    kdePackages.skanpage
    winboat
    llm-agents.hermes-agent
    llm-agents.hermes-desktop
  ];
}
