{ pkgs }:
let
  wtype = "${pkgs.wtype}/bin/wtype";
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  jq = "${pkgs.jq}/bin/jq";
  whisperModel = pkgs.fetchurl {
    url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-small.en.bin";
    sha256 = "c6138d6d58ecc8322097e0f987c32f1be8bb0a18532a3f88f734d1bbf9c41e5d";
  };
in
{
  dictate = pkgs.writeShellScript "dictate" ''
    set -euo pipefail
    runtime_dir="''${XDG_RUNTIME_DIR:-/tmp}/dictation-script"
    mkdir -p "$runtime_dir"
    pidfile="$runtime_dir/recording.pid"
    audiofile="$runtime_dir/audio.wav"
    lockfile="$runtime_dir/window-lock"
    returnfile="$runtime_dir/final-return"
    notify() { ${pkgs.libnotify}/bin/notify-send -t "$1" "Dictation" "$2"; }

    if [[ -f "$pidfile" ]] && kill -0 "$(cat "$pidfile")" 2>/dev/null; then
      pid="$(cat "$pidfile")"
      kill -TERM "$pid"
      wait "$pid" 2>/dev/null || true
      rm -f "$pidfile"
      notify 2000 "Transcribing..."
      text="$(${pkgs.whisper-cpp}/bin/whisper-cli -m ${whisperModel} -f "$audiofile" -l en -nt -np 2>/dev/null \
        | tr '\n' ' ' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"
      rm -f "$audiofile"
      if [[ -n "$text" ]]; then
        if [[ -f "$lockfile" ]]; then
          target="address:$(cat "$lockfile")"
          batch=""
          skipped=0

          append_key() {
            local mods="$1" key="$2" command
            command="dispatch hl.dsp.send_shortcut({ mods = \"$mods\", key = \"$key\", window = \"$target\" })"
            if [[ -n "$batch" ]]; then
              batch+=";"
            fi
            batch+="$command"
          }

          while IFS= read -r -n1 char || [[ -n "$char" ]]; do
            case "$char" in
              [a-z]|[0-9]) append_key "" "$char" ;;
              [A-Z]) append_key "SHIFT" "''${char,,}" ;;
              ' ') append_key "" "space" ;;
              $'\n') append_key "" "Return" ;;
              '.') append_key "" "period" ;;
              ',') append_key "" "comma" ;;
              "'") append_key "" "apostrophe" ;;
              ';') append_key "" "semicolon" ;;
              '/') append_key "" "slash" ;;
              '-') append_key "" "minus" ;;
              '=') append_key "" "equal" ;;
              '[') append_key "" "bracketleft" ;;
              ']') append_key "" "bracketright" ;;
              '\\') append_key "" "backslash" ;;
              '`') append_key "" "grave" ;;
              '!') append_key "SHIFT" "1" ;;
              '@') append_key "SHIFT" "2" ;;
              '#') append_key "SHIFT" "3" ;;
              '$') append_key "SHIFT" "4" ;;
              '%') append_key "SHIFT" "5" ;;
              '^') append_key "SHIFT" "6" ;;
              '&') append_key "SHIFT" "7" ;;
              '*') append_key "SHIFT" "8" ;;
              '(') append_key "SHIFT" "9" ;;
              ')') append_key "SHIFT" "0" ;;
              '_') append_key "SHIFT" "minus" ;;
              '+') append_key "SHIFT" "equal" ;;
              '{') append_key "SHIFT" "bracketleft" ;;
              '}') append_key "SHIFT" "bracketright" ;;
              '|') append_key "SHIFT" "backslash" ;;
              ':') append_key "SHIFT" "semicolon" ;;
              '"') append_key "SHIFT" "apostrophe" ;;
              '<') append_key "SHIFT" "comma" ;;
              '>') append_key "SHIFT" "period" ;;
              '?') append_key "SHIFT" "slash" ;;
              '~') append_key "SHIFT" "grave" ;;
              *) skipped=$((skipped + 1)) ;;
            esac
          done < <(printf '%s' "$text")

          if [[ -f "$returnfile" ]]; then
            append_key "" "Return"
          else
            # separate chained dictations when final-return is disabled.
            append_key "" "space"
          fi

          if [[ -n "$batch" ]]; then
            ${hyprctl} --quiet --batch "$batch"
          fi
          if (( skipped > 0 )); then
            notify 2500 "Skipped $skipped unsupported character(s)"
          fi
        else
          if [[ -f "$returnfile" ]]; then
            ${wtype} -- "$text"
            ${wtype} -k Return
          else
            ${wtype} -- "$text "
          fi
        fi
      else
        notify 2000 "No speech detected"
      fi
    else
      if [[ -f "$lockfile" ]]; then
        notify 1500 "Recording (locked)... press mod+d again to stop"
      else
        notify 1500 "Recording... press mod+d again to stop"
      fi
      ${pkgs.pipewire}/bin/pw-record --rate 16000 --channels 1 --format s16 "$audiofile" &
      echo $! > "$pidfile"
    fi
  '';

  dictate-return = pkgs.writeShellScript "dictate-return" ''
    set -euo pipefail
    runtime_dir="''${XDG_RUNTIME_DIR:-/tmp}/dictation-script"
    mkdir -p "$runtime_dir"
    returnfile="$runtime_dir/final-return"
    notify() { ${pkgs.libnotify}/bin/notify-send -t "$1" "Dictation" "$2"; }

    if [[ -f "$returnfile" ]]; then
      rm -f "$returnfile"
      notify 2000 "Final Enter disabled"
    else
      touch "$returnfile"
      notify 2000 "Final Enter enabled"
    fi
  '';

  dictate-lock = pkgs.writeShellScript "dictate-lock" ''
    set -euo pipefail
    runtime_dir="''${XDG_RUNTIME_DIR:-/tmp}/dictation-script"
    mkdir -p "$runtime_dir"
    lockfile="$runtime_dir/window-lock"
    notify() { ${pkgs.libnotify}/bin/notify-send -t "$1" "Dictation" "$2"; }

    if [[ -f "$lockfile" ]]; then
      rm -f "$lockfile"
      notify 2000 "Dictation unlocked"
    else
      addr="$(${hyprctl} activewindow -j | ${jq} -r '.address')"
      echo "$addr" > "$lockfile"
      title="$(${hyprctl} activewindow -j | ${jq} -r '.title')"
      notify 2000 "Dictation locked to: $title"
    fi
  '';
}
