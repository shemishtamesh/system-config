{
  programs.wezterm = {
    enable = true;
    extraConfig = # lua
      ''
        config.hide_tab_bar_if_only_one_tab = true
      '';
  };
}
