{
  config,
  shared,
  ...
}:
let
  palette = config.lib.stylix.colors.withHashtag;
in
{
  stylix.targets.kitty.enable = false;
  programs.kitty = {
    enable = true;
    keybindings = {
      "alt+0" = "disable_ligatures_in all always";
      "alt+1" = "disable_ligatures_in all never";
    };
    shellIntegration.enableZshIntegration = true;
    settings = {
      mouse_hide_wait = -1;

      hide_window_decorations = "yes";

      open_url_with = "zen";
      detect_urls = "yes";

      enable_audio_bell = "no";

      allow_remote_control = "socket-only";
      listen_on = "unix:/tmp/kitty";

      cursor_trail = 1;

      font_family = shared.theme.fonts.monospace.name;
      font_size = 14;

      macos_option_as_alt = "yes";

      # colors
      background = palette.base11 or palette.base00;
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
      color9 = palette.base12 or palette.base08;
      # green
      color2 = palette.base0B;
      color10 = palette.base14 or palette.base0B;
      # yellow
      color3 = palette.base0A;
      color11 = palette.base13 or palette.base0A;
      # blue
      color4 = palette.base0D;
      color12 = palette.base16 or palette.base0D;
      # magenta
      color5 = palette.base0E;
      color13 = palette.base17 or palette.base0E;
      # cyan
      color6 = palette.base0C;
      color14 = palette.base15 or palette.base0C;
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
