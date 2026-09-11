{ pkgs, ... }:
let
  settings = {
    settings_schema_version = 2;

    # Shortcut: mod+d (super+d). On Wayland/Hyprland Handy's own global
    # shortcut can't grab keys, so this is driven by a Hyprland binding that
    # sends `handy --toggle-transcription` to the running instance. The
    # stored binding below is for Xorg/consistency (handy-keys `cmd` = win).
    bindings.transcribe = {
      id = "transcribe";
      name = "Transcribe";
      description = "Converts your speech into text.";
      default_binding = "cmd+d";
      current_binding = "cmd+d";
    };
    shortcut_activation = "hold_or_toggle";

    overlay_style = "live";
    overlay_position = "bottom";

    selected_language = "auto";
    translate_to_english = false;

    start_hidden = true;
    autostart_enabled = false;

    paste_method = "direct";
    typing_tool = "auto";

    append_trailing_space = true;
    auto_submit = false;

    model_unload_timeout = "min10";
  };
in
{
  home.packages = [ pkgs.handy ];
  home.file.".local/share/com.pais.handy/settings_store.json".text = builtins.toJSON settings;

  systemd.user.services.handy = {
    Unit = {
      Description = "Handy speech-to-text";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.handy}/bin/handy --start-hidden";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
