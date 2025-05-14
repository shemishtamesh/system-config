{
  services.skhd = {
    enable = true;
    skhdConfig = ''
      # move focus
      fn - j : yabai -m window --focus south
      fn - k : yabai -m window --focus north
      fn - l : yabai -m window --focus east
      fn - h : yabai -m window --focus west

      # swap windows
      fn + shift - j : yabai -m window --swap south
      fn + shift - k : yabai -m window --swap north
      fn + shift - l : yabai -m window --swap east
      fn + shift - h : yabai -m window --swap west

      # swap with split
      fn + ctrl - j : yabai -m window --warp south
      fn + ctrl - k : yabai -m window --warp north
      fn + ctrl - h : yabai -m window --warp west
      fn + ctrl - l : yabai -m window --warp east

      # move window window to display
      fn + shift - i : yabai -m window --display west
      fn + shift - o : yabai -m window --display east

      # switch spaces
      fn + ctrl - n : yabai -m window --space next
      fn + ctrl - p : yabai -m window --space prev

      # switch displays
      fn - i : yabai -m display --focus west
      fn - o : yabai -m display --focus east

      # rotate
      fn - r : yabai -m space --rotate 270
      fn + shift - r : yabai -m space --rotate 90

      # toggle float
      fn + ctrl - t : yabai -m window --toggle float --grid 4:4:1:1:2:2

      # toggle fullscreen
      fn + shift - f : yabai -m window --toggle zoom-fullscreen

      # balance windows
      fn - b : yabai -m space --balance

      # launch apps
      fn - t : kitty --execute tmux new-session -c $HOME
      fn - z : /Applications/Zen.app/Contents/MacOS/zen
      fn + shift - z : /Applications/Zen.app/Contents/MacOS/zen --private-window
    '';
  };
}
