{
  inputs,
  username,
  pkgs,
  options,
  ...
}:
let
  inherit (inputs) sops-nix;
  home = "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/${username}";
in
{
  imports = [
    (
      if options ? home then
        sops-nix.homeManagerModules.sops
      else if pkgs.stdenv.isDarwin then
        sops-nix
      else
        sops-nix.nixosModules.sops
    )
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
}
