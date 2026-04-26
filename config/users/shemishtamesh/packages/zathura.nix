{
  inputs,
  host,
  ...
}:
let
  stable-pkgs = import inputs.nixpkgs-stable {
    inherit (host) system;
    config.allowUnfree = true;
  };
in
{
  programs.zathura = {
    enable = true;
    package = stable-pkgs.zathura;
    options = {
      guioptions = "none";
    };
  };
}
