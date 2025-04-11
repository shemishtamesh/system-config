{
  pkgs,
  shared,
  inputs,
  host,
  config,
  ...
}:

{
  imports = [
    ./generated_hardware_configuration.nix
    ./boot.nix
    ./networking.nix
    ./storage_cleaning.nix
    ./localization.nix
    ./security.nix
    ./services.nix
  ];
  xdg.portal.enable = true;

  hardware = {
    keyboard.qmk.enable = true;

    bluetooth.enable = true; # enables support for Bluetooth
    bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        nvidia-vaapi-driver
      ];
    };

    nvidia = {
      modesetting.enable = true;
      open = true;
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  stylix = shared.theme.stylix_settings;

  fonts.packages = with pkgs; [ nerd-fonts.fira-code ];

  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs = {
    zsh.enable = true;
    adb.enable = true;
    hyprland =
      let
        flake_hyprland = inputs.hyprland.packages.${host.system};
      in
      {
        enable = true;
        package = flake_hyprland.hyprland;
        portalPackage = flake_hyprland.xdg-desktop-portal-hyprland;
      };
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
  };

  virtualisation.docker.enable = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # https://github.com/cachix/cachix/issues/259
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    trusted-users = [ "@wheel" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
