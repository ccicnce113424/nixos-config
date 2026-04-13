{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf (builtins.elem "virtManager" config.runtime.features) {
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
  };
}
