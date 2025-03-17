{
  config,
  pkgs,
  ...
}:
let
  palette = config.lib.stylix.colors.withHashtag;
in
{
  stylix.targets.kitty.enable = false;
  home.packages = with pkgs; [ kitty ];
  programs.kitty = {
    enable = true;
    keybindings = {
      "kitty_mod+h" = "kitty_scrollback_nvim --nvim-args --cmd 'lua vim.g.no_initial_picker=true'";
      "kitty_mod+g" =
        "kitty_scrollback_nvim --nvim-args --cmd 'lua vim.g.no_initial_picker=true' --config ksb_builtin_last_cmd_output";

      "alt+0" = "disable_ligatures_in all always";
      "alt+1" = "disable_ligatures_in all never";
    };
    settings = {
      mouse_hide_wait = -1;

      open_url_with = "zen";
      detect_urls = "yes";

      enable_audio_bell = "no";

      allow_remote_control = "socket-only";
      listen_on = "unix:/tmp/kitty";

      action_alias = "kitty_scrollback_nvim kitten $HOME/.local/share/nvim/lazy/kitty-scrollback.nvim/python/kitty_scrollback_nvim.py";

      cursor_trail = 1;

      font_size = 14;

      # colors
      background = palette.base00;
      foreground = palette.base05;
      selection_background = palette.base05;
      selection_foreground = palette.base00;
      url_color = palette.base0D;
      cursor = palette.base07;
      cursor_text_color = palette.base00;
      active_border_color = palette.base03;
      inactive_border_color = palette.base01;
      active_tab_background = palette.base00;
      active_tab_foreground = palette.base05;
      inactive_tab_background = palette.base01;
      inactive_tab_foreground = palette.base04;

      # first is normal second is bright
      # black
      color0 = palette.base00;
      color8 = palette.base03;
      # red
      color1 = palette.base08;
      color9 = palette.base10 or palette.base08;
      # green
      color2 = palette.base0B;
      color10 = palette.base13 or palette.base0B;
      # yellow
      color3 = palette.base0A;
      color11 = palette.base12 or palette.base0A;
      # blue
      color4 = palette.base0D;
      color12 = palette.base15 or palette.base0D;
      # magenta
      color5 = palette.base0E;
      color13 = palette.base16 or palette.base0E;
      # cyan
      color6 = palette.base0C;
      color14 = palette.base14 or palette.base0C;
      # white
      color7 = palette.base05;
      color15 = palette.base07;

      # Other (like palette.base16-shell)
      color16 = palette.base09;
      color17 = palette.base11;
      color18 = palette.base0F;
      color19 = palette.base17;
      color20 = palette.base04;
      color21 = palette.base06;
    };
  };
}
