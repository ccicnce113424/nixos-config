{ pkgs, ... }:
{
  services.displayManager.sddm = {
    autoNumlock = true;
    enable = true;
    wayland.enable = true;
    wayland.compositor = "kwin";
  };

  environment.systemPackages = [ pkgs.kdePackages.sddm-kcm ];
}
