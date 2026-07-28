{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ccic-hello
  ];

  system.replaceDependencies.replacements = [ ];

  boot.kernelPatches = [
    {
      name = "fix-amdgpu-hang";
      patch = pkgs.fetchpatch {
        url = "https://github.com/torvalds/linux/commit/52f650963d8825e97a0ccdd2b616f8a01d9d3d38.patch";
        hash = "sha256-9M7jX5nPjpmn4hr5tCQ6NfasSMtzga8v9nxNtuEDAgg=";
      };
    }
  ];
}
