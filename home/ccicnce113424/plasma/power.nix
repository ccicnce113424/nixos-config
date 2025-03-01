{ ... }:
{
  programs.plasma.powerdevil = {
    batteryLevels.criticalAction = "sleep";
    general.pausePlayersOnSuspend = true;

    AC = {
      autoSuspend = {
        action = "sleep";
        idleTimeout = 600;
      };
      dimDisplay = {
        enable = true;
        idleTimeout = 180;
      };
      inhibitLidActionWhenExternalMonitorConnected = true;
      powerButtonAction = "shutDown";
      turnOffDisplay = {
        idleTimeout = 300;
        idleTimeoutWhenLocked = 60;
      };
      whenLaptopLidClosed = "turnOffScreen";
      whenSleepingEnter = "hybridSleep";
    };

    battery = {
      autoSuspend = {
        action = "sleep";
        idleTimeout = 300;
      };
      dimDisplay = {
        enable = true;
        idleTimeout = 60;
      };
      inhibitLidActionWhenExternalMonitorConnected = true;
      powerButtonAction = "shutDown";
      turnOffDisplay = {
        idleTimeout = 120;
        idleTimeoutWhenLocked = 60;
      };
      whenLaptopLidClosed = "turnOffScreen";
      whenSleepingEnter = "hybridSleep";
    };

    lowBattery = {
      autoSuspend = {
        action = "sleep";
        idleTimeout = 120;
      };
      dimDisplay = {
        enable = true;
        idleTimeout = 30;
      };
      inhibitLidActionWhenExternalMonitorConnected = true;
      powerButtonAction = "shutDown";
      turnOffDisplay = {
        idleTimeout = 60;
        idleTimeoutWhenLocked = 60;
      };
      whenLaptopLidClosed = "turnOffScreen";
      whenSleepingEnter = "hybridSleep";

      powerProfile = "powerSaving";
    };
  };
}
