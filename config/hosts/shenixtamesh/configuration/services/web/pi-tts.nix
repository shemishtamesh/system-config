{ ... }:
{
  virtualisation.oci-containers.containers.pi-tts = {
    image = "ghcr.io/remsky/kokoro-fastapi-cpu:v0.9.0";
    autoStart = true;
    ports = [ "127.0.0.1:8920:8880" ];
    environment = {
      API_LOG_LEVEL = "WARNING";
    };
  };
}
