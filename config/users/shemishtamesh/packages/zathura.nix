{ pkgs, ... }:
{
  programs.zathura = {
    enable = true;
    options = {
      guioptions = "none";
    };
    plugins = with pkgs; [ zathura-pk-epub ];
  };
}
