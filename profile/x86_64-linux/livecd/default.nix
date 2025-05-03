{
  pkgs,
  modulesPath,
  inputs,
  ...
}:
{
  isoImage.squashfsCompression = "zstd";
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix")
    inputs.daeuniverse.nixosModules.daed
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
  environment.systemPackages = [
    pkgs.git
    pkgs.elinks
  ];
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
    openFirewall = true;
  };
}
