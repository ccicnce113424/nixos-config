pkgs: username: {
  users.users.${username} = {
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
      "i2c"
    ];
    shell = pkgs.zsh;
    initialPassword = "000000";
    autoSubUidGidRange = true;
  };
}
