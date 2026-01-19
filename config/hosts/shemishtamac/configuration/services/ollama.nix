{ inputs, host, ... }:
let
  pkgs = inputs.nixpkgs-stable.legacyPackages."${host.system}";
in
with pkgs;
{
  environment.systemPackages = [ ollama ];

  launchd.user.agents.ollama = {
    path = [ ollama ];
    command = "${ollama}/bin/ollama serve";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      EnvironmentVariables = {
        OLLAMA_HOST = "127.0.0.1";
        OLLAMA_CONTEXT_LENGTH = "32768";
        OLLAMA_FLASH_ATTENTION = "1";
        OLLAMA_KV_CACHE_TYPE = "q8_0";
      };
    };
  };
}
