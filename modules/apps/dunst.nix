{ ... }:

{
  services.dunst.enable = true;
  services.dunst.settings = {
    global = {
      offset = "8x8";
      separator_height = 2;
      padding = 10;
      # horizontal_padding = 12;
      # text_icon_padding = 12;
      frame_width = 2;
      # separator_color = "frame";
      idle_threshold = 120;
      # font = "JetBrainsMono Nerdfont 12";
      line_height = 0;
      # format = "<b>%s</b>\n%b";
      alignment = "center";
      icon_position = "off";
      # startup_notification = "false";
      corner_radius = 10;

      timeout = 2;
    };
  };
}
