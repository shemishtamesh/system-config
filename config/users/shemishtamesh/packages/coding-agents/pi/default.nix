{
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.pi-coding-agent;
  jsonFormat = pkgs.formats.json { };
  shared = import ../shared { };

  palette = config.lib.stylix.colors.withHashtag;
  ui = import ./ui.nix { inherit palette; };

  speakConfig = jsonFormat.generate "pi-speak.json" {
    enabled = false;
    provider = "openai-compatible";
    stream = true;
    announce = false;
    maxChars = 0;
    providers."openai-compatible" = {
      baseUrl = "http://127.0.0.1:8920/v1";
      model = "tts-1";
      voice = "alloy";
      rate = 1.0;
      apiKey = "local"; # server needs no real key
    };
  };

  permissions = import ./permissions.nix {
    inherit pkgs config jsonFormat;
  };
  inherit (permissions) bashScrubber piPermissionConfig;

in
{
  programs.pi-coding-agent = {
    enable = true;
    package = pkgs.writeShellScriptBin "pi" ''
      export PATH="${
        pkgs.lib.makeBinPath (
          (with pkgs; [
            bash
            nodejs
            python3
            gnumake
            gcc
            ripgrep
          ])
          ++ (pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
            pkgs.espeak-ng
            pkgs.ffmpeg
          ])
        )
      }:$PATH"

      export OPENROUTER_API_KEY="$(cat ${config.sops.secrets."openrouter/general_api_key".path})"
      export GROQ_API_KEY="$(cat ${config.sops.secrets."groq/general_api_key".path})"
      export OPENCODE_API_KEY="$(cat ${config.sops.secrets."opencode/zen".path})"

      # give pi-permission-system somewhere writable to write logs to
      export PI_PERMISSION_SYSTEM_LOGS_DIR="${config.xdg.stateHome}/pi/permission-system/logs"
      mkdir -p "$PI_PERMISSION_SYSTEM_LOGS_DIR"

      # landstrip can't safely open /private/var/folders on macos
      ${pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isDarwin /* sh */ ''
        export TMPDIR="$HOME/.cache/pi-tmp"
        export TMP="$TMPDIR"
        export TEMP="$TMPDIR"
        mkdir -p "$TMPDIR"
      ''}

      # make gh not try to use user's config
      export GH_CONFIG_DIR=".cache/pi-tmp/pi-gh-config"
      mkdir -p "$GH_CONFIG_DIR"

      # privateer-speak's /speak on/off toggle is config file based
      ${pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
        mkdir -p "$HOME/.pi"
        rm -f "$HOME/.pi/speak.json"
        cp ${speakConfig} "$HOME/.pi/speak.json"
        chmod 600 "$HOME/.pi/speak.json"
      ''}

      exec ${pkgs.pi-coding-agent}/bin/pi \
        --exclude-tools ${pkgs.lib.concatStringsSep "," permissions.excludedNativeTools} "$@"
    '';
    extraPackages = [ ];

    settings = {
      defaultProvider = "ollama";
      defaultModel = "ornith";
      defaultThinkingLevel = "low";
      shellPath = "${bashScrubber}/bin/bash";
      defaultTools = permissions.enabledNativeTools;
      theme = "stylix";
      defaultProjectTrust = "ask";
      enableInstallTelemetry = false;
      collapseChangelog = true;

      packages = [
        "npm:pi-observational-memory@3.0.4"
        "npm:pi-context-pruning@1.1.0"
        "npm:pi-permission-system@0.8.0"
        "npm:pi-subagents@0.69.0"
        "npm:pi-web-access@0.27.0"
        "npm:remote-pi@0.7.0"
        "npm:privateer-speak@0.2.2"
        ./provider-filters
        ./session-tmp
      ];
    };

    context = ''
      You run inside a sandbox. Do not attempt the impossible or repeat failures.
      Never attempt to read any secret information in any way or display it.
      Never attempt to run anything that could damage the host machine or consume too much resources.
      Always use $TMP for temporary files instead of /tmp directly.
      You are allowed to change files in the current working directory, but never attempt to change anything over network (never attempt to push a git repo for example).
    '';

    models = {
      providers = {
        ollama = {
          baseUrl = "http://localhost:11434/v1";
          api = "openai-completions";
          apiKey = "ollama";
          models = pkgs.lib.mapAttrsToList (
            name: cfg:
            { id = name; } // pkgs.lib.optionalAttrs (cfg.supportsThinking or false) { reasoning = true; }
          ) shared.providers.ollama.models;
        };
        openrouter = {
          baseUrl = shared.providers.openrouter.baseUrl;
          api = "openai-completions";
          apiKey = "$OPENROUTER_API_KEY";
        };
        groq = {
          baseUrl = "https://api.groq.com/openai/v1";
          api = "openai-completions";
          apiKey = "$GROQ_API_KEY";
          models = [
            {
              id = "openai/gpt-oss-120b";
              reasoning = true;
            }
            {
              id = "openai/gpt-oss-20b";
              reasoning = true;
            }
            {
              id = "groq/compound";
              reasoning = true;
            }
            {
              id = "groq/compound-mini";
              reasoning = true;
            }
          ];
        };
      };
    };
  };

  home.file."${cfg.configDir}/keybindings.json".source =
    jsonFormat.generate "pi-keybindings.json" ui.keybindings;

  home.file."${cfg.configDir}/pi-permissions.jsonc" = {
    source = jsonFormat.generate "pi-permissions.jsonc" piPermissionConfig;
  };

  home.file."${cfg.configDir}/extensions/subagent/config.json".source =
    jsonFormat.generate "pi-subagents.json"
      {
        forceTopLevelAsync = true;
        globalConcurrencyLimit = 4;
        maxActiveAsyncRunsPerSession = 4;
        maxSubagentDepth = 1;
      };

  home.file."${cfg.configDir}/themes/stylix.json".source =
    jsonFormat.generate "pi-theme-stylix.json" ui.theme;

  home.file."${config.xdg.configHome}/pi/web-search.json".source =
    jsonFormat.generate "pi-web-search.json"
      {
        workflow = "none";
      };

  sops.secrets."openrouter/general_api_key" = { };
  sops.secrets."groq/general_api_key" = { };
  sops.secrets."opencode/zen" = { };

  home.packages = [
    (pkgs.buildNpmPackage {
      name = "pi-acp";
      src = pkgs.fetchurl {
        url = "https://registry.npmjs.org/pi-acp/-/pi-acp-0.0.33.tgz";
        hash = "sha256-n964pngMBWsywHJC81kIRHIAcwjhq1d1fzM53ZYw3ks=";
      };
      npmDepsHash = "sha256-/fX79XucKojL/6gZbK5eizEfrXso8rlTgiHfJffmDuY=";
      dontNpmBuild = true;
      postPatch = ''
        cp ${
          pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/svkozak/pi-acp/v0.0.33/package-lock.json";
            hash = "sha256-czaX2jogRf92Kdp2oYy+QvF9KfNSJDbQx9X6snLEU5E=";
          }
        } package-lock.json
        sed -i 's/"build": "tsup"/"build": "true"/' package.json
      '';
      meta = {
        mainProgram = "pi-acp";
      };
    })
  ];
}
