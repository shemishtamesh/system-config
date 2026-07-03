{ pkgs, config, ... }:
let
  cfg = config.programs.pi-coding-agent;
  jsonFormat = pkgs.formats.json { };
in
{
  programs.pi-coding-agent = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "pi-wrapped-${pkgs.pi-coding-agent.version}";
      paths = [ pkgs.pi-coding-agent ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/pi \
          --suffix PATH : ${
            pkgs.lib.makeBinPath (
              with pkgs;
              [
                nodejs
                python3
                gnumake
                gcc
              ]
            )
          } \
          --run 'export OPENROUTER_API_KEY="$(cat '"${
            config.sops.secrets."openrouter/general_api_key".path
          }"')"' \
          --run 'export OPENCODE_API_KEY="$(cat '"${config.sops.secrets."opencode/zen".path}"')"'
      '';
    };
    extraPackages = [ ];

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
        "npm:pi-subagents"
        "npm:pi-free"
        "npm:pi-intercom"
        "npm:pi-prompt-template-model"
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
        opencode = {
          apiKey = "$OPENCODE_API_KEY";
          models = [
            {
              id = "big-pickle";
              reasoning = true;
              contextWindow = 200000;
              maxTokens = 32000;
              cost = {
                input = 0;
                output = 0;
                cacheRead = 0;
                cacheWrite = 0;
              };
            }
          ];
        };
        openrouter = {
          baseUrl = "https://openrouter.ai/api/v1";
          api = "openai-completions";
          apiKey = "$OPENROUTER_API_KEY";
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

          "grep *" = "allow";
          "rg *" = "allow";

          "find *" = "allow";
          "find * -exec*" = "ask";
          "find * -execdir*" = "ask";

          ls = "allow";
          "ls *" = "allow";

          exa = "allow";
          "exa *" = "allow";

          eza = "allow";
          "eza *" = "allow";

          "cat *" = "allow";
          "head *" = "allow";
          "tail *" = "allow";
          "sort *" = "allow";
          "uniq *" = "allow";
          "wc *" = "allow";
          "file *" = "allow";
          "strings *" = "allow";

          tree = "allow";
          "tree *" = "allow";

          pwd = "allow";

          "which *" = "allow";

          env = "allow";
          "env *" = "allow";

          "echo *" = "allow";
          "printf *" = "allow";

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

          "nix log*" = "allow";
          "nix eval*" = "allow";
          "nix search*" = "allow";
          "nix why-depends*" = "allow";
          "nix flake show*" = "allow";
          "nix flake metadata*" = "allow";
          "nix flake check*" = "allow";
          "nix store diff-closures*" = "allow";
          "nix profile list*" = "allow";
          "nix profile history*" = "allow";
          "nix show*" = "allow";
          "nix describe*" = "allow";
        };

        webfetch = {
          "*" = "allow";
        };
        websearch = {
          "*" = "allow";
        };

        external_directory = "ask";
        path = {
          "**/*.envrc" = "ask";

          "**/*.env" = "deny";
          "**/*.env.local" = "deny";
          "**/*.env.prod" = "deny";

          "**/*.pem" = "deny";
          "**/*.key" = "deny";

          "~/.ssh/**" = "deny";
          "~/.secrets/**" = "deny";
          "~/.config/sops-nix/secrets/**" = "deny";
          "~/.config/sops/age/**" = "deny";
        };
      };
    };
  };
  sops.secrets."openrouter/general_api_key" = { };
  sops.secrets."opencode/zen" = { };

  home.packages = [
    (pkgs.buildNpmPackage {
      name = "pi-acp";
      src = pkgs.fetchurl {
        url = "https://registry.npmjs.org/pi-acp/-/pi-acp-0.0.31.tgz";
        hash = "sha256-H+ovaHoIKiNQEZn5OVnpw4oImx9up8whYgIZ4/ovZJE=";
      };
      npmDepsHash = "sha256-jT9o6oF62tGlIO47xXUScPEeIbsCVs8efFp/C63OdDw=";
      dontNpmBuild = true;
      postPatch = ''
        cp ${./pi-acp-lock.json} package-lock.json
        node -e "const fs=require('fs'),p=JSON.parse(fs.readFileSync('package.json','utf8'));p.scripts.build='true';fs.writeFileSync('package.json',JSON.stringify(p,null,2)+'\n')"
      '';
      meta = {
        mainProgram = "pi-acp";
      };
    })
  ];
}
