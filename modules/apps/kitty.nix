{ config, inputs, pkgs, ... }:
# let
#   palette = config.theme.palette;
# in
{
  programs.kitty.enable = true;
  programs.kitty.settings = {
    open_url_with = "librewolf";
    detect_urls = "yes";

    enable_audio_bell = "no";

    allow_remote_control = "socket-only";
    listen_on = "unix:/tmp/kitty";

    action_alias = "kitty_scrollback_nvim kitten /home/shemishtamesh/.local/share/nvim/lazy/kitty-scrollback.nvim/python/kitty_scrollback_nvim.py";

    map = ''
      kitty_mod+h kitty_scrollback_nvim --no-nvim-args
      map kitty_mod+g kitty_scrollback_nvim --no-nvim-args --config ksb_builtin_last_cmd_output
    ''; # NOTE: map only on second because of how home-manager does this, but it's bad so it might get fixed in a later version
    mouse_map = "ctrl+shift+right press ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --no-nvim-args --config ksb_builtin_last_visited_cmd_output";
  };
}

