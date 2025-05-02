{ pkgs, ... }:
with pkgs;
{
  environment.systemPackages = [
    colima
    docker
  ];

  launchd.user.agents.ollama = {
    path = [
      oclima
      docker
    ];
    command = "${colima}/bin/colima start";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
    };
  };
}
