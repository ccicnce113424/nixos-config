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
    shellAliases = {
      apply = "sudo nixos-rebuild switch";
      sgc = "sudo nixos-collect-garbage --delete-old";
      gc = "nixos-collect-garbage --delete-old";
      upos = "sudo nix flake update /etc/nixos";
      clean = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system";
    };
  };

  programs.thefuck = {
    enable = true;
    enableZshIntegration = true;
  };
}
