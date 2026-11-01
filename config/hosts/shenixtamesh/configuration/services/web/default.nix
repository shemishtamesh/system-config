{
  pkgs,
  stable-pkgs,
  multiverse,
  ...
}:
{
  imports = [
    ./caddy
    ./remote-pi-relay.nix
    ./pi-tts.nix
  ];

  services = {
    ollama = {
      enable = true;
      package = stable-pkgs.ollama-cuda;
      openFirewall = true;
      host = "0.0.0.0";
      port = 11434;
      environmentVariables = {
        OLLAMA_CONTEXT_LENGTH = "65536";
        OLLAMA_FLASH_ATTENTION = "1";
        OLLAMA_KV_CACHE_TYPE = "q8_0";
      };
      loadModels = [
        "qwen2.5-coder:7b"
        "ornith"
      ];
    };
    open-webui = {
      enable = true;
      package = (multiverse.at "55bfb4d7437bd4e09ab7cba58a43bd68eb310044").open-webui;
      environment = {
        ANONYMIZED_TELEMETRY = "False";
        DO_NOT_TRACK = "True";
        SCARF_NO_ANALYTICS = "True";
        OLLAMA_API_BASE_URL = "http://localhost:11434";
      };
      host = "0.0.0.0";
      openFirewall = true;
    };

    silverbullet = {
      enable = true;
      listenPort = 3030;
    };
  };
  systemd.services.silverbullet.environment = {
    SB_CHROME_PATH = "${pkgs.chromium}/bin/chromium";
    HOME = "/var/lib/silverbullet";
  };
}
