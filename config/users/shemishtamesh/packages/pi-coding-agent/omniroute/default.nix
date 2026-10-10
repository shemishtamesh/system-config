{ pkgs, ... }:
let
  omniroute-package = import ./package.nix { inherit pkgs; lib = pkgs.lib; };
in
{
  services.omniroute = {
    enable = true;
    serviceConfig = {
      Type = "simple";
      ExecStart = "${omniroute-package}/bin/omniroute start";
      Restart = "on-failure";
      RestartSec = 5;
      TimeoutStartSec = "infinity";
    };
    installWantedBy = "default.target";
  };
}
