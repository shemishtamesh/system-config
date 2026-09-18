{
  pkgs,
  config,
  jsonFormat,
}:
let
  landstrip = import ./landstrip { inherit pkgs; };

  # Commands whose effects are not fully contained by Landstrip.
  bashDenyPatterns = {
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

    # home-manager / NixOS generation activation
    "home-manager switch*" = "deny";
    "home-manager activate*" = "deny";
    "home-manager rollback*" = "deny";
    "home-manager expire-generations*" = "deny";
    # nixos-rebuild / darwin-rebuild generation activation
    "nixos-rebuild switch*" = "deny";
    "nixos-rebuild boot*" = "deny";
    "nixos-rebuild test*" = "deny";
    "nixos-rebuild rollback*" = "deny";
    "darwin-rebuild switch*" = "deny";
    "darwin-rebuild boot*" = "deny";
    "darwin-rebuild test*" = "deny";
    "darwin-rebuild rollback*" = "deny";
    # nix profile (store-profile) mutations
    "nix profile install*" = "deny";
    "nix profile remove*" = "deny";
    "nix profile upgrade*" = "deny";
    "nix profile rollback*" = "deny";
    "nix profile wipe-history*" = "deny";
    "nix profile history*" = "deny";
    # nix-env mutations
    "nix-env -i*" = "deny";
    "nix-env --install*" = "deny";
    "nix-env -e*" = "deny";
    "nix-env --erase*" = "deny";
    "nix-env -u*" = "deny";
    "nix-env --upgrade*" = "deny";
    "nix-env -r*" = "deny";
    "nix-env --rollback*" = "deny";
    # channels
    "nix-channel --add*" = "deny";
    "nix-channel --remove*" = "deny";
    "nix-channel --update*" = "deny";
    "nix-channel --rollback*" = "deny";
    # flake registry mutations
    "nix registry add*" = "deny";
    "nix registry remove*" = "deny";
    "nix registry pin*" = "deny";
    "nix registry update*" = "deny";
    # store mutations / garbage collection
    "nix copy --to*" = "deny";
    "nix gc*" = "deny";
    "nix optimise-store*" = "deny";
    "nix-store --delete*" = "deny";
    "nix-store --add*" = "deny";
    "nix-store --add-root*" = "deny";
    "nix-store --load-db*" = "deny";
  };

  secretFiles = [
    "**/.env"
    "**/.env.*"
    "**/.envrc"
    "**/*.pem"
    "**/*.key"
    "**/.netrc"
    "**/.npmrc"
    "**/.pypirc"
    "**/.git-credentials"
  ];

  absoluteReadDenyDirectories =
    if pkgs.stdenv.hostPlatform.isDarwin then
      [
        "/private/etc"
        "/private/var"
        "/private/tmp"
        "/Users"
        "/System"
        "/Library"
        "/var/root"
        "/cores"
        "/Volumes"
      ]
    else
      [
        "/home"
        "/root"
        "/etc"
        "/run"
        "/var"
        "/var/tmp"
        "/tmp"
        "/proc"
        "/sys"
        "/mnt"
        "/media"
        "/boot"
      ];

  devicePaths = [
    "/dev/null"
    "/dev/urandom"
    "/dev/random"
    "/dev/zero"
  ];

  temporaryPaths =
    if pkgs.stdenv.hostPlatform.isDarwin then [ "~/.cache/pi-tmp" ] else [ "/tmp/pi-agent" ];

  sharedReadWritePaths = [
    "."
    "~/.cache/nix"
    "~/.cache/typst"
  ]
  ++ temporaryPaths;

  readOnlyPaths = [
    "/nix/store"
    "/run/current-system"
    "~/.nix-profile"
    "~/.local/state/nix"
    "~/.config/git/ignore"
    "~/.pi"
    "/etc/passwd"
  ]
  ++ pkgs.lib.optional pkgs.stdenv.hostPlatform.isLinux "/proc/sys/vm/overcommit_memory";

  readAllowPaths = sharedReadWritePaths ++ readOnlyPaths;
  writeAllowPaths = sharedReadWritePaths;
  allExternalAllowPaths = readAllowPaths ++ devicePaths;

  expandHome = path: pkgs.lib.replaceStrings [ "~" ] [ config.home.homeDirectory ] path;
  externalPaths = paths: map expandHome (builtins.filter (path: path != ".") paths);

  pathRules =
    action: state: paths:
    pkgs.lib.listToAttrs (
      pkgs.lib.concatMap (path: [
        {
          name = "${action}:${path}";
          value = state;
        }
        {
          name = "${action}:${path}/*";
          value = state;
        }
      ]) paths
    );

  nativeFileTools = [
    "read"
    "write"
    "edit"
  ];
  nativeWriteTools = [
    "write"
    "edit"
  ];
  writeDenyPaths = [ "**/.pi" ];

  nativeToolDenies = pkgs.lib.mergeAttrsList (
    (map (tool: pathRules tool "deny" secretFiles) nativeFileTools)
    ++ (map (tool: pathRules tool "deny" writeDenyPaths) nativeWriteTools)
    ++ (map (tool: pathRules tool "deny" (externalPaths readOnlyPaths)) nativeWriteTools)
  );

  externalAllowRules = pathRules "external_directory" "allow" (externalPaths allExternalAllowPaths);

  filesystemDenyReadPaths = secretFiles ++ absoluteReadDenyDirectories;

  filesystemPolicy = {
    denyRead = filesystemDenyReadPaths;
    denyWrite = filesystemDenyReadPaths ++ writeDenyPaths;
    allowRead = readAllowPaths ++ devicePaths;
    allowWrite = writeAllowPaths ++ devicePaths;
  };

  landstripNoisePattern = ''^\{"kind":"filesystem","code":"FILESYSTEM_DENIED".*"path":"(/proc/[0-9]+/(maps|cgroup)|/sys/kernel/mm/transparent_hugepage/hpage_pmd_size)"'';

  landstripPolicy = jsonFormat.generate "pi-landstrip-policy.json" {
    network = {
      allowNetwork = true;
      allowLocalBinding = false;
      allowUnixSockets = [ "/nix/var/nix/daemon-socket/socket" ];
    };
    filesystem = filesystemPolicy;
  };
in
{
  bashScrubber = pkgs.writeShellScriptBin "bash" ''
    for name in $(${pkgs.coreutils}/bin/env | ${pkgs.coreutils}/bin/cut -d= -f1); do
      normalizedName="''${name,,}"
      case "$normalizedName" in
        *key*|*token*|*api*|*secret*|*credential*|*password*|\
        *auth*|*bearer*|*jwt*|*private*|*passphrase*|*cookie*|\
        *session*|*signing*|\
        ssh_agent_pid|gpg_agent_info|aws_profile|azure_config_dir|\
        google_cloud_project|kubeconfig|docker_config|netrc)
          unset "$name"
          ;;
      esac
    done
    exec ${landstrip}/bin/landstrip run -p ${landstripPolicy} -- \
      ${pkgs.bash}/bin/bash --noprofile --norc "$@" \
      2> >(${pkgs.gnugrep}/bin/grep --line-buffered -Ev ${pkgs.lib.escapeShellArg landstripNoisePattern})
  '';

  inherit landstripPolicy;

  enabledNativeTools = [
    "read"
    "bash"
    "edit"
    "write"
    "ls"
  ];

  excludedNativeTools = [
    "grep"
    "find"
  ];

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
      # Keep these denied if a child session registers them again.
      grep = "deny";
      find = "deny";
    }
    // nativeToolDenies;
    bash = bashDenyPatterns;
    skills."*" = "allow";
    special = {
      external_directory = "deny";
    }
    // externalAllowRules;
  };
}
