{
  ...
}:
{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "toml"
      "bash"
      "make"
      "just"
      "ini"
      "vscode-dark-modern"
    ];
    userSettings = {
      session.trust_all_worktrees = true;
      # Appearance
      theme = "VSCode Dark Modern";
      ui_font_family = ".SystemUIFont";
      buffer_font_family = "Maple Mono NF CN";
      # Features
      git_panel.tree_view = true;
      document_symbols = "on";
      document_folding_ranges = "on";
      semantic_tokens = "combined";
      terminal.env."GIT_EDITOR" = "zeditor --wait";
      # AI
      edit_predictions.provider = "copilot";
      agent_servers.github-copilot-cli.type = "registry";
    };
  };
}
