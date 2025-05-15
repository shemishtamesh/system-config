{ host, lib, ... }:
let
  system_type = lib.last (lib.splitString "-" host.system);
in
{
  home.sessionVariables = {
    MANROFFOPT = "-c";
    MANWIDTH = "999";
    MANPAGER = "nvim +Man!";
    EDITOR = "nvim";
  } // (if system_type == "darwin" then host.system { HOMEBREW_NO_ANALYTICS = 1; } else { });
}
