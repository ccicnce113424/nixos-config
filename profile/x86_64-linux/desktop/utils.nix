{ pkgs, ... }:

{
  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: [
        pkgs.icu
      ];
    };

  };

  services.flatpak = {
    enable = true;
    # remotes = [
    #   {
    #     name = "flathub";
    #     location = "https://mirror.sjtu.edu.cn/flathub";
    #   }
    # ];
  };
  services.fwupd.enable = true;

  environment.systemPackages = [ pkgs.smartmontools ];
  services.smartd.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  xdg = {
    terminal-exec.enable = true;
    portal.xdgOpenUsePortal = true;
  };
}
