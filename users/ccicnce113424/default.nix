{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf (builtins.elem "ccicnce113424" config.runtime.users) {
  users.users.ccicnce113424 = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "vboxusers"
      "podman"
      "samba"
      "rtkit"
      "audio"
      "pipewire"
      "uinput"
    ];
    shell = pkgs.zsh;
    initialPassword = "000000";
  };
}
