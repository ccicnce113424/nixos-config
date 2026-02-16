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
    _7zip-zstd-rar
    unrar
    libarchive
    fxz
    progress
    colorized-logs
    man-pages
  ];

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  users.users.root.initialPassword = "000000";

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
