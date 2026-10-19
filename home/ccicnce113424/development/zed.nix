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
      "vscode-classic-themes"
    ];
    extraPackages = with pkgs; [
      bash-language-server
    ];
    userSettings = {
      session.trust_all_worktrees = true;
      # Appearance
      theme = {
        mode = "system";
        light = "Light Modern (VS Code)";
        dark = "Dark Modern (VS Code)";
      };
      ui_font_family = ".SystemUIFont";
      buffer_font_family = "Maple Mono NF CN";
      agent.dock = "right";
      project_panel.dock = "left";
      git_panel.dock = "left";
      agent.threads_sidebar.auto_open = false;
      # Features
      git_panel.tree_view = true;
      document_symbols = "off";
      document_folding_ranges = "on";
      semantic_tokens = "combined";
      terminal.env = rec {
        EDITOR = "zeditor --wait";
        GIT_EDITOR = EDITOR;
      };
      cli_default_open_behavior = "existing_window";
      # AI
      edit_predictions.provider = "copilot";
      agent_servers."codex-acp".type = "registry";
      agent_servers."Oh My Pi" = {
        type = "custom";
        command = "omp";
        args = [ "acp" ];
      };
      agent_servers."Reasonix" = {
        type = "custom";
        command = "reasonix";
        args = [ "acp" ];
      };
    };
  };

  home.packages = with pkgs; [
    krunner-zed
  ];

  dbus.packages = with pkgs; [
    krunner-zed
  ];
}
