{ pkgs, config, ... }:
let
  cfg = config.programs.pi-coding-agent;
  jsonFormat = pkgs.formats.json { };
  tomlFormat = pkgs.formats.toml { };
  shared = import ../shared { };
  palette = config.lib.stylix.colors.withHashtag;

  secretFiles = [
    ".env"
    ".env.*"
    "*.pem"
    "*.key"
    ".netrc"
    ".npmrc"
    ".pypirc"
    ".git-credentials"
  ];

  sandboxDenyRead = [
    # user directories
    "/home"
    "/root"
    "/Users"

    # ssh
    "/etc/ssh"

    # sudo
    "/etc/sudoers"
    "/etc/sudoers.d"
    "/etc/sudo.conf"

    # tls/ssl private keys
    "/etc/ssl/private"

    # password hashes
    "/etc/shadow"
    "/etc/gshadow"
    "/etc/security"

    # sops secrets
    "/etc/sops"
    "/etc/sops.d"

    # systemd credential stores
    "/etc/credstore"
    "/etc/credstore.encrypted"
    "/var/lib/systemd/credential.secret"

    # runtime directories (secrets, wrappers) - not the whole of "/run",
    # see comment above
    "/run/secrets"
    "/run/wrappers"

    # network/vpn credentials
    "/etc/NetworkManager/system-connections"
    "/etc/openvpn"
    "/etc/wireguard"
    "/etc/ipsec.d"
    "/etc/strongswan"
    "/etc/ppp"
    "/etc/racoon"
    "/etc/stunnel"

    # docker / containers
    "/etc/docker"
    "/etc/containerd"
    "/var/lib/docker"

    # kubernetes
    "/etc/kubernetes"

    # nixos config (may contain secrets)
    "/etc/nixos"

    # samba passwords
    "/etc/samba"

    # database client configs
    "/etc/mysql"
    "/etc/postgresql"
    "/etc/mongod.conf"
    "/etc/redis"
    "/etc/ldap"

    # cups printer credentials
    "/etc/cups"

    # mail server configs
    "/etc/mail"
    "/etc/exim4"
    "/etc/postfix"
    "/etc/dovecot"

    # service data dirs (credentials, tokens, secrets)
    "/var/lib/sops-nix"
    "/var/lib/mysql"
    "/var/lib/postgresql"
    "/var/lib/mongodb"
    "/var/lib/redis"
    "/var/lib/neo4j"
    "/var/lib/elasticsearch"
    "/var/lib/prometheus"
    "/var/lib/grafana"
    "/var/lib/vault"
    "/var/lib/bitwarden"
    "/var/lib/keycloak"
    "/var/lib/nextcloud"
    "/var/lib/gitlab"
    "/var/lib/jenkins"

    # logs (may contain tokens printed by accident)
    "/var/log"
    "/var/log/journal"

    # backups / spools
    "/var/backups"
    "/var/spool/mail"
    "/var/spool/cron"
    "/var/spool/atjobs"

    # caches (may cache api keys / tokens)
    "/var/cache"

    # macos
    "/System"
    "/private/var/db"
    "/Library/Keychains"
  ];

  sandboxAllowRead = [
    "."
    "/run/current-system"
    "/nix/store"
    "~/.nix-profile"
    "~/.local/state/nix"
  ];

  sandboxAllowWrite = [
    "."
    "/tmp"
    "/private/tmp"
    "~/.pi"
    "~/.npm" # pi saves its cache here
    "~/.local/state/nvim"
  ];

  allowedDomains = [
    "127.0.0.1"
    "localhost"

    "192.168.1.2"

    # pi-core / model providers (pi itself)
    "api.openai.com"
    "opencode.ai"
    "openrouter.ai" # OpenRouter API (openrouter.ai/api/v1)

    "*.exa.ai" # covers mcp.exa.ai (MCP) + api.exa.ai (direct)
    "html.duckduckgo.com" # keyless DuckDuckGo search

    # pi-web-access: keyed search providers (hardcoded API roots)
    "api.perplexity.ai"
    "api.search.brave.com"
    "api.tavily.com"
    "s.jina.ai" # Jina search
    "r.jina.ai" # Jina reader (content extraction)
    "api.search1api.com"
    "api.search.tinyfish.ai"
    "api.fetch.tinyfish.ai"
    "torchlight.byteintlapi.com" # Searchinfinity
    "api.querit.ai"
    "kagi.com" # Kagi API (kagi.com/api/v1)
    "api.bochaai.com"
    "api.anysearch.com"
    "run.xcrawl.com"
    "api.valyu.ai"
    "api.serpdive.com"
    "api.mistral.ai"
    "api.x.ai" # xAI / Grok
    "api.brightdata.com"
    "api.serpbase.dev"
    "google.serper.dev"
    "ollama.com" # Ollama web search endpoint
    "api.parallel.ai" # Parallel REST (search + extract)
    "search.parallel.ai" # Parallel MCP
    "api.kimi.com" # Kimi
    "chatgpt.com" # OpenAI Codex backend
    "api.firecrawl.dev" # Firecrawl (default if configured)
    "www.datalab.to" # Datalab PDF extraction

    # pi-web-access: Gemini (API + Web browser-cookie)
    "generativelanguage.googleapis.com"
    "aiplatform.googleapis.com"
    "gemini.google.com"
    "content-push.googleapis.com"
    "accounts.google.com"

    # source-control / roots
    "github.com"
    "*.github.com"
    "*.githubusercontent.com"
    "gitlab.com"
    "*.gitlab.com"
    "bitbucket.org"
    "*.bitbucket.org"

    # package registries
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

    # nix resources
    "cache.nixos.org"
    "*.cachix.org"
    "channels.nixos.org"
    "releases.nixos.org"
    "nixos.org"

    # docs / reference (common fetch_content targets)
    "docs.rs"
    "*.readthedocs.io"
    "developer.mozilla.org"
    "*.w3.org"
    "webaim.org"

    # encyclopedic / knowledge
    "*.wikipedia.org"
    "*.wikimedia.org"

    # user-generated content / communities
    "news.ycombinator.com" # Hacker News
    "hn.algolia.com" # Hacker News search API
    "reddit.com"
    "*.reddit.com"
    "old.reddit.com"
    "*.quora.com" # Quora
    "lobste.rs" # Lobsters
    "news.google.com" # Google News
    "discourse.org" # common self-hosted forum platform
    "*.discourse.org"
    "stackoverflow.com" # programming Q&A
    "*.stackoverflow.com"
    "*.stackexchange.com" # all Stack Exchange sites

    # dev blogs / community platforms
    "dev.to" # developer community
    "hashnode.com"
    "*.hashnode.com" # hosted dev blogs
    "ghost.org" # Ghost blogging platform
    "*.ghost.io" # Ghost hosted blogs
    "medium.com"
    "*.medium.com"
    "*.wordpress.com" # WordPress.com hosted blogs
    "*.github.io" # GitHub Pages personal sites
    "*.gitbook.io" # GitBook docs
    "*.substack.com" # Substack newsletters
    "*.blogspot.com" # Blogger
    "*.tumblr.com" # Tumblr
    "*.notion.site" # shared Notion pages

    # tech news / editorial
    "arstechnica.com" # Ars Technica
    "techcrunch.com" # TechCrunch
    "venturebeat.com" # VentureBeat
    "theverge.com" # The Verge
    "wired.com" # Wired
    "gizmodo.com" # Gizmodo
    "engadget.com" # Engadget
    "zdnet.com" # ZDNet
    "hackaday.com" # Hackaday
    "blog.google"
    "engineering.fb.com"
    "netflixtechblog.com"
    "*.netflix.com"

    # social / professional networking
    "linkedin.com"
    "*.linkedin.com"
    "twitter.com"
    "x.com"
    "*.x.com"
    "nitter.net" # Nitter (Twitter mirror/reader)

    # pi
    "pi.dev"
  ];

  srtSettingsFile = jsonFormat.generate "pi-srt-settings.json" {
    network = {
      inherit allowedDomains;
      deniedDomains = [ ];
      strictAllowlist = true;

      allowLocalBinding = true;
      allowAllUnixSockets = true;
    };

    filesystem = {
      denyRead = sandboxDenyRead ++ secretFiles;
      allowRead = sandboxAllowRead ++ sandboxAllowWrite;

      allowWrite = sandboxAllowWrite;
      denyWrite = secretFiles;
    };

    allowPty = true;

    ripgrep.command = "${pkgs.ripgrep}/bin/rg";
  };
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
          ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
            # srt needs these on Linux for bubblewrap + network-namespace proxying
            bubblewrap
            socat
          ]
        )
      }:$PATH"

      # not masked via srt credentials.envVars: needs experimental
      # network.tlsTerminate, which still has open bugs (anthropics/sandbox-runtime#490, #487).
      export OPENROUTER_API_KEY="$(cat ${config.sops.secrets."openrouter/general_api_key".path})"
      export OPENCODE_API_KEY="$(cat ${config.sops.secrets."opencode/zen".path})"
      export OPENCODE_SHOW_PAID=false

      # deny-by-unset any other credential-shaped env var pi doesn't need
      unset $(env | cut -d= -f1 | grep -Ei 'key|token|api|secret' | grep -vxE 'OPENROUTER_API_KEY|OPENCODE_API_KEY')

      # srt overrides TMPDIR inside the sandbox; base it on "/tmp" (not the
      # inherited $TMPDIR, usually /var/folders/... on macOS) since that's
      # what's actually in allowWrite below.
      export CLAUDE_CODE_TMPDIR="/tmp/pi"
      export TMPDIR="$CLAUDE_CODE_TMPDIR"
      mkdir -p "$TMPDIR"

      exec ${pkgs.sandbox-runtime}/bin/srt -s ${srtSettingsFile} -- ${pkgs.pi-coding-agent}/bin/pi "$@"
    '';
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
        "npm:@juicesharp/rpiv-ask-user-question"
        "npm:@tintinweb/pi-subagents"
        "npm:pi-observational-memory"
        "npm:pi-context-pruning"
        "npm:pi-perm"
        "npm:pi-web-access"
        "npm:remote-pi"
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

  home.file."${cfg.configDir}/extensions/pi-perm/config.toml" = {
    source = tomlFormat.generate "pi-perm-config.toml" {
      version = 1;
      activePermissionProfile = "permissive";

      permissions.permissive = {
        filesystem = {
          ":minimal" = "read";
          ":workspace_roots"."." = "write";
        };
        network = {
          enabled = true;
          allowLocalBinding = true;
        };
      };

      tools = {
        bash = {
          mode = "enforce";
          defaultAction = "allow";
          wrapWithSrt = false;
          operations.block = [
            # privilege escalation
            "sudo"
            "su "
            "doas"

            # remote code execution (pipe-to-shell)
            "curl * | sh"
            "curl * | bash"
            "curl * | zsh"
            "curl * | fish"
            "curl * | xsh"
            "wget * | sh"
            "wget * | bash"
            "wget * | zsh"

            # git: deny all writes to a remote
            "git push"
            "git-push"
            "git subtree push"
            "git send-email"
            "git lfs push"
            "git remote add"
            "git remote set-url"
            "git remote remove"
            "git remote rm"
            "git remote prune"
            "git remote update"
            "git push --mirror"
            "git push --tags"

            # git credential/hook persistence
            "git config"
            ".git/hooks"
            ".gitmodules"

            # GitHub CLI: deny create/edit/mutate/comment (read ops stay allowed)
            # repos
            "gh repo create"
            "gh repo delete"
            "gh repo edit"
            "gh repo transfer"
            "gh repo rename"
            "gh repo fork"
            "gh repo set-default"
            # issues
            "gh issue create"
            "gh issue edit"
            "gh issue close"
            "gh issue reopen"
            "gh issue comment"
            "gh issue lock"
            "gh issue unlock"
            # PRs
            "gh pr create"
            "gh pr edit"
            "gh pr close"
            "gh pr reopen"
            "gh pr merge"
            "gh pr comment"
            "gh pr review"
            "gh pr label"
            "gh pr lock"
            "gh pr unlock"
            # releases / gists / secrets / labels
            "gh release create"
            "gh release edit"
            "gh release delete"
            "gh release upload"
            "gh gist create"
            "gh gist delete"
            "gh gist edit"
            "gh secret set"
            "gh variable set"
            "gh label create"
            "gh label edit"
            "gh label delete"
            "gh milestone create"
            "gh milestone edit"
            "gh milestone close"
            "gh delete"
            "gh cache"
            # workflows / runs
            "gh workflow run"
            "gh workflow enable"
            "gh workflow disable"
            "gh run rerun"
            "gh run cancel"
            # ssh keys / auth writes
            "gh ssh-key add"
            "gh auth refresh"
            "gh auth login"
            "gh auth token"
            "gh alias set"
            # raw API writes to github.com (create/update/delete resources)
            "gh api --method POST"
            "gh api --method PUT"
            "gh api --method PATCH"
            "gh api --method DELETE"
            "gh api -X POST"
            "gh api -X PUT"
            "gh api -X PATCH"
            "gh api -X DELETE"
            "gh api repos"
            "gh api user"
            "gh api orgs"

            # generic network-write / data-exfiltration tools
            "curl -T"
            "curl --upload-file"
            "curl -X POST"
            "curl -X PUT"
            "curl -X PATCH"
            "curl -X DELETE"
            "curl --request POST"
            "curl --request PUT"
            "curl --request PATCH"
            "curl --request DELETE"
            "curl -d "
            "curl --data"
            "curl -F "
            "curl --form"
            "wget --post-data"
            "wget --post-file"
            "scp "
            "rsync"
            "sftp "
            "nc "
            "ncat"
            "nmap"
            "telnet"
            "s3cmd"
            "aws s3"
            "aws s3api"
            "aws dynamodb"
            "aws secretsmanager"
            "aws ssm"
            "gcloud "
            "az "
            "kubectl"
            "docker push"
            "docker cp"
            "npm publish"
            "pnpm publish"
            "yarn publish"
            "cargo publish"
            "pip install ."
            "python -m pip install ."
            "twine upload"
            "gem push"
            "git archive"
            "git fast-export"
          ];
        };
        read = {
          mode = "enforce";
          defaultAction = "allow";
        };
        write = {
          mode = "enforce";
          defaultAction = "allow";
        };
        edit = {
          mode = "enforce";
          defaultAction = "allow";
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
