{ ... }:
{
  programs.starship = {
    enable = true;

    presets = [
      "bracketed-segments"
      "nerd-font-symbols"
    ];

    settings = {
      format = "$username$hostname$directory$vcs$package$fill$sudo$cmd_duration$nix_shell$line_break$character";

      fill.symbol = " ";

      sudo.disabled = false;
      # sudo-rs rejects -N, so the default `sudo -Nnv` probe always fails.
      sudo.use_legacy_check = true;
      # Drop the pure/impure state; the shell name is enough.
      nix_shell.format = "\\[[$symbol($name)]($style)\\]";

      vcs.order = [
        "jj"
        "git"
      ];
    };
  };
}
