{
  pkgs,
  ...
}:
{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "toml"
      "make"
      "just"
      "ini"
      "log"
      "vscode-dark-modern"
    ];
    extraPackages = with pkgs; [
      just-lsp
      bash-language-server
    ];
    userSettings = {
      session.trust_all_worktrees = true;
      # Appearance
      theme = "VSCode Dark Modern";
      ui_font_family = ".SystemUIFont";
      buffer_font_family = "Maple Mono NF CN";
      # Features
      git_panel.tree_view = true;
      document_symbols = "off";
      document_folding_ranges = "on";
      semantic_tokens = "combined";
      terminal.env."EDITOR" = "zeditor --wait";
      # AI
      edit_predictions.provider = "copilot";
      agent_servers.github-copilot-cli.type = "registry";
    };
  };

  home.packages = with pkgs; [
    krunner-zed
  ];

  dbus.packages = with pkgs; [
    krunner-zed
  ];
}
