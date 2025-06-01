{ pkgs, ... }:
{
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        vhostUserPackages = with pkgs; [ virtiofsd ];
      };
    };
  };
  programs.virt-manager.enable = true;
}
