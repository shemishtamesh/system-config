{ pkgs, shared, ... }:
{
  home = {
    packages = with pkgs; [ nh ];
    sessionVariables = {
      FLAKE = shared.constants.FLAKE_ROOT;
    };
  };
}
