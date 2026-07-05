{ stable-pkgs, ... }:
{
  programs.zathura = {
    enable = true;
    package = stable-pkgs.zathura;
    options = {
      guioptions = "none";
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.pwmt.zathura.desktop";
    };
  };
}
