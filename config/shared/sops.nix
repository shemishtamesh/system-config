{
  inputs,
  username,
  pkgs,
  ...
}:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  home.packages = with pkgs; [ sops ];
  sops = {
    defaultSopsFile = ./${toString inputs.secrets}/secrets.yaml;
    defaultSopsFormat = "yaml";
    age = {
      sshKeyPaths = [ "/home/${username}/.ssh/id_ed25519" ];
      keyFile = "/home/${username}/.config/sops/age/key.txt";
      generateKey = true;
    };
  };
}
