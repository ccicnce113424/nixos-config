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
    ];
    shell = pkgs.zsh;
    initialPassword = "000000";
    autoSubUidGidRange = true;
  };
}
