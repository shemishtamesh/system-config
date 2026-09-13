{
  pkgs,
  lib,
  ...
}:
{
  programs.zathura = {
    enable = true;
    options = {
      guioptions = "none";
    };
  };

  xdg.mimeApps = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.pwmt.zathura.desktop";
    };
  };
}
