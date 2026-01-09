{ inputs, username, ... }:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  sops = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    age = {
      sshKeyPaths = [ "/home/${username}/.ssh/id_ed25519" ];
      keyFile = "/home/${username}/.config/sops/age/key.txt";
      generateKey = true;
    };
  };
}
