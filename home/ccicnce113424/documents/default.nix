{ pkgs, ... }:
{
  home.packages = with pkgs; [
    libreoffice-qt6-fresh
    hunspell
    hunspellDicts.en_US
    pdf4qt
    kdePackages.kcharselect

    (pkgs.symlinkJoin {
      name = "wpsoffice-cn-fcitx";
      paths = [ pkgs.wpsoffice-cn ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        for exe in $out/bin/*;do
          wrapProgram $exe \
            --prefix XMODIFIERS : @im=fcitx\
            --prefix GTK_IM_MODULE : fcitx\
            --prefix QT_IM_MODULE : fcitx
        done
      '';
    })
  ];
}
