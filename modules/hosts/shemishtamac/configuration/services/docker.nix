# TODO: this doesn't work and I'm not sure why, I did get these errors at some point:
# ```
# time="2025-05-02T17:12:55+03:00" level=fatal msg="must not run as the root"
# time="2025-05-02T17:12:55+03:00" level=fatal msg="lima compatibility error: error checking Lima version: exit status 1"
# ```
# and this should solve it: https://github.com/nix-darwin/nix-darwin/pull/1275
{ pkgs, ... }:
with pkgs;
{
  environment.systemPackages = [
    colima
    docker
  ];
  # launchd.user.agents."colima.default" = {
  #   path = [
  #     colima
  #     docker
  #   ];
  #   command = "${colima}/bin/colima start --foreground";
  #   serviceConfig = {
  #     Label = "com.colima.default";
  #     RunAtLoad = true;
  #     KeepAlive = true;
  #
  #     # not sure where to put these paths and not reference a hard-coded `$HOME`; `/var/log`?
  #     StandardOutPath = "/var/log/.colima/default/daemon/launchd.stdout.log";
  #     StandardErrorPath = "/var/log/.colima/default/daemon/launchd.stderr.log";
  #
  #     # # not using launchd.agents.<name>.path because colima needs the system ones as well
  #     # EnvironmentVariables = {
  #     #   PATH = "${colima}/bin:${docker}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
  #     # };
  #   };
  # };
}
