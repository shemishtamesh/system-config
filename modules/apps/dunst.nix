{ ... }:

{
  services.dunst.enable = true;
  services.dunst.settings = {
    global = {
      offset = "6x8";
      separator_height = 2;
      padding = 10;
      frame_width = 2;
      idle_threshold = 120;
      line_height = 0;
      alignment = "center";
      icon_position = "right";
      # startup_notification = "false";
      corner_radius = 10;

      timeout = 2;
    };
  };
}
