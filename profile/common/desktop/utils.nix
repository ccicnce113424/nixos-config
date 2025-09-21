{ pkgs, ... }:
{
  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override {
      extraPkgs =
        pkgs: with pkgs; [
          icu
          xorg.libxshmfence
          webkitgtk_4_1
          libsoup_3
          libepoxy
        ];
    };

  };

  services.flatpak = {
    enable = true;
    update.onActivation = true;
    # remotes = [
    #   {
    #     name = "flathub";
    #     location = "https://mirror.sjtu.edu.cn/flathub";
    #   }
    # ];
    uninstallUnmanaged = true;
  };
  services.fwupd.enable = true;

  environment.systemPackages = with pkgs; [
    wl-clipboard-rs

    resources

    podman-compose
    podman-desktop
    xorg.xwininfo

    linux-wifi-hotspot

    moonlight-qt
  ];
  services.smartd.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

  services.samba = {
    enable = true;
    # TODO: remove override when cephfs is fixed
    package = pkgs.sambaFull.override { enableCephFS = false; };
    openFirewall = true;
    nsswins = true;
    usershares.enable = true;
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  # open port for lan-mouse and qbittorrent
  # set qbittorrent port to 62180
  networking.firewall = {
    allowedTCPPorts = [ 62180 ];
    allowedUDPPorts = [
      62180
      4242
    ];
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };
}
