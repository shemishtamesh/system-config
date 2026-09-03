# https://github.com/NixOS/nixpkgs/issues/305868).
{ pkgs, config, ... }:
let
  primaryUser = config.system.primaryUser;
  machineName = "podman-machine-default";
in
{
  environment.systemPackages = [
    pkgs.podman
    pkgs.vfkit
  ];

  system.activationScripts.postActivation.text = ''
    if ! sudo -u ${primaryUser} -H ${pkgs.podman}/bin/podman machine inspect ${machineName} &>/dev/null; then
      echo "Initializing podman machine '${machineName}'..."
      sudo -u ${primaryUser} -H ${pkgs.podman}/bin/podman machine init ${machineName}
    fi
  '';

  launchd.user.agents."podman.machine" = {
    path = [
      pkgs.podman
      pkgs.vfkit
    ];
    command = "${pkgs.podman}/bin/podman machine start ${machineName}";
    serviceConfig = {
      Label = "com.podman.machine";
      RunAtLoad = true;
      AbandonProcessGroup = true;
      KeepAlive = false;

      StandardOutPath = "/tmp/podman-machine.stdout.log";
      StandardErrorPath = "/tmp/podman-machine.stderr.log";
    };
  };
}
