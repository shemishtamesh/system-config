{ pkgs, config, ... }:
let
  cfg = config.programs.pi-coding-agent;
  jsonFormat = pkgs.formats.json { };
  shared = import ../shared { };
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
          --run 'export OPENCODE_API_KEY="$(cat '"${config.sops.secrets."opencode/zen".path}"')"' \
          --run 'export OPENCODE_SHOW_PAID=true'
      '';
    };
    extraPackages = [ ];

    settings = {
      defaultProvider = "ollama";
      defaultModel = "ornith";
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
        "npm:pi-prompt-template-model"
      ];
    };

    models = {
      providers = {
        ollama = {
          baseUrl = shared.providers.ollama.baseUrl;
          api = "openai-completions";
          apiKey = "ollama";
          models = pkgs.lib.mapAttrsToList (
            name: cfg:
            { id = name; } // pkgs.lib.optionalAttrs (cfg.supportsThinking or false) { reasoning = true; }
          ) shared.providers.ollama.models;
        };
        opencode = {
          apiKey = "$" + shared.providers.opencode.apiKeyEnvVar;
          models = pkgs.lib.mapAttrsToList (
            name: cfg:
            {
              id = name;
            }
            // pkgs.lib.optionalAttrs (cfg.supportsThinking or false) { reasoning = true; }
            // (if cfg ? contextWindow then { contextWindow = cfg.contextWindow; } else { })
            // (if cfg ? maxTokens then { maxTokens = cfg.maxTokens; } else { })
            // (if cfg ? cost then { cost = cfg.cost; } else { })
          ) shared.providers.opencode.models;
        };
        openrouter = {
          baseUrl = shared.providers.openrouter.baseUrl;
          api = "openai-completions";
          apiKey = "$OPENROUTER_API_KEY";
          models = pkgs.lib.mapAttrsToList (name: _: { id = name; }) shared.providers.openrouter.models;
        };
      };
    };
  };

  home.file."${cfg.configDir}/extensions/pi-quick-perms/config.json" = {
    source = jsonFormat.generate "pi-quick-perms-config.json" {
      permission = {
        "*" = "ask";

        doom_loop = "ask";

        read = "allow";
        glob = "allow";
        grep = "allow";
        ls = "allow";
        find = "allow";
        subagent = "allow";

        write = {
          "*" = "ask";
          "*.md" = "allow";
        };
        edit = {
          "*" = "ask";
          "*.md" = "allow";
        };

        bash = shared.askBash;

        webfetch."*" = "allow";
        websearch."*" = "allow";

        external_directory = "ask";
        path = shared.pathRules;
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
