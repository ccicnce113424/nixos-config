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
      # Drop the pure/impure state; the shell name is enough.
      nix_shell.format = "\\[[$symbol($name)]($style)\\]";

      vcs.order = [
        "jj"
        "git"
      ];
    };
  };
}
