{ pkgs }:
{
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
}
