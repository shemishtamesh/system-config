{ pkgs, ... }:
with pkgs;
{
  environment.systemPackages = [
    colima
    docker
  ];
  launchd.agents."colima.default" = {
    # path = [
    #   colima
    #   docker
    # ];
    command = "${colima}/bin/colima start --foreground &> /tmp/colima_test";
    serviceConfig = {
      Label = "com.colima.default";
      RunAtLoad = true;
      KeepAlive = true;

      # not sure where to put these paths and not reference a hard-coded `$HOME`; `/var/log`?
      StandardOutPath = "/var/log/.colima/default/daemon/launchd.stdout.log";
      StandardErrorPath = "/var/log/.colima/default/daemon/launchd.stderr.log";

      # not using launchd.agents.<name>.path because colima needs the system ones as well
      EnvironmentVariables = {
        PATH = "${colima}/bin:${docker}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
    };
  };
}
