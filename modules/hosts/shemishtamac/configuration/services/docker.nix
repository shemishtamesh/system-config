{ pkgs, ... }:
with pkgs;
{
  environment.systemPackages = [
    colima
    docker
  ];

  launchd.user.agents.colima = {
    path = [
      colima
      docker
    ];
    command = "${colima}/bin/colima start --foreground";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
    };
  };
}
