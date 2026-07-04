{ pkgs, config, ... }:
let
  openrouter_key_env_var = "OPENROUTER_API_KEY";

  readOnlyBash = {
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
    "stat *" = "allow";
    "realpath *" = "allow";
    "readlink *" = "allow";
    "strings *" = "allow";
    "od *" = "allow";
    "xxd *" = "allow";
    "hexdump *" = "allow";
    "cut *" = "allow";
    "tr *" = "allow";
    "column *" = "allow";
    "fmt *" = "allow";
    "diff *" = "allow";
    "comm *" = "allow";
    "jq *" = "allow";
    "yq *" = "allow";
    "dirname *" = "allow";
    "basename *" = "allow";
    "expand *" = "allow";
    "unexpand *" = "allow";
    "nl *" = "allow";
    "fold *" = "allow";
    "pr *" = "allow";
    "ptx *" = "allow";

    tree = "allow";
    "tree *" = "allow";

    pwd = "allow";
    "pwd *" = "allow";

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

    "curl *" = "allow";
  };

  askBash = { "*" = "ask"; } // readOnlyBash;

  # Shared deny rules for both read and edit access
  sensitiveDeny = {
    # Cloud provider credentials
    "~/.aws/**" = "deny";
    "~/.azure/**" = "deny";
    "~/.config/gcloud/**" = "deny";
    "~/.databrickscfg" = "deny";

    # GPG
    "~/.gnupg/**" = "deny";

    # Password managers
    "~/.password-store/**" = "deny";
    "~/.1password/**" = "deny";
    "~/.config/1Password/**" = "deny";
    "~/.bitwarden/**" = "deny";
    "~/.config/Bitwarden/**" = "deny";
    "~/.keepass/**" = "deny";
    "**/*.kdbx" = "deny";

    # Browser data
    "~/.config/google-chrome/**" = "deny";
    "~/.config/chromium/**" = "deny";
    "~/.mozilla/**" = "deny";

    # macOS equivalents
    "~/Library/Application Support/Google/Chrome/**" = "deny";
    "~/Library/Application Support/Firefox/**" = "deny";
    "~/Library/Application Support/Chromium/**" = "deny";
    "~/Library/Keychains/**" = "deny";
    "/Library/Keychains/**" = "deny";
    "/System/**" = "deny";
    "/private/var/db/**" = "deny";

    # System files
    "/etc/shadow" = "deny";
    "/etc/gshadow" = "deny";
    "/etc/sudoers" = "deny";
    "/etc/sudoers.d/**" = "deny";

    # Pseudo / special filesystems
    "/proc/**" = "deny";
    "/sys/**" = "deny";
    "/dev/**" = "deny";
    "/run/**" = "deny";

    # Windows (harmless on Linux, included for cross-platform config)
    "C:\\Windows\\**" = "deny";
    "C:\\Windows\\System32\\config\\SAM" = "deny";
    "C:\\Windows\\System32\\config\\SECURITY" = "deny";
    "C:\\Windows\\System32\\config\\SYSTEM" = "deny";
    "**\\AppData\\Roaming\\Microsoft\\Credentials\\**" = "deny";
    "**\\AppData\\Local\\Microsoft\\Credentials\\**" = "deny";
    "C:\\ProgramData\\Microsoft\\Crypto\\**" = "deny";

    # Database credentials
    "~/.pgpass" = "deny";
    "~/.my.cnf" = "deny";
    "~/.dbvis/**" = "deny";

    # Broad sensitive patterns
    "**/.secret*" = "deny";
    "**/secrets/**" = "deny";
    "**/credentials/**" = "deny";
    "**/private/**" = "deny";

    # Certificates and key stores
    "**/*.p12" = "deny";
    "**/*.pfx" = "deny";
    "**/*.jks" = "deny";
    "**/*.keystore" = "deny";

    # SSH keys (bare filenames, match anywhere)
    "**/id_rsa" = "deny";
    "**/id_ed25519" = "deny";
    "**/id_dsa" = "deny";

    # JSON credential / token files
    "**/credentials.json" = "deny";
    "**/service-account.json" = "deny";
    "**/service_account.json" = "deny";
    "**/firebase-adminsdk*.json" = "deny";
    "**/token.json" = "deny";
    "**/refresh_token.json" = "deny";
    "**/access_token.json" = "deny";

    # SQLite databases
    "**/*.sqlite" = "deny";
    "**/*.sqlite3" = "deny";

    # Existing patterns
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

  sensitiveReadRules = {
    "*" = "allow";
    "**/*.envrc" = "ask";
  } // sensitiveDeny;

  sensitiveEditRules = {
    "**/.envrc" = "ask";
  } // sensitiveDeny;

  externalDirectoryDeny = {
    "*" = "ask";
    # Entries from sensitiveDeny that are directory-wide patterns under ~
    "~/.aws/**" = "deny";
    "~/.azure/**" = "deny";
    "~/.config/gcloud/**" = "deny";
    "~/.gnupg/**" = "deny";
    "~/.password-store/**" = "deny";
    "~/.1password/**" = "deny";
    "~/.config/1Password/**" = "deny";
    "~/.bitwarden/**" = "deny";
    "~/.config/Bitwarden/**" = "deny";
    "~/.keepass/**" = "deny";
    "~/.config/google-chrome/**" = "deny";
    "~/.config/chromium/**" = "deny";
    "~/.mozilla/**" = "deny";
    "~/.dbvis/**" = "deny";
    "~/.ssh/**" = "deny";
    "~/.secrets/**" = "deny";
    "~/.config/sops-nix/secrets/**" = "deny";
    "~/.config/sops/age/**" = "deny";
    "~/Library/Application Support/Google/Chrome/**" = "deny";
    "~/Library/Application Support/Firefox/**" = "deny";
    "~/Library/Application Support/Chromium/**" = "deny";
    "~/Library/Keychains/**" = "deny";
    "/Library/Keychains/**" = "deny";
    "/System/**" = "deny";
    "/private/var/db/**" = "deny";
    "/etc/sudoers.d/**" = "deny";
    "/proc/**" = "deny";
    "/sys/**" = "deny";
    "/dev/**" = "deny";
    "/run/**" = "deny";
    "C:\\Windows\\**" = "deny";
    "C:\\ProgramData\\Microsoft\\Crypto\\**" = "deny";
  };

  agentEditAllow = { "*" = "allow"; } // sensitiveEditRules;
in {
  programs.opencode = {
    enable = true;
    package = pkgs.writeShellScriptBin "opencode" ''
      export ${openrouter_key_env_var}
      ${openrouter_key_env_var}="$(cat ${config.sops.secrets."openrouter/general_api_key".path})"
      exec ${pkgs.opencode}/bin/opencode "$@"
    '';
    enableMcpIntegration = true;
    tui = {
      attention = {
        enable = true;
        notifications = true;
        sound = true;
      };
    };
    settings = {
      default_agent = "craft";

      model = "ollama/qwen3-coder";

      permission = {
        "*" = "ask";

        doom_loop = "ask";

        read = sensitiveReadRules;
        glob = "allow";
        grep = "allow";
        ls = "allow";
        find = "allow";
        subagent = "allow";

        list = "allow";
        lsp = "allow";
        codesearch = "allow";
        todoread = "allow";
        todowrite = "allow";
        task = "allow";
        skill = "allow";
        question = "allow";

        write = {
          "*" = "ask";
          ".agents/memory/**/*" = "allow";
        };
        edit = "ask";

        bash = askBash;

        webfetch = "allow";
        websearch = "allow";

        external_directory = externalDirectoryDeny;
      };

      agent = {
        build.disable = true;
        plan.disable = true;

        audit = {
          mode = "primary";
          description = "Read-only analysis. Cannot write or execute.";
          permission = {
            edit = "deny";
            todowrite = "deny";
            bash = "deny";
            task = "deny";
            external_directory = "allow";
          };
        };

        craft = {
          mode = "primary";
          description = "Edit files in project. Cannot execute.";
          permission = {
            edit = agentEditAllow;
            bash = "deny";
            task = "deny";
          };
        };

        yolo = {
          mode = "primary";
          description = "Full read, write, and execute access.";
          permission = {
            edit = agentEditAllow;
            bash = "allow";
            task = "allow";
          };
        };
      };

      enabled_providers = [
        "ollama"
        "opencode"
        "openrouter"
      ];
      provider = {
        ollama = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama";
          options = {
            baseURL = "http://localhost:11434/v1";
          };
          models = {
            qwen3-coder = { };
            "gemma4:26b" = {
              options = {
                thinking = {
                  type = "enabled";
                  textVerbosity = "low";
                };
              };
              variants = {
                high = {
                  thinking.reasoningEffort = "high";
                };
                low = {
                  thinking."reasoningEffort" = "low";
                };
              };
            };
          };
        };
        openrouter = {
          options = {
            apiKey = "{env:${openrouter_key_env_var}}";
          };
        };
      };
    };
  };
  home.packages = [ pkgs.libnotify ];
  programs.zsh.initContent =
    let
      opencodeZshCompletion = pkgs.runCommand "opencode-zsh-completion" { } ''
        export HOME=$TMPDIR
        export SHELL=${pkgs.zsh}/bin/zsh
        ${pkgs.opencode}/bin/opencode completion > "$out"
      '';
    in
    "source ${opencodeZshCompletion}";
  sops.secrets."openrouter/general_api_key" = { };
}
