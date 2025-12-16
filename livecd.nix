{ inputs, ... }:
{
  flake.nixosConfigurations.livecd = inputs.nixpkgs.lib.nixosSystem rec {
    system = "x86_64-linux";
    modules = [
      (
        {
          pkgs,
          modulesPath,
          ...
        }:
        {
          isoImage.squashfsCompression = "zstd";
          imports = [
            inputs.daeuniverse.nixosModules.daed
            (modulesPath + "/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix")
          ];
          services.daed = {
            enable = true;
            package = inputs.nix-packages.packages.${system}.daed;
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
            elinks
            ntfsprogs-plus
          ];
          services.openssh = {
            enable = true;
            settings.PermitRootLogin = "yes";
            openFirewall = true;
          };
          boot.supportedFilesystems.bcachefs = true;
        }
      )
    ];
  };
}
