{ inputs, ... }:
{
  flake.nixosConfigurations.livecd = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      (
        {
          pkgs,
          modulesPath,
          ...
        }:
        {
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [ inputs.nix-packages.overlays.default ];
          isoImage.squashfsCompression = "zstd";
          imports = [
            inputs.nix-packages.nixosModules.daed
            (modulesPath + "/installer/cd-dvd/latest-kernel.nix")
            (modulesPath + "/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix")
          ];
          services.daed = {
            enable = true;
            openFirewall = {
              enable = true;
              port = 12345;
            };
            configDir = "/etc/daed";
            listen = "0.0.0.0:2023";
          };
          networking.firewall.allowedTCPPorts = [ 2023 ];
          environment.systemPackages = with pkgs; [
            git
            ntfsprogs-plus
          ];
          services.openssh = {
            enable = true;
            settings.PermitRootLogin = "yes";
            openFirewall = true;
          };
          boot.supportedFilesystems.bcachefs = true;

          services.xserver.videoDrivers = [ "nvidia" ];
          hardware.nvidia = {
            open = true;
            gsp.enable = true;
            modesetting.enable = true;
            powerManagement.enable = true;
            branch = "bleeding_edge";
          };
        }
      )
    ];
  };
}
