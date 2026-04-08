{ pkgs, ... }:
{
  programs.zathura = {
    enable = true;
    options = {
      guioptions = "none";
    };
  };
  home.packages = with pkgs; [
    zathura-pdf-mupdf
  ];
}
