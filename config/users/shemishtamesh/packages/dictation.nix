{ pkgs, ... }:
let
  whisperModel = pkgs.fetchurl {
    url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-small.bin";
    sha256 = "0ywqxbziyp2bv72riyjpw4brk9v46d4cfbjfwqvvjrrq0srakqqv";
  };
  dictate = pkgs.writeShellScriptBin "dictate" ''
    set -euo pipefail
    runtime_dir="''${XDG_RUNTIME_DIR:-/tmp}"
    pidfile="$runtime_dir/dictate.pid"
    audiofile="$runtime_dir/dictate-audio.wav"
    notify() { ${pkgs.libnotify}/bin/notify-send -t "$1" "Dictation" "$2"; }

    if [[ -f "$pidfile" ]] && kill -0 "$(cat "$pidfile")" 2>/dev/null; then
      pid="$(cat "$pidfile")"
      kill -TERM "$pid"
      wait "$pid" 2>/dev/null || true
      rm -f "$pidfile"
      notify 2000 "Transcribing..."
      text="$(${pkgs.whisper-cpp}/bin/whisper-cli -m ${whisperModel} -f "$audiofile" -l auto -nt -np 2>/dev/null \
        | tr '\n' ' ' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"
      rm -f "$audiofile"
      if [[ -n "$text" ]]; then
        ${pkgs.wtype}/bin/wtype -- "$text"
      else
        notify 2000 "No speech detected"
      fi
    else
      notify 1500 "Recording... press mod+d again to stop"
      ${pkgs.pipewire}/bin/pw-record --rate 16000 --channels 1 --format s16 "$audiofile" &
      echo $! > "$pidfile"
    fi
  '';
in
{
  home.packages = [ dictate ];
}
