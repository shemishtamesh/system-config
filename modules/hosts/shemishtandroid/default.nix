profile_makers:
profile_makers.mkNixOnDroidConfiguration {
  hostname = "shemishtandroid"; # hostname isn't realy configurable on nix-on-droid (https://github.com/nix-community/nix-on-droid/issues/51), this is just for the profile maker to find the config
  system = "aarch64-linux";
  users.shemishtamesh = { }; # users can't actually be defined, this is just for home-manager conf
}
{ hostname = "shemishtandroid"; system = "aarch64-linux"; users.shemishtamesh = { }; }
profile_makers.mkNixOnDroidConfiguration 
# {
#   nixOnDroidConfigurations = {
#     inherit pkgs;
#     default = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
#       modules = [ ];
#     };
#     extraSpecialArgs = {
#       inherit inputs;
#     };
#   };
# }

# host:
# {
#   environment.packages = with pkgs; [
#     vim
#   ];
#   terminal.font = "${pkgs.fira-code}/share/fonts/truetype/FiraCode-VF.ttf";
#   system.stateVersion = "24.05";
#   nix.extraOptions = "experimental-features = nix-command flakes";
# }
