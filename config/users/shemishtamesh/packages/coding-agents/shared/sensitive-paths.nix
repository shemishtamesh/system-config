let
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

  # External directory: ask by default, deny known sensitive paths
  externalDirectoryDeny = {
    "*" = "ask";
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

  # For tools that use a path-based permission system (like pi)
  pathRules = {
    "*" = "allow";
  }
  // {
    "**/*.envrc" = "ask";
  }
  // sensitiveDeny;

in
{
  inherit
    sensitiveDeny
    sensitiveReadRules
    sensitiveEditRules
    externalDirectoryDeny
    pathRules
    ;
}
