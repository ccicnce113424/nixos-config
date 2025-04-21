{ pkgs, ... }:
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    wayland.compositor = "kwin";
  };

  environment.systemPackages = [ pkgs.kdePackages.sddm-kcm ];
}
