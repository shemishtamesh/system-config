{
  config,
  pkgs,
  lib,
  inputs,
  host,
  ...
}:
let
  isHome = builtins.hasAttr "home" config;
  users = if isHome then [ config.home.username ] else builtins.attrNames host.users;
  homeDir = username: "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/${username}";
in
{
  sops = {
    defaultSopsFile = "${toString inputs.secrets}/secrets.yaml";
    defaultSopsFormat = "yaml";
    age = {
      sshKeyPaths = map (username: "${homeDir username}/.ssh/id_ed25519") users;
      keyFile =
        if isHome then
          "${homeDir config.home.username}/.config/sops/age/key.txt"
        else
          "/etc/sops/age/key.txt";
      generateKey = true;
    };
  }
  // lib.optionalAttrs isHome {
    home.packages = [ pkgs.sops ];
  }
  // lib.optionalAttrs (!isHome) {
    environment.systemPackages = [ pkgs.sops ];

    # TODO: sops-install-secrets v0.0.1 cannot decrypt ssh-ed25519 recipients
    # using age keys derived from SSH keys. This env var tells the sops library
    # to use the SSH key directly. Only one key is supported, so the first
    # user's key is used (any matching key suffices for NixOS activation).
    # See: https://github.com/Mic92/sops-nix/issues/824
    #      https://github.com/Mic92/sops-nix/pull/779
    environment.SOPS_AGE_SSH_PRIVATE_KEY_FILE = "${homeDir (builtins.head (builtins.attrNames host.users))}/.ssh/id_ed25519";
  };
}
