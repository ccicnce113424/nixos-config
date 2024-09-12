{ ... }: 

{
  imports = [
    ./plasma.nix
    ./sddm.nix
    ../modules/firefox.nix
  ];
}