{ pkgs, config, ... }:
let
  cfg = config.programs.pi-coding-agent;
  jsonFormat = pkgs.formats.json { };
in
{
  programs.pi-coding-agent = {
    enable = true;
    package = pkgs.pi-coding-agent;
    extraPackages = [ pkgs.nodejs ];

    settings = {
      defaultProvider = "ollama";
      defaultModel = "qwen3-coder";
      defaultThinkingLevel = "medium";
      theme = "dark";
      defaultProjectTrust = "ask";
      enableInstallTelemetry = false;
      collapseChangelog = true;

      packages = [
        "npm:pi-quick-perms"
        "npm:pi-agent-board"
      ];
    };

    models = {
      providers = {
        ollama = {
          baseUrl = "http://localhost:11434/v1";
          api = "openai-completions";
          apiKey = "ollama";
          models = [
            { id = "qwen3-coder"; }
            {
              id = "gemma4:26b";
              reasoning = true;
            }
          ];
        };
        openrouter = {
          baseUrl = "https://openrouter.ai/api/v1";
          api = "openai-completions";
          models = [
            { id = "google/gemma-4-26b-it"; }
          ];
        };
      };
    };
  };

  home.file."${cfg.configDir}/extensions/pi-quick-perms/config.json" = {
    source = jsonFormat.generate "pi-quick-perms-config.json" {
      permission = {
        "*" = "ask";

        read = "allow";
        glob = "allow";
        grep = "allow";

        write = {
          "*" = "ask";
          "*.md" = "allow";
        };
        edit = {
          "*" = "ask";
          "*.md" = "allow";
        };

        bash = {
          "*" = "ask";

          grep = "allow";
          "grep *" = "allow";

          rg = "allow";
          "rg *" = "allow";

          ls = "allow";
          "ls *" = "allow";

          exa = "allow";
          "exa *" = "allow";

          eza = "allow";
          "eza *" = "allow";

          cat = "allow";
          "cat *" = "allow";

          head = "allow";
          "head *" = "allow";

          tail = "allow";
          "tail *" = "allow";

          sort = "allow";
          "sort *" = "allow";

          uniq = "allow";
          "uniq *" = "allow";

          wc = "allow";
          "wc *" = "allow";

          file = "allow";
          "file *" = "allow";

          strings = "allow";
          "strings *" = "allow";

          tree = "allow";
          "tree *" = "allow";

          pwd = "allow";
          "pwd *" = "allow";

          which = "allow";
          "which *" = "allow";

          env = "allow";
          "env *" = "allow";

          echo = "allow";
          "echo *" = "allow";

          printf = "allow";
          "printf *" = "allow";

          timeout = "allow";
          "timeout *" = "allow";

          true = "allow";
          false = "allow";

          "git status*" = "allow";
          "git diff*" = "allow";
          "git log*" = "allow";
          "git show*" = "allow";
          "git blame*" = "allow";
          "git branch*" = "allow";
          "git rev-parse*" = "allow";
        };

        webfetch = {
          "*" = "allow";
        };
        websearch = {
          "*" = "allow";
        };

        external_directory = "ask";
        path = {
          "*.envrc" = "ask";

          "*.env" = "deny";
          "*.env.local" = "deny";
          "*.env.prod" = "deny";

          "*.pem" = "deny";
          "*.key" = "deny";
        };
      };
    };
  };
}
