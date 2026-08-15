pkgs:
let
  cudaSupport = pkgs.stdenv.system != "aarch64-darwin";
in
{
  allowUnfree = true;
  inherit cudaSupport;
}
