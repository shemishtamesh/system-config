{
  inputs,
  username,
  pkgs,
  ...
}:
let
  home = "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/${username}";
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  home.packages = with pkgs; [ sops ];
  sops = {
    defaultSopsFile = "${toString inputs.secrets}/secrets.yaml";
    defaultSopsFormat = "yaml";
    age = {
      sshKeyPaths = [
        "${home}/.ssh/id_ed25519"
      ];
      keyFile = "${home}/.config/sops/age/key.txt";
      generateKey = true;
    };
  };
  launchd.agents.sops-nix = pkgs.lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    config = {
      EnvironmentVariables = {
        PATH = pkgs.lib.mkForce "/usr/bin:/bin:/usr/sbin:/sbin";
      };
    };
  };
}
