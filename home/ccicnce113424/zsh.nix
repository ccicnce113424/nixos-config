{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./p10k-cfg;
        file = "p10k.zsh";
      }
    ];
    autocd = true;
    autosuggestion.enable = true;
    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "main"
        "brackets"
        "pattern"
        "regexp"
        "cursor"
        "root"
        "line"
      ];
    };
  };

  programs.autojump = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.pay-respects = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    dust
    tokei
  ];

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  programs = {
    fd.enable = true;
    ripgrep.enable = true;
    htop.enable = true;
    fastfetch.enable = true;
    bottom.enable = true;
    btop.enable = true;
  };
}
