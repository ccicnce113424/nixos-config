{ pkgs, ... }:

{
  services.desktopManager.plasma6.enable = true;
  environment.systemPackages = [
    (pkgs.callPackage ./vulkan-hdr-layer.nix { })
  ];
  environment.sessionVariables = {
    ENABLE_HDR_WSI = "1";
  };
}
