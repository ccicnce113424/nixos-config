import ../templates/desktop.nix [
  ../modules/nvidia.nix
  # ../modules/nouveau.nix
  ../modules/icpu.nix
  ./hardware-configuration.nix
]
