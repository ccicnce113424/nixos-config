#    _____         _   ___      _______ _____ _____
#   / ____|       | \ | \ \    / /_   _|  __ \_   _|   /\
#  | (___   ___   |  \| |\ \  / /  | | | |  | || |    /  \
#   \___ \ / _ \  | . ` | \ \/ /   | | | |  | || |   / /\ \
#   ____) | (_) | | |\  |  \  /   _| |_| |__| || |_ / ____ \ _
#  |_____/ \___/_ |_|_\_|_  \/ __|_____|_____/_____/_/    \_( )
#  |  ____| |  | |/ ____| |/ / \ \   / / __ \| |  | |       |/
#  | |__  | |  | | |    | ' /   \ \_/ / |  | | |  | |
#  |  __| | |  | | |    |  <     \   /| |  | | |  | |
#  | |    | |__| | |____| . \     | | | |__| | |__| |
#  |_|     \____/ \_____|_|\_\    |_|  \____/ \____/

{
  config,
  ...
}:
{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = true;
    gsp.enable = true;
    modesetting.enable = true;
    nvidiaSettings = true;
    videoAcceleration = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

  hardware.nvidia-container-toolkit.enable = true;
}
