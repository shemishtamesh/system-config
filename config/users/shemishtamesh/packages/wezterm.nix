{
  programs.wezterm = {
    enable = true;
    extraConfig = # lua
      ''
        return {
          hide_tab_bar_if_only_one_tab = true
          font_size = 14.0,
        }
      '';
  };
}
