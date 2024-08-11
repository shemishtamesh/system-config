{ config, inputs, pkgs, ... }:
let
  palette = config.lib.stylix.colors.withHashtag;
in
{
  programs.kitty.enable = false;
  programs.kitty ={
    settings = {
      open_url_with = "librewolf";
      detect_urls = "yes";

      enable_audio_bell = "no";

      allow_remote_control = "socket-only";
      listen_on = "unix:/tmp/kitty";

      action_alias = "kitty_scrollback_nvim kitten /home/shemishtamesh/.local/share/nvim/lazy/kitty-scrollback.nvim/python/kitty_scrollback_nvim.py";

      background = palette.base00;
      foreground = palette.base05;
      selection_background = palette.base05;
      selection_foreground = palette.base00;
      url_color = palette.base0D;
      cursor = palette.base0D;
      cursor_text_color = palette.base00;
      active_border_color = palette.base03;
      inactive_border_color = palette.base01;
      active_tab_background = palette.base00;
      active_tab_foreground = palette.base05;
      inactive_tab_background = palette.base01;
      inactive_tab_foreground = palette.base04;

      # Normal
      color0 = palette.base00;
      color1 = palette.base08;
      color2 = palette.base0B;
      color3 = palette.base0A;
      color4 = palette.base0D;
      color5 = palette.base0E;
      color6 = palette.base0C;
      color7 = palette.base05;

      # (same as Normal except 8/15)
      color8 = palette.base03;
      color9 = palette.base08;
      color10 = palette.base0B;
      color11 = palette.base0A;
      color12 = palette.base0D;
      color13 = palette.base0E;
      color14 = palette.base0C;
      color15 = palette.base07;

      # Other (like palette.base16-shell)
      color16 = palette.base09;
      color17 = palette.base0F;
      color18 = palette.base01;
      color19 = palette.base02;
      color20 = palette.base04;
      color21 = palette.base06;
    };
    keybindings = {
      "kitty_mod+h" = "kitty_scrollback_nvim --no-nvim-args";
      "kitty_mod+g" = "kitty_scrollback_nvim --no-nvim-args --config ksb_builtin_last_cmd_output";
    };
  };
}

