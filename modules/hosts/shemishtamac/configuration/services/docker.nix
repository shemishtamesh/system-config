# taken from here https://github.com/nix-darwin/nix-darwin/issues/1182#issuecomment-2485401568
{ pkgs, ... }:
{
  system.activationScripts.activate_colima = {
    enable = true;
    text = # sh
      ''
        launchctl load -w /Library/LaunchAgents/com.colima.default.plist
      '';
  };
  launchd.agents."colima.default" = {
    command = "${pkgs.colima}/bin/colima start --foreground";
    serviceConfig = {
      Label = "com.colima.default";
      RunAtLoad = true;
      KeepAlive = true;

      StandardOutPath = "/var/log/colima/default/daemon/launchd.stdout.log";
      StandardErrorPath = "/var/log/colima/default/daemon/launchd.stderr.log";

      EnvironmentVariables = {
        PATH = "${pkgs.colima}/bin:${pkgs.docker}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
    };
  };
}
