{ config, inputs, pkgs, ... }:
let
  palette = config.colorScheme.palette;
in
{
  programs.kitty.enable = true;
  # programs.kitty.font = {
  #   name = "FiraCode Nerd Font Mono";
  #   size = 12.0;
  # };
  # programs.kitty.settings = {
  #   # https://github.com/kdrag0n/base16-kitty/blob/master/templates/default.mustache
  #   background = "#${palette.base00}";
  #   foreground = "#${palette.base07}";
  #   selection_background = "#${palette.base06}";
  #   selection_foreground = "#${palette.base00}";
  #   url_color = "#${palette.base04}";
  #   cursor = "#${palette.base05}";
  #   cursor_text_color = "#${palette.base00}";
  #   active_border_color = "#${palette.base03}";
  #   inactive_border_color = "#${palette.base01}";
  #   active_tab_background = "#${palette.base00}";
  #   active_tab_foreground = "#${palette.base05}";
  #   inactive_tab_background = "#${palette.base01}";
  #   inactive_tab_foreground = "#${palette.base04}";
  #   tab_bar_background = "#${palette.base01}";
  #   wayland_titlebar_color = "#${palette.base00}";
  #   macos_titlebar_color = "#${palette.base00}";
  #   # normal
  #   color0 = "#${palette.base00}";
  #   color1 = "#${palette.base08}";
  #   color2 = "#${palette.base0B}";
  #   color3 = "#${palette.base0A}";
  #   color4 = "#${palette.base0D}";
  #   color5 = "#${palette.base0E}";
  #   color6 = "#${palette.base0C}";
  #   color7 = "#${palette.base05}";
  #   # bright
  #   color8 = "#${palette.base03}";
  #   color9 = "#${palette.base09}";
  #   color10 = "#${palette.base01}";
  #   color11 = "#${palette.base02}";
  #   color12 = "#${palette.base04}";
  #   color13 = "#${palette.base06}";
  #   color14 = "#${palette.base0F}";
  #   color15 = "#${palette.base07}";

  #   open_url_with = "firefox";
  #   detect_urls = "yes";

  #   enable_audio_bell = "no";

  #   allow_remote_control = "socket-only";
  #   listen_on = "unix:/tmp/kitty";

  #   action_alias = "kitty_scrollback_nvim kitten /home/shemishtamesh/.local/share/nvim/lazy/kitty-scrollback.nvim/python/kitty_scrollback_nvim.py";

  #   map = ''
  #     kitty_mod+h kitty_scrollback_nvim --no-nvim-args
  #     map kitty_mod+g kitty_scrollback_nvim --no-nvim-args --config ksb_builtin_last_cmd_output
  #   ''; # NOTE: map only on second because of how home-manager does this, but it's bad so it might get fixed in a later version
  #   mouse_map = "ctrl+shift+right press ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --no-nvim-args --config ksb_builtin_last_visited_cmd_output";
  # };
}

