{
  host,
  lib,
  pkgs,
  ...
}:
let
  system_type = lib.last (lib.splitString "-" host.system);
in
{
  home.sessionVariables = {
    FLAKE = (import ../../shared/constants.nix pkgs).FLAKE_ROOT;
  }
  // (if system_type == "darwin" then { HOMEBREW_NO_ANALYTICS = 1; } else { });
}
