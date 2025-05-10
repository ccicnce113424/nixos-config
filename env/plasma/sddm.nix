{ pkgs, ... }:
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    wayland.compositor = "kwin";
  };

  environment.systemPackages = with pkgs; [ kdePackages.sddm-kcm ];
}
