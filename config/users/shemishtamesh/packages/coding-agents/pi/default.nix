{ pkgs, config, ... }:
let
  cfg = config.programs.pi-coding-agent;
  jsonFormat = pkgs.formats.json { };
  shared = import ../shared { };
  palette = config.lib.stylix.colors.withHashtag;

  # Pi supports provider overrides from extensions, but not environment
  # interpolation in provider baseUrl values.
  #
  # Concrete root files reliably protect reads.  Landstrip additionally
  # enforces the recursive denyWrite globs dynamically on Linux and macOS;
  # denyRead globs are startup-snapshot coverage for already-present files.
  secretFiles = [
    ".env"
    ".env.local"
    ".env.development"
    ".env.production"
    ".env.test"
    ".env.staging"
    ".envrc"
    ".netrc"
    ".npmrc"
    ".pypirc"
    ".git-credentials"

    # Recursive workspace coverage for nested projects and credentials.
    "**/.env"
    "**/.env.*"
    "**/*.pem"
    "**/*.key"
    "**/.netrc"
    "**/.npmrc"
    "**/.pypirc"
    "**/.git-credentials"
  ];

  # pi-permission-system bash deny patterns.  These are wildcard-matched
  # against the raw command string (anchored, no shell parsing).
  bashDenyPatterns = {
    # privilege escalation
    "sudo*" = "deny";
    "su *" = "deny";
    "doas*" = "deny";

    # remote code execution (pipe-to-shell)
    "curl*| sh" = "deny";
    "curl*| bash" = "deny";
    "curl*| zsh" = "deny";
    "curl*| fish" = "deny";
    "curl*| xsh" = "deny";
    "wget*| sh" = "deny";
    "wget*| bash" = "deny";
    "wget*| zsh" = "deny";

    # git: deny all writes to a remote
    "git push*" = "deny";
    "git-push*" = "deny";
    "git subtree push*" = "deny";
    "git send-email*" = "deny";
    "git lfs push*" = "deny";
    "git remote add*" = "deny";
    "git remote set-url*" = "deny";
    "git remote remove*" = "deny";
    "git remote rm*" = "deny";
    "git remote prune*" = "deny";
    "git remote update*" = "deny";
    "git push --mirror*" = "deny";
    "git push --tags*" = "deny";

    # git credential/hook persistence
    "git config*" = "deny";
    ".git/hooks*" = "deny";
    ".gitmodules*" = "deny";

    # GitHub CLI: deny create/edit/mutate/comment (read ops stay allowed)
    # repos
    "gh repo create*" = "deny";
    "gh repo delete*" = "deny";
    "gh repo edit*" = "deny";
    "gh repo transfer*" = "deny";
    "gh repo rename*" = "deny";
    "gh repo fork*" = "deny";
    "gh repo set-default*" = "deny";
    # issues
    "gh issue create*" = "deny";
    "gh issue edit*" = "deny";
    "gh issue close*" = "deny";
    "gh issue reopen*" = "deny";
    "gh issue comment*" = "deny";
    "gh issue lock*" = "deny";
    "gh issue unlock*" = "deny";
    # PRs
    "gh pr create*" = "deny";
    "gh pr edit*" = "deny";
    "gh pr close*" = "deny";
    "gh pr reopen*" = "deny";
    "gh pr merge*" = "deny";
    "gh pr comment*" = "deny";
    "gh pr review*" = "deny";
    "gh pr label*" = "deny";
    "gh pr lock*" = "deny";
    "gh pr unlock*" = "deny";
    # releases / gists / secrets / labels
    "gh release create*" = "deny";
    "gh release edit*" = "deny";
    "gh release delete*" = "deny";
    "gh release upload*" = "deny";
    "gh gist create*" = "deny";
    "gh gist delete*" = "deny";
    "gh gist edit*" = "deny";
    "gh secret set*" = "deny";
    "gh variable set*" = "deny";
    "gh label create*" = "deny";
    "gh label edit*" = "deny";
    "gh label delete*" = "deny";
    "gh milestone create*" = "deny";
    "gh milestone edit*" = "deny";
    "gh milestone close*" = "deny";
    "gh delete*" = "deny";
    "gh cache*" = "deny";
    # workflows / runs
    "gh workflow run*" = "deny";
    "gh workflow enable*" = "deny";
    "gh workflow disable*" = "deny";
    "gh run rerun*" = "deny";
    "gh run cancel*" = "deny";
    # ssh keys / auth writes
    "gh ssh-key add*" = "deny";
    "gh auth refresh*" = "deny";
    "gh auth login*" = "deny";
    "gh auth token*" = "deny";
    "gh alias set*" = "deny";
    # raw API writes to github.com
    "gh api --method POST*" = "deny";
    "gh api --method PUT*" = "deny";
    "gh api --method PATCH*" = "deny";
    "gh api --method DELETE*" = "deny";
    "gh api -X POST*" = "deny";
    "gh api -X PUT*" = "deny";
    "gh api -X PATCH*" = "deny";
    "gh api -X DELETE*" = "deny";
    "gh api repos*" = "deny";
    "gh api user*" = "deny";
    "gh api orgs*" = "deny";

    # generic network-write / data-exfiltration tools
    "curl -T*" = "deny";
    "curl --upload-file*" = "deny";
    "curl -X POST*" = "deny";
    "curl -X PUT*" = "deny";
    "curl -X PATCH*" = "deny";
    "curl -X DELETE*" = "deny";
    "curl --request POST*" = "deny";
    "curl --request PUT*" = "deny";
    "curl --request PATCH*" = "deny";
    "curl --request DELETE*" = "deny";
    "curl -d *" = "deny";
    "curl --data*" = "deny";
    "curl -F *" = "deny";
    "curl --form*" = "deny";
    "wget --post-data*" = "deny";
    "wget --post-file*" = "deny";
    "scp *" = "deny";
    "rsync*" = "deny";
    "sftp *" = "deny";
    "nc *" = "deny";
    "ncat*" = "deny";
    "nmap*" = "deny";
    "telnet*" = "deny";
    "s3cmd*" = "deny";
    "aws s3*" = "deny";
    "aws s3api*" = "deny";
    "aws dynamodb*" = "deny";
    "aws secretsmanager*" = "deny";
    "aws ssm*" = "deny";
    "gcloud *" = "deny";
    "az *" = "deny";
    "kubectl*" = "deny";
    "docker push*" = "deny";
    "docker cp*" = "deny";
    "npm publish*" = "deny";
    "pnpm publish*" = "deny";
    "yarn publish*" = "deny";
    "cargo publish*" = "deny";
    "pip install .*" = "deny";
    "python -m pip install .*" = "deny";
    "twine upload*" = "deny";
    "gem push*" = "deny";
    "git archive*" = "deny";
    "git fast-export*" = "deny";
  };

  absoluteReadDenyDirectories = [
    "/home"
    "/root"
    "/Users"
    "/etc"
    "/run"
    "/var"
    "/proc"
    "/sys"
    "/System"
    "/Library/Keychains"
    "/private/var/db"
  ];

  # keep every exact deny and add a recursive counterpart so native `read`
  nativeReadDenyPatterns = pkgs.lib.unique (
    (pkgs.lib.concatMap (pattern: [
      pattern
      "${pattern}/**"
    ]) secretFiles)
    ++ (pkgs.lib.concatMap (path: [
      path
      "${path}/**"
    ]) absoluteReadDenyDirectories)
  );

  nativeReadDenyPerms = pkgs.lib.genAttrs nativeReadDenyPatterns (_: "deny");

  landstripSandboxPolicy = {
    enabled = true;
    shell.readAccess = "policy";
    network = {
      allowNetwork = false;
      allowLocalBinding = false;
      allowAllUnixSockets = false;
      allowUnixSockets = [ ];
      allowedDomains = [
        "localhost"
        "127.0.0.1"
        "github.com"
        "*.github.com"
        "*.githubusercontent.com"
        "gitlab.com"
        "*.gitlab.com"
        "bitbucket.org"
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
        "mcp.exa.ai"
        "huggingface.co"
        "us.aws.cdn.hf.co"
        "data.gov"
        "data.gov.il"
      ];
      deniedDomains = [ ];
    };
    filesystem = {
      denyRead = secretFiles ++ absoluteReadDenyDirectories;
      allowRead = [
        "."
        "/tmp/pi"
        "/nix/store"
        "/run/current-system"
        "~/.nix-profile"
        "~/.local/state/nix"
        "/dev/null"
        "/etc/passwd"
      ];
      denyWrite = secretFiles ++ [
        ".pi/"
      ];
      allowWrite = [
        "."
        "/tmp/pi"
      ];
    };
  };

  landstripConfig = {
    maxSubagents = 4;
    toolFilesystemPolicy = "sandbox";

    permission = {
      read = nativeReadDenyPerms;

      # already sandboxed
      bash = "allow";

      # deny because it's hard to sandbox or limit reliably
      grep = "deny";
      glob = "deny";
    };
  };

  # only for blocking bash commands that can't be granularly blocked at the os/proxy level
  piPermissionConfig = {
    enabled = true;
    debug = false;
    yoloMode = false;

    defaultPolicy = {
      tools = "allow";
      bash = "allow";
      mcp = "allow";
      skills = "allow";
      special = "allow";
    };

    tools = {
      "*" = "allow";
    };

    bash = bashDenyPatterns;

    skills = {
      "*" = "allow";
    };
  };

  piExtensions = import ./extensions.nix pkgs;

