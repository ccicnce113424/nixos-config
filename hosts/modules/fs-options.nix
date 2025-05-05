{ config, lib, ... }:
{
  fileSystems = builtins.mapAttrs (name: fs: {
    options =
      [ "lazytime" ]
      ++ lib.optional ("/nix" == name) [ "noatime" ]
      ++ lib.optional ("/efi" == name || "/boot" == name) [ "umask=0077" ];
  }) config.fileSystems;
}
