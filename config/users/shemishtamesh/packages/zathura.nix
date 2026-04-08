{ pkgs, ... }:
{
  programs.zathura = {
    enable = true;
    options = {
      guioptions = "none";
    };
  };
  home.packages = with pkgs.zathuraPkgs; [
    zathura_pdf_mupdf
  ];
}