in
{
  programs.pi-coding-agent = {
    enable = true;
    package = pkgs.writeShellScriptBin "pi" ''
      export PATH="${
        pkgs.lib.makeBinPath (
          with pkgs;
          [
            nodejs
            python3
            gnumake
            gcc
            ripgrep
          ]
        )
      }:$PATH"

      export OPENROUTER_API_KEY="$(cat ${config.sops.secrets."openrouter/general_api_key".path})"
      export OPENCODE_API_KEY="$(cat ${config.sops.secrets."opencode/zen".path})"
      unset $(env | cut -d= -f1 | grep -Ei 'key|token|api|secret|credential' | grep -vxE 'OPENROUTER_API_KEY|OPENCODE_API_KEY')

      export PI_PERMISSION_SYSTEM_LOGS_DIR="${config.xdg.stateHome}/pi/permission-system/logs"
      mkdir -p "$PI_PERMISSION_SYSTEM_LOGS_DIR"

      exec ${pkgs.pi-coding-agent}/bin/pi "$@"
    '';
    extraPackages = [ ];

    settings = {
      defaultProvider = "ollama";
      defaultModel = "ornith";
      defaultThinkingLevel = "medium";
      # `grep` and `find` cannot be path-safely permission-filtered
      defaultTools = [
        "read"
        "bash"
        "edit"
        "write"
        "ls"
      ];
      theme = "stylix";
      defaultProjectTrust = "ask";
      enableInstallTelemetry = false;
      collapseChangelog = true;

      packages = [
        "${piExtensions}/lib/node_modules/pi-extensions/node_modules/pi-landstrip"
        "${piExtensions}/lib/node_modules/pi-extensions/node_modules/pi-web-access"
        "${piExtensions}/lib/node_modules/pi-extensions/node_modules/remote-pi"
        "${piExtensions}/lib/node_modules/pi-extensions/node_modules/pi-observational-memory"
        "${piExtensions}/lib/node_modules/pi-extensions/node_modules/pi-context-pruning"
        "${piExtensions}/lib/node_modules/pi-extensions/node_modules/pi-permission-system"
        "${piExtensions}/lib/node_modules/pi-extensions/node_modules/@juicesharp/rpiv-ask-user-question"
        "${./opencode-zen-fix}"
      ];
    };

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
          models = pkgs.lib.mapAttrsToList (name: _: { id = name; }) shared.providers.openrouter.models;
        };
      };
    };
  };

  home.file."${cfg.configDir}/sandbox.json" = {
    source = jsonFormat.generate "landstrip-sandbox.json" landstripSandboxPolicy;
  };

  home.file."${cfg.configDir}/landstrip.json" = {
    source = jsonFormat.generate "pi-landstrip.json" landstripConfig;
  };

  home.file."${cfg.configDir}/pi-permissions.jsonc" = {
    source = jsonFormat.generate "pi-permissions.jsonc" piPermissionConfig;
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
        customMessageLabel = palette.base0E;
        toolPendingBg = palette.base01;
        toolSuccessBg = palette.base01;
        toolErrorBg = palette.base02;
        toolTitle = palette.base0D;
        toolOutput = palette.base04;

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
