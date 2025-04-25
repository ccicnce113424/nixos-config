{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  nix-config = {
    environment.systemPackages =
      with pkgs;
      [
        git
      ]
      ++ (
        let
          shellAliases = {
            switch = "sudo nixos-rebuild --fast --install-bootloader switch";
            cswitch = "switch --option substituters \"https://cache.nixos.org\"";
            gc = "nix-collect-garbage --delete-old";
            up = "nix flake update --commit-lock-file";
            upg = ''
              cd /etc/nixos
              git pull
              switch
              reboot
            '';
            clean = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system";
            clr = ''
              clean
              switch
              gc
            '';
            win = "systemctl reboot --boot-loader-entry=auto-windows";
            fw = "systemctl reboot --firmware-setup";
          };
        in
        map (name: (pkgs.writeShellScriptBin name shellAliases.${name})) (lib.attrNames shellAliases)
      );

    nixpkgs.config.allowUnfree = true;

    nix.settings = {
      experimental-features = "nix-command flakes";
      substituters = [
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        # "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        # "https://cache.garnix.io"
      ];
      extra-trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };
    system.stateVersion = "24.05";
  };
in
{
  options.smallPkgs = lib.mkOption {
    type = lib.types.pkgs;
    default = import inputs.nixpkgs-small {
      system = config.nixpkgs.system;
      config = config.nixpkgs.config;
      overlays = config.nixpkgs.overlays;
    };
  };

  config = nix-config;
}
