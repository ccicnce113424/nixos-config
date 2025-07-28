{ pkgs, ... }:
{
  programs.lan-mouse = {
    enable = true;
    package = pkgs.lan-mouse;
  };

  programs.plasma.input = {
    keyboard.numlockOnStartup = "on";
    touchpads = [
      {
        vendorId = "04f3";
        productId = "3202";
        name = "ELAN06FA:01 04F3:3202 Touchpad";
        naturalScroll = true;
      }
    ];
  };
}
