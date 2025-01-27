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
      switch = "sudo nixos-rebuild --fast --install-bootloader switch";
      gc = "nix-collect-garbage --delete-old";
      up = "nix flake update --commit-lock-file";
      clean = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system";
      win = "systemctl reboot --boot-loader-entry=auto-windows";
      fw = "systemctl reboot --firmware-setup";
    };
  };

  programs.autojump = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.thefuck = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    dust
    tokei
    bottom
  ];

  programs = {
    fd.enable = true;
    ripgrep.enable = true;
    htop.enable = true;
    fastfetch.enable = true;
  };
}
