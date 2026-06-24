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
      };
  };
  # These should go to project-specific environment

  # home.packages = with pkgs; [
  #   typescript-language-server
  #   tailwindcss-language-server
  #   vue-language-server
  # ];
}
