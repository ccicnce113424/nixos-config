{ config, pkgs, ...}:

{
  security.tpm2 = {
    enable = true;
    abrmd.enable = true;
    pkcs11.enable = true;
  };

  networking.nftables.enable = true;
  networking.firewall.enable = true;

  programs.ssh.startAgent = true;

}