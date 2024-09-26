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
  pkgs,
  ...
}:
{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = true;
    gsp.enable = true;
    modesetting.enable = true;
    nvidiaSettings = true;
    nvidiaPersistenced = true;
    dynamicBoost.enable = false;
    powerManagement.enable = false;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  hardware.nvidia-container-toolkit.enable = true;

  hardware.graphics = {
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      nvidia-vaapi-driver
    ];
  };
}
