pkgs:
let
  object = {
    allowUnfree = true;
    cudaSupport = if pkgs.stdenv.system == "aarch64-darwin" then false else true;
  };
  config_text = pkgs.lib.generators.toPretty { } object;
in
{
  inherit object;
  file = pkgs.writeText "nixpkgs.nix" config_text;
}
