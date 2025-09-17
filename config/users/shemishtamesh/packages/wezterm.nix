{
  # stylix.targets.wezterm.enable = false;
  programs.wezterm = {
    enable = true;
    extraConfig = # lua
      ''
        return {
          bidi_enabled = true,
          bidi_direction = "LeftToRight",
          font_size = 14.0,
          hide_tab_bar_if_only_one_tab = true,
          window_padding = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0,
          }
        }
      '';
  };
}
