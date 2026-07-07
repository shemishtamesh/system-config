let
  sensitiveDeny = {
    # Cloud provider credentials
    "~/.aws/**" = "deny";
    "~/.azure/**" = "deny";
    "~/.config/gcloud/**" = "deny";
    "~/.databrickscfg" = "deny";

    # Container / orchestration credentials
    "~/.kube/**" = "deny";
    "~/.docker/config.json" = "deny";

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

    # Package manager / language credentials
    "**/.npmrc" = "deny";
    "~/.netrc" = "deny";
    "**/.pypirc" = "deny";
    "~/.m2/settings.xml" = "deny";
    "**/gradle.properties" = "deny";

    # Git credentials
    "**/.git-credentials" = "deny";
    "~/.config/git/credentials" = "deny";

    # Deployment platform credentials
    "~/.config/gh/hosts.yml" = "deny";
    "~/.config/vercel/**" = "deny";
    "~/.config/doctl/**" = "deny";
    "~/.config/circleci/**" = "deny";
    "~/.netlify/**" = "deny";
    "~/.oci/**" = "deny";

    # Additional cloud providers
    "~/.config/pulumi/**" = "deny";
    "~/.config/heroku/**" = "deny";
    "~/.config/hcloud/**" = "deny";
    "~/.config/travis/**" = "deny";

    # Container tools (broader coverage)
    "~/.config/containers/**" = "deny";

    # Keyrings
    "~/.local/share/keyrings/**" = "deny";

    # Cloud storage / file sync
    "~/.config/rclone/**" = "deny";

    # Artifactory / binary repository
    "~/.config/jfrog/**" = "deny";

    # HashiCorp Vault
    "**/.vault-token" = "deny";
    "~/.config/vault/**" = "deny";

    # Terraform / OpenTofu
    "**/.terraformrc" = "deny";
    "**/.terraform.d/**" = "deny";

    # Broad sensitive patterns
    "**/.secret*" = "deny";
    "**/secrets/**" = "deny";
    "**/credentials/**" = "deny";
    "**/credentials" = "deny";
    "**/private/**" = "deny";
    "**/auth.json" = "deny";
    "**/.auth*" = "deny";
    "**/*.token" = "deny";
    "**/*.age" = "deny";
    "**/*.sops" = "deny";
    "**/.age/**" = "deny";
    "**/*.encrypted" = "deny";
    "**/.ansible/**" = "deny";
    "**/.chezmoi/**" = "deny";

    # Certificates and key stores
    "**/certs/**" = "deny";
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

    # Environment files, secrets, SSH, and sops credentials
    "**/*.env" = "deny";
    "**/*.env.local" = "deny";
    "**/*.env.prod" = "deny";
    "**/*.pem" = "deny";
    "**/*.key" = "deny";
    "~/.ssh/**" = "deny";
    "~/.secrets/**" = "deny";
    "~/.config/sops-nix/secrets/**" = "deny";
    "~/.config/sops/age/**" = "deny";

    # SSH host keys (system-level)
    "/etc/ssh/**" = "deny";

    # Application tokens (messaging apps may contain auth tokens)
    "~/.config/Slack/**" = "deny";
    "~/.config/discord/**" = "deny";
    "~/.config/signal/**" = "deny";
    "~/.config/zoom/**" = "deny";

    # GitHub Copilot tokens
    "~/.config/github-copilot/**" = "deny";

    # Backup / editor swap files (may contain credentials)
    "**/*.bak" = "deny";
    "**/*.backup" = "deny";
    "**/*~" = "deny";
  };

  sensitiveReadRules = {
    "*" = "allow";
    "**/*.envrc" = "ask";
  }
  // sensitiveDeny;

  sensitiveEditRules = {
    "**/.envrc" = "ask";
  }
  // sensitiveDeny;

  # For tools that use a path-based permission system (like pi)
  pathRules = {
    "*" = "allow";
  }
  // {
    "**/*.envrc" = "ask";
  }
  // sensitiveDeny;

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

    # runtime directories (secrets, credentials, sockets, etc.)
    "/run"

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
    "~/.nix-profile"
    "/tmp/opencode-sandbox"
    "/run/current-system"
  ];
in
{
  inherit
    sensitiveDeny
    sensitiveReadRules
    sensitiveEditRules
    pathRules
    sandboxDenyRead
    sandboxAllowRead
    ;
}
