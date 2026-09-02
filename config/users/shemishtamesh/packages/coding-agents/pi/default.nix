{ pkgs, config, ... }:
let
  cfg = config.programs.pi-coding-agent;
  jsonFormat = pkgs.formats.json { };
  shared = import ../shared { };
  palette = config.lib.stylix.colors.withHashtag;
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
      theme = "stylix";
      defaultProjectTrust = "ask";
      enableInstallTelemetry = false;
      collapseChangelog = true;

      packages = [
        # "npm:pi-sandbox"
        # "npm:pi-maestro-flow"
        # "npm:pi-free"
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

  home.file."${cfg.configDir}/themes/stylix.json" = {
    source = jsonFormat.generate "pi-theme-stylix.json" {
      name = "stylix";
      colors = {
        # Core UI
        accent = palette.base0D;
        border = palette.base03;
        borderAccent = palette.base0D;
        borderMuted = palette.base01;
        success = palette.base0B;
        error = palette.base08;
        warning = palette.base0A;
        muted = palette.base04;
        dim = palette.base03;
        text = palette.base05;
        thinkingText = palette.base04;

        # Backgrounds & content
        selectedBg = palette.base02;
        scrollbarThumb = palette.base03;
        searchMatchBg = palette.base0A;
        searchMatchText = palette.base00;
        userMessageBg = palette.base01;
        userMessageText = palette.base05;
        customMessageBg = palette.base01;
        customMessageText = palette.base05;
        customMessageLabel = palette.base0D;
        toolPendingBg = palette.base01;
        toolSuccessBg = palette.base0B;
        toolErrorBg = palette.base08;
        toolTitle = palette.base0D;
        toolOutput = palette.base05;

        # Markdown
        mdHeading = palette.base0D;
        mdLink = palette.base0D;
        mdLinkUrl = palette.base0C;
        mdCode = palette.base0B;
        mdCodeBlock = palette.base05;
        mdCodeBlockBorder = palette.base03;
        mdQuote = palette.base04;
        mdQuoteBorder = palette.base03;
        mdHr = palette.base03;
        mdListBullet = palette.base0A;

        # Tool diffs
        toolDiffAdded = palette.base0B;
        toolDiffRemoved = palette.base08;
        toolDiffContext = palette.base04;

        # Syntax highlighting
        syntaxComment = palette.base03;
        syntaxKeyword = palette.base0E;
        syntaxFunction = palette.base0D;
        syntaxVariable = palette.base08;
        syntaxString = palette.base0B;
        syntaxNumber = palette.base09;
        syntaxType = palette.base0A;
        syntaxOperator = palette.base05;
        syntaxPunctuation = palette.base05;

        # Thinking-level borders
        thinkingOff = palette.base03;
        thinkingMinimal = palette.base0C;
        thinkingLow = palette.base0B;
        thinkingMedium = palette.base0A;
        thinkingHigh = palette.base09;
        thinkingXhigh = palette.base08;
        thinkingMax = palette.base0E;

        # Bash mode
        bashMode = palette.base0E;
      };
    };
  };

  home.file."${cfg.configDir}/sandbox.json" = {
    source = jsonFormat.generate "pi-sandbox-config.json" (
      let
        secretFiles = [
          ".env"
          ".env.*"
          "*.pem"
          "*.key"
        ];
      in
      {
        enabled = true;

        network.allowedDomains = [
          "github.com"
          "*.github.com"
          "*.githubusercontent.com"

          "registry.npmjs.org"

          "pypi.org"
          "*.pypi.org"
          "files.pythonhosted.org"

          "crates.io"
          "static.crates.io"
          "*.rust-lang.org"

          "proxy.golang.org"
          "sum.golang.org"
          "pkg.go.dev"

          "cache.nixos.org"
          "*.cachix.org"
          "channels.nixos.org"
          "releases.nixos.org"
          "nixos.org"

          "docs.rs"
          "*.readthedocs.io"

          "*.wikipedia.org"

          "pi.dev"
        ];

        filesystem = {
          denyRead = shared.sandboxDenyRead ++ secretFiles;
          allowRead = shared.sandboxAllowRead;

          allowWrite = [
            "."
            "/tmp"
          ];
          denyWrite = secretFiles;
        };
      }
    );
  };
  sops.secrets."openrouter/general_api_key" = { };
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
