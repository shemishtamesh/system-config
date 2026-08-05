{
  stable-pkgs,
  pkgs,
  lib,
  ...
}:
{
  programs.zathura = {
    enable = true;
    package = stable-pkgs.zathura;
    options = {
      guioptions = "none";
    };
  };

  xdg.mimeApps = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.pwmt.zathura.desktop";
    };
  };
}
