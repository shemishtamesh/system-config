{ pkgs, ... }:
let
  whisperLargeV3 = pkgs.fetchurl {
    url = "https://blob.handy.computer/ggml-large-v3-q5_0.bin";
    hash = "sha256-11eV7P8/g7X6qJ0ZAGBK2MeAq9Vzn65AbeGfI+zZitE=";
  };

  settings = {
    settings_schema_version = 2;

    onboarding_completed = true;

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

    # Force the dark palette (System/Light/Dark)
    theme = "dark";

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

  home.file.".local/share/com.pais.handy/models/ggml-large-v3-q5_0.bin".source = whisperLargeV3;

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
