{ pkgs, ... }:
{
  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: [
        pkgs.icu
        pkgs.xorg.libxshmfence
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

  environment.systemPackages = [
    pkgs.smartmontools
    pkgs.python3Full
    pkgs.zip
    pkgs.unzipNLS
    pkgs._7zz
    pkgs.unar
    pkgs.libarchive
    pkgs.progress
    pkgs.podman-compose
    pkgs.xorg.xwininfo
    pkgs.pv

    (pkgs.symlinkJoin {
      name = "7z-alias";
      paths = [ pkgs._7zz ];
      postBuild = ''
        ln -s ${pkgs._7zz}/bin/7zz $out/bin/7z
      '';
    })
  ];
  services.smartd.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  virtualisation.waydroid.enable = true;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  xdg = {
    terminal-exec.enable = true;
    portal.xdgOpenUsePortal = true;
  };

  services.printing = {
    enable = true;
    cups-pdf = {
      enable = true;
      instances.PDF.settings.Out = "\${HOME}/cups-pdf";
    };
  };

  programs.ssh.startAgent = true;
  services.openssh = {
    enable = true;
    openFirewall = true;
  };
}
