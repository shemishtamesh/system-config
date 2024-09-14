{ ... }:

{
  services.hypridle.enable = true;
  services.hypridle.settings = {
    general = {
      lock_cmd = "hyprlock";
      before_sleep_cmd = "hyprlock";
    };
    listener = [
      {
        timeout = 500;
        on-timeout = "notify-send idle";
        on-resume = "notify-send back";
      }
    ];
  };
}
