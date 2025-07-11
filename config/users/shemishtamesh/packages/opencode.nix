{ pkgs, ... }:
{
  home.packages = with pkgs; [ opencode ];
  xdg.configFile."opencode/config.json".text = # json
    ''
      {
        "$schema": "https://opencode.ai/config.json",
        "provider": {
          "ollama": {
            "npm": "@ai-sdk/openai-compatible",
            "options": {
              "baseURL": "http://localhost:11434/v1"
            },
            "models": {
              "devstral-65k": {
                "tools": true
              },
              "devstral": {
                "tools": true
              },
              "qwen3:8b-16k": {
                "tools": true
              },
              "qwen3:8b": {
                "tools": true
              }
            }
          }
        }
      }
    '';
}
