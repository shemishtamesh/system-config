{ stable-pkgs, ... }:
{
  programs.zathura = {
    enable = true;
    package = stable-pkgs.zathura;
    options = {
      guioptions = "none";
    };
  };
}
