{ inputs, host, ... }:
let
  stable-pkgs = import inputs.nixpkgs-stable {
    system = host.system;
    config.allowUnfree = true;
  };
in
{
  home.packages = with stable-pkgs; [ opencode ];
  xdg.configFile."opencode/config.json".text = # json
    ''
      {
        "$schema": "https://opencode.ai/config.json",
        "model": "ollama/qwen3",
        "permission": {
          "*": "ask"
        },
        "provider": {
          "ollama": {
            "npm": "@ai-sdk/openai-compatible",
            "options": {
              "baseURL": "http://localhost:11434/v1"
            },
            "models": {
              "qwen3": {
                "tools": true
              },
            }
          }
        }
      }
    '';
}
