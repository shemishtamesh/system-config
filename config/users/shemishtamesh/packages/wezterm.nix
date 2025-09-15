{
  programs.wezterm = {
    enable = true;
    extraConfig = # lua
      ''
        return {
          bidi_enabled = true,
          bidi_direction = "LeftToRight",
          hide_tab_bar_if_only_one_tab = true,
          font_size = 14.0,
        }
      '';
  };
}
