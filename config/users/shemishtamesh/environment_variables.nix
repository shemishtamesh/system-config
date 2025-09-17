{ host, lib, ... }:
let
  system_type = lib.last (lib.splitString "-" host.system);
in
{
  home.sessionVariables =
    { } // (if system_type == "darwin" then { HOMEBREW_NO_ANALYTICS = 1; } else { });
}
