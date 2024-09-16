{ ... }:

{
  networking.nftables.enable = true;
  networking.firewall.enable = true;

  programs.ssh.startAgent = true;

}
