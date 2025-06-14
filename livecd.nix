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
          isoImage.squashfsCompression = "zstd";
          imports = [
            inputs.daeuniverse.nixosModules.daed
            (modulesPath + "/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix")
          ];
          services.daed = {
            package = pkgs.daed;
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
            elinks
          ];
          services.openssh = {
            enable = true;
            settings.PermitRootLogin = "yes";
            openFirewall = true;
          };
        }
      )
    ];
  };
}
