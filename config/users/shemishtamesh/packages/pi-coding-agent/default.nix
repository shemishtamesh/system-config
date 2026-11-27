{
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.pi-coding-agent;
  agentConfigDir =
    if pkgs.lib.hasPrefix "/" cfg.configDir then
      cfg.configDir
    else
      "${config.home.homeDirectory}/${cfg.configDir}";
  globalMemoryDir = "${config.home.homeDirectory}/.pi/memory";
  piPackage = pkgs.pi-coding-agent;
  jsonFormat = pkgs.formats.json { };
  piMuxr = pkgs.callPackage ../tmux/pi-muxr { };
  providers = import ./providers.nix { openrouterKeyEnvVar = "OPENROUTER_API_KEY"; };

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
    inherit
      pkgs
      config
      jsonFormat
      globalMemoryDir
      agentConfigDir
      ;
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
            opencode
            python3
            gnumake
            gcc
            ripgrep
          ])
          ++ (pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
            pkgs.espeak-ng
            pkgs.ffmpeg
            pkgs.libnotify
          ])
        )
      }:$PATH"

      export OPENROUTER_API_KEY="$(cat ${config.sops.secrets."openrouter/general_api_key".path})"
      export GROQ_API_KEY="$(cat ${config.sops.secrets."groq/general_api_key".path})"
      export NVIDIA_API_KEY="$(cat ${config.sops.secrets."nvidia/nim/general_api_key".path})"
      export GEMINI_API_KEY="$(cat ${config.sops.secrets."google/gemini/general_api_key".path})"
      export KILO_API_KEY="$(cat ${config.sops.secrets."kilo/general_api_key".path})"

      # mutable memory can't be a read only link
      mkdir -p ${pkgs.lib.escapeShellArg globalMemoryDir} .pi/memory

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

      if [ -z "''${PI_SESSION_TMP_BASE:-}" ]; then
        pi_tmp_base="''${TMPDIR:-/tmp}/pi-agent"
        mkdir -p "$pi_tmp_base"
        export PI_SESSION_TMP_BASE="$(
          ${pkgs.coreutils}/bin/mktemp -d "$pi_tmp_base/session.XXXXXX"
        )"
      fi
      export PI_SUBAGENTS_TEMP_ROOT="''${PI_SUBAGENTS_TEMP_ROOT:-$PI_SESSION_TMP_BASE/pi-subagents}"
      mkdir -p "$PI_SUBAGENTS_TEMP_ROOT"
      export TMPDIR="$PI_SESSION_TMP_BASE"
      export TMP="$PI_SESSION_TMP_BASE"
      export TEMP="$PI_SESSION_TMP_BASE"

      # Keep tool caches session-local rather than exposing shared user caches.
      export XDG_CACHE_HOME="$TMP/cache"
      export NIX_CACHE_HOME="$XDG_CACHE_HOME/nix"
      export UV_CACHE_DIR="$XDG_CACHE_HOME/uv"
      export TYPST_PACKAGE_CACHE_PATH="$XDG_CACHE_HOME/typst/packages"
      export GOMODCACHE="$TMP/go/pkg/mod"
      export GOCACHE="$XDG_CACHE_HOME/go-build"
      mkdir -p "$XDG_CACHE_HOME" "$NIX_CACHE_HOME" "$UV_CACHE_DIR" \
        "$TYPST_PACKAGE_CACHE_PATH" "$GOMODCACHE" "$GOCACHE"

      # make gh not try to use user's config
      export GH_CONFIG_DIR="$HOME/.cache/pi-tmp/pi-gh-config"
      mkdir -p "$GH_CONFIG_DIR"

      # privateer-speak's /speak on/off toggle is config file based
      ${pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
        mkdir -p "$HOME/.pi"
        rm -f "$HOME/.pi/speak.json"
        cp ${speakConfig} "$HOME/.pi/speak.json"
        chmod 600 "$HOME/.pi/speak.json"
      ''}

      exec ${piPackage}/bin/pi \
        --exclude-tools ${pkgs.lib.concatStringsSep "," permissions.excludedNativeTools} "$@"
    '';
    extraPackages = [ ];

    settings = {
      defaultProvider = "ollama";
      defaultModel = "ornith";
      defaultThinkingLevel = "low";
      shellPath = "${bashScrubber}/bin/bash";
      defaultTools = permissions.enabledNativeTools;
      subagents.agentOverrides = {
        delegate.tools = [
          "read"
          "ls"
          "bash"
          "edit"
          "write"
          "contact_supervisor"
        ];
        worker.tools = [
          "read"
          "ls"
          "bash"
          "edit"
          "write"
          "contact_supervisor"
        ];
        scout.tools = [
          "read"
          "ls"
          "bash"
          "write"
          "contact_supervisor"
        ];
        reviewer.tools = [
          "read"
          "ls"
          "contact_supervisor"
        ];
        oracle.tools = [
          "read"
          "ls"
          "bash"
        ];
      };
      theme = "stylix";
      showHardwareCursor = true;
      terminal.showTerminalProgress = true;
      steeringMode = "all";
      treeFilterMode = "user-only";
      defaultProjectTrust = "ask";
      enableInstallTelemetry = false;
      collapseChangelog = true;
      "observational-memory".showWorkerNotifications = false;

      # Load only the extension: the full package also bundles pi-tui for its CLI.
      extensions = [ "${piMuxr.piPackage}/dist/extension/index.js" ];

      packages = [
        "npm:pi-observational-memory@3.1.4"
        "npm:pi-context-prune@3.2.1"
        "npm:@gotgenes/pi-permission-system@44.0.2"
        "npm:pi-subagents@0.90.0"
        "npm:pi-web-access@0.48.0"
        "npm:@specode/pi-subscription-usage@1.5.0"
        "npm:pi-opencode-cli-bridge@0.2.23"
        "npm:@hk_net/remote-pi@0.9.0"
        "npm:privateer-speak@0.8.0"
        "npm:pi-keep-going@1.2.0"
        ./provider-filters
        ./session-tmp
      ];
    };

    context =
      builtins.replaceStrings
        [ "@agentConfigDir@" "@globalMemoryDir@" ]
        [ agentConfigDir globalMemoryDir ]
        (builtins.readFile ./context.md);

    models = {
      providers = {
        ollama = providers.ollama // {
          models = pkgs.lib.mapAttrsToList (
            name: cfg:
            { id = name; } // pkgs.lib.optionalAttrs (cfg.supportsThinking or false) { reasoning = true; }
          ) providers.ollama.models;
        };
        openrouter = providers.openrouter;
        groq = providers.groq;
        kilo = providers.kilo;
      };
    };
  };

  home.file.".pi-muxr/config.json".source = jsonFormat.generate "pi-muxr-config.json" {
    desktopNotifications = true;
    suppressDesktopNotificationsWhenDashboardOpen = false;
  };

  home.file."${cfg.configDir}/context-prune/settings.json".source =
    jsonFormat.generate "pi-context-prune-settings.json"
      {
        enabled = true;
        showPruneStatusLine = false;
        notifySkipped = false;
        summarizerModel = "default";
      };

  home.file."${cfg.configDir}/keybindings.json".source =
    jsonFormat.generate "pi-keybindings.json" ui.keybindings;

  home.file."${cfg.configDir}/extensions/pi-permission-system/config.json" = {
    source = jsonFormat.generate "pi-permission-system-config.json" piPermissionConfig;
  };

  home.file."${cfg.configDir}/extensions/subagent/config.json".source =
    jsonFormat.generate "pi-subagents.json"
      {
        forceTopLevelAsync = true;
        globalConcurrencyLimit = 4;
        maxActiveAsyncRunsPerSession = 4;
        maxSubagentDepth = 1;
      };

  home.file."${cfg.configDir}/skills/isolated-clone".source = ./skills/isolated-clone;
  home.file."${cfg.configDir}/skills/memory-maintenance".source = ./skills/memory-maintenance;

  home.file."${cfg.configDir}/themes/stylix.json".source =
    jsonFormat.generate "pi-theme-stylix.json" ui.theme;

  home.file."${config.xdg.configHome}/pi/web-search.json".source =
    jsonFormat.generate "pi-web-search.json"
      {
        workflow = "none";
      };

  sops.secrets."openrouter/general_api_key" = { };
  sops.secrets."groq/general_api_key" = { };
  sops.secrets."nvidia/nim/general_api_key" = { };
  sops.secrets."google/gemini/general_api_key" = { };
  sops.secrets."kilo/general_api_key" = { };

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
