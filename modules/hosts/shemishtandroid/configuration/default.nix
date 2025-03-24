{
  # config,
  # lib,
  pkgs,
  ...
}:
{
  environment.packages = with pkgs; [
    vim
  ];
  terminal.font = "${pkgs.fira-code}/share/fonts/truetype/FiraCode-VF.ttf";
  system.stateVersion = "24.05";
  nix.extraOptions = "experimental-features = nix-command flakes";
}
