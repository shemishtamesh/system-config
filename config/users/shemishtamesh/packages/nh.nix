{ pkgs, shared, ... }:
{
  home = {
    packages = with pkgs; [ nh ];
    sessionVariables = {
      NH_FLAKE = shared.constants.FLAKE_ROOT;
    };
  };
}
