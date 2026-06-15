pkgs:
let
  cudaSupport = pkgs.stdenv.system != "aarch64-darwin";
in
{
  allowUnfree = true;
  # inherit cudaSupport;
  cudaSupport = false;
  permittedInsecurePackages = [
    "electron-39.8.10" # TODO: remove this when https://github.com/NixOS/nixpkgs/issues/526914 is resolved
  ];
}
