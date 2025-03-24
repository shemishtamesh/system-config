profile_makers:
profile_makers.mkNixOnDroidConfiguration {
  profile_name = "shemishtandroid"; # not hostname because hostname is not configurable on nix-on-droid anyway
  system = "x86_64-linux";
}

# host:
# {
#   environment.packages = with pkgs; [
#     vim
#   ];
#   terminal.font = "${pkgs.fira-code}/share/fonts/truetype/FiraCode-VF.ttf";
#   system.stateVersion = "24.05";
#   nix.extraOptions = "experimental-features = nix-command flakes";
# }
