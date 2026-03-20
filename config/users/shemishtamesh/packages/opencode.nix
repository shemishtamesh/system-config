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
        "model": "ollama/qwen3-coder",
        "permission": {
          "external_directory": {
              "*": "ask"
          },
          "*": "ask",

          "doom_loop": "ask",

          "edit": "ask",

          "bash": {
              "*": "ask",

              "grep*": "allow",
              "ls*": "allow",

              "git status*": "allow",
              "git diff*": "allow",
              "git log*": "allow"
          }

          "read": "allow",
          "glob": "allow",
          "grep": "allow",
          "list": "allow",

          "lsp": "allow",
          "codesearch": "allow",

          "webfetch": "allow",
          "websearch": "allow",

          "todoread": "allow",
          "task": "allow",
          "skill": "allow",
        },
        "provider": {
          "ollama": {
            "npm": "@ai-sdk/openai-compatible",
            "options": {
              "baseURL": "http://localhost:11434/v1"
            },
            "models": {
              "qwen3-coder": {
                "tools": true
              },
            }
          }
        }
      }
    '';
}
