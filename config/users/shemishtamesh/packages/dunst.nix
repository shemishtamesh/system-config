{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        offset = "8x8";

        separator_height = 2;
        padding = 10;
        frame_width = 2;
        corner_radius = 10;

        alignment = "center";
        icon_position = "right";

        idle_threshold = 120;
        timeout = 6;

        follow = "keyboard";
      };
    };
  };
}
