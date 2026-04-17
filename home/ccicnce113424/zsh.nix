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
      {
        name = "p10k-jj-status";
        src = pkgs.fetchFromGitHub {
          owner = "xs5871";
          repo = "p10k-jj-status";
          rev = "a98672e1cd23f1010875bf6fb376a33b1740a484";
          hash = "sha256-hTKzE7hNgKwASC4RbyCW8S9F7KaTqqyLBKtkTM7Sz/w=";
        };
        file = "p10k-jj-status.plugin.zsh";
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

  programs.nix-index-database.comma.enable = true;

  programs = {
    fd.enable = true;
    ripgrep.enable = true;
    htop.enable = true;
    fastfetch.enable = true;
    bottom.enable = true;
    btop.enable = true;
  };
}
