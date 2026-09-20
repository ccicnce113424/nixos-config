{ ... }:
{
  services.scx-loader = {
    enable = true;
    config = {
      default_mode = "Auto";
      default_sched = "scx_p2dq";
      scheds.scx_p2dq.auto_mode = [
        "-a"
        "-f"
        "-y"
      ];
    };

    # schedsPackages = [
    #   (pkgs.runCommand "scx_customscheds" { inherit (pkgs.scx.rustscheds) passthru; } ''
    #     mkdir -p $out/bin
    #     ln -s ${pkgs.scx.rustscheds}/bin/* $out/bin/
    #     rm $out/bin/scx_pandemonium
    #     ln -s ${pkgs.scx_pandemonium}/bin/scx_pandemonium $out/bin/
    #   '')
    # ];
  };
}
