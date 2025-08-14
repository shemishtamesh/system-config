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
      EnvironmentVariables.OLLAMA_HOST = "127.0.0.1";
    };
  };
}
