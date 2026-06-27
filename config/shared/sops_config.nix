{
  config,
  pkgs,
  inputs,
  host,
  ...
}:
let
  isHome = builtins.hasAttr "home" config;
  users = if isHome then [ config.home.username ] else builtins.attrNames host.users;
  homeDir = u: "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/${u}";
in
{
  sops = {
    defaultSopsFile = "${toString inputs.secrets}/secrets.yaml";
    defaultSopsFormat = "yaml";
    age = {
      sshKeyPaths = map (u: "${homeDir u}/.ssh/id_ed25519") users;
      keyFile =
        if isHome then
          "${homeDir config.home.username}/.config/sops/age/key.txt"
        else
          "/etc/sops/age/key.txt";
      generateKey = true;
    };
  };
}
