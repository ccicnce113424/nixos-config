{ pkgs }:
with builtins;
rec {
  old-vulkan-headers = pkgs.vulkan-headers.overrideAttrs (
    _: prev: rec {
      version = "1.4.309.0";
      src = pkgs.fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "Vulkan-Headers";
        rev = "vulkan-sdk-${version}";
        hash = "sha256-LfJ7um+rzc4HdkJerHWkuPWeEc7ZFSBafbP+svAjklk=";
      };
    }
  );
  vk-hdr-layer = pkgs.nur.repos.xddxdd.vk-hdr-layer.override {
    vulkan-headers = old-vulkan-headers;
  };
  wpsoffice-365 = pkgs.nur.repos.novel2430.wpsoffice-365.overrideAttrs (old: {
    src = pkgs.fetchurl {
      url = "https://wps-linux-365.wpscdn.cn/wps/download/ep/Linux365/${last (splitVersion old.version)}/wps-office_${old.version}.AK.preload.sw_amd64.deb";
      hash = "sha256-N+2n6i7RCoKjAQ6Pds/dpfupnKR624RUiGj2cQQFpHk=";
      curlOptsList = [ "-ehttps://365.wps.cn" ];
    };
  });
}
