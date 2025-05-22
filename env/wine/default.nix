{ inputs, inputs', ... }:
{
  imports = [ inputs.nix-gaming.nixosModules.ntsync ];
  programs.wine.ntsync.enable = true;
  environment.systemPackages = with inputs'.nix-gaming.packages; [
    wine-tkg-ntsync
    winetricks-git
  ];
}
