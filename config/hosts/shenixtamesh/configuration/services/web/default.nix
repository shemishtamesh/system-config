{
  pkgs,
  stable-pkgs,
  ...
}:
{
  imports = [ ./caddy ];

  services = {
    ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
      openFirewall = true;
      environmentVariables = {
        OLLAMA_HOST = "0.0.0.0";
        OLLAMA_CONTEXT_LENGTH = "65536";
        OLLAMA_FLASH_ATTENTION = "1";
        OLLAMA_KV_CACHE_TYPE = "q8_0";
      };
      loadModels = [
        "qwen2.5-coder:7b"
        "qwen3-coder"
      ];
    };
    open-webui = {
      enable = true;
      package = stable-pkgs.open-webui;
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
}
