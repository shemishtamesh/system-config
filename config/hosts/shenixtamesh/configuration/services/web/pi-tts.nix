{ ... }:
{
  virtualisation.oci-containers.containers.openedai-speech = {
    image = "ghcr.io/matatonic/openedai-speech-min";
    autoStart = true;
    ports = [ "127.0.0.1:8920:8000" ];
    volumes = [
      "openedai-speech-voices:/app/voices"
    ];
    environment = {
      EXTRA_ARGS = "--xtts_device none -H 0.0.0.0 -P 8000";
    };
  };
}
