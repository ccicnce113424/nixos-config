{ ... }:
{
  programs.plasma.powerdevil =
    let
      commons = {
        autoSuspend.action = "sleep";
        dimDisplay.enable = true;
        inhibitLidActionWhenExternalMonitorConnected = true;
        powerButtonAction = "shutDown";
        turnOffDisplay.idleTimeoutWhenLocked = 60;
        whenLaptopLidClosed = "turnOffScreen";
        whenSleepingEnter = "standby";
      };
    in
    {
      batteryLevels.criticalAction = "sleep";
      general.pausePlayersOnSuspend = true;

      AC = commons // {
        autoSuspend.idleTimeout = 600;
        dimDisplay.idleTimeout = 180;
        turnOffDisplay.idleTimeout = 300;
      };
      battery = commons // {
        autoSuspend.idleTimeout = 300;
        dimDisplay.idleTimeout = 60;
        turnOffDisplay.idleTimeout = 120;
      };
      lowBattery = commons // {
        autoSuspend.idleTimeout = 120;
        dimDisplay.idleTimeout = 30;
        turnOffDisplay.idleTimeout = 60;
        powerProfile = "powerSaving";
      };
    };
}
