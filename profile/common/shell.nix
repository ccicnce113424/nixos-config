{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    rsync
    fuc
    pv
    tree
    python3
    zip
    unzipNLS
    p7zip
    unar
    libarchive
    progress
    colorized-logs
  ];

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  programs.ssh.startAgent = true;
  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  programs.nh = {
    enable = true;
    flake = "$HOME/code/nixos-config";
  };
}
