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
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  }
  // (if system_type == "darwin" then { HOMEBREW_NO_ANALYTICS = 1; } else { });
}
