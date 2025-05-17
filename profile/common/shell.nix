{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pv
    tree
    python3Full
    zip
    unzipNLS
    _7zz
    unar
    libarchive
    progress
    (pkgs.runCommand "7z-alias" { buildInputs = with pkgs; [ _7zz ]; } ''
      mkdir -p $out/bin
      ln -s ${pkgs._7zz}/bin/7zz $out/bin/7z
    '')
  ];

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  programs.ssh.startAgent = true;
  services.openssh = {
    enable = true;
    openFirewall = true;
  };
}
