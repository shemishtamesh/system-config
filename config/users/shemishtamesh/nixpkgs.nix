pkgs:
let
  object = {
    allowUnfree = true;
    cudaSupport = if pkgs.stdenv.system == "aarch64-darwin" then false else true;
    permittedInsecurePackages = [ "electron-39.8.10" ]; # TODO: remove this when https://github.com/NixOS/nixpkgs/issues/526914 is resolved
  };
  config_text = pkgs.lib.generators.toPretty { } object;
in
{
  inherit object;
  file = pkgs.writeText "nixpkgs.nix" config_text;

}
