{ ... }:
{
  programs.zed-editor = {
    extensions = [ "vue" ];
    userSettings.languages =
      let
        tslsps = [
          "typescript-language-server"
          "!vtsls"
          "..."
        ];
      in
      {
        "TypeScript".language_servers = tslsps;
        "JavaScript".language_servers = tslsps;
        "TSX".language_servers = tslsps;
        "CSS".language_servers = [
          "tailwindcss-intellisense-css"
          "!vscode-css-language-server"
          "..."
        ];
      };
  };
  # These should go to project-specific environment

  # home.packages = with pkgs; [
  #   typescript-language-server
  #   tailwindcss-language-server
  #   vue-language-server
  # ];
}
