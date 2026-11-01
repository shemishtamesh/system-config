{ pkgs }:
let
  whisperModel = pkgs.fetchurl {
    url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-small.en.bin";
    sha256 = "c6138d6d58ecc8322097e0f987c32f1be8bb0a18532a3f88f734d1bbf9c41e5d";
  };
in
{
  dictate = pkgs.writeShellScript "dictate" ''
    export PATH=${
      pkgs.lib.makeBinPath [
        pkgs.wtype
        pkgs.hyprland
        pkgs.libnotify
        pkgs.pipewire
        pkgs.whisper-cpp
      ]
    }:"$PATH"
    exec ${pkgs.python3}/bin/python3 ${./dictation.py} --whisper-model ${whisperModel} "$@"
  '';
}
