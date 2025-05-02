{
  services.yabai = {
    enable = true;
    config = {
      layout = "bsp";
      window_placement = "second_child";
      external_bar = "all:30:0";
      top_padding = "0";
      bottom_padding = "0";
      left_padding = "0";
      right_padding = "0";
      window_gap = "0";
      mouse_follows_focus = "on";
      focus_follows_mouse = "autofocus";
      mouse_modifier = "fn";
      mouse_action1 = "move";
      mouse_action2 = "resize";
    };
    extraConfig = # sh
      ''
        yabai -m mouse_drop_modifier swap

        yabai -m signal --add event=window_created action="sketchybar -m --trigger window_change &> /dev/null"
        yabai -m signal --add event=window_destroyed action="sketchybar -m --trigger window_change &> /dev/null"
      '';
  };
}
