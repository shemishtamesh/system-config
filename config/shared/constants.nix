pkgs:
let
  FLAKE_ROOT = "$HOME/.config/system";
in
{
  inherit FLAKE_ROOT;
  FLAKE_ROOT_TILDE = pkgs.lib.replaceString "$HOME" "~" FLAKE_ROOT;
  FLAKE_REPO = "https://github.com/shemishtamesh/system-config.git";
  OS = builtins.elemAt (builtins.split "-" pkgs.stdenv.hostPlatform.system) 2;
}
