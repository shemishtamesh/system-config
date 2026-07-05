{ stable-pkgs, pkgs, lib, ... }:
{
  programs.zathura = {
    enable = true;
    package = stable-pkgs.zathura;
    options = {
      guioptions = "none";
    };
  };

  xdg.mime.defaultApplications = lib.mkIf pkgs.stdenv.isLinux {
    "application/pdf" = "org.pwmt.zathura.desktop";
  };
}
