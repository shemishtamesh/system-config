{
  pkgs,
  lib,
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
    ./documentation.nix
  ];
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

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
      open = false;
      powerManagement = {
        enable = true;
      };
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };

    openrazer = {
      enable = true;
      users = builtins.attrNames host.users;
    };
  };

  nixpkgs = {
    overlays = [
      (_final: prev: {
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          (_python-final: python-prev: {
            onnxruntime = python-prev.onnxruntime.overridePythonAttrs (oldAttrs: {
              # https://github.com/NixOS/nixpkgs/issues/388681
              buildInputs = lib.lists.remove pkgs.onnxruntime oldAttrs.buildInputs;
            });
          })
        ];
      })
    ];
    config = {
      allowUnfree = true;
      cudaSupport = true;
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  stylix = shared.theme.stylix_settings;

  fonts.packages = with pkgs; [ nerd-fonts.fira-code ];

  users.defaultUserShell = pkgs.zsh;
  environment = {
    shells = with pkgs; [ zsh ];
    gnome.excludePackages = with pkgs; [
      totem
      gnome-music
      gnome-usage
      gnome-system-monitor
      gnome-calculator
      gnome-disk-utility
      geary
      epiphany
      gnome-weather
      gnome-color-manager
      gnome-console
      gnome-contacts
      file-roller
      loupe
      snapshot
      simple-scan
      gnome-maps
      gnome-logs
      gnome-calendar
      decibels
      evince
      baobab
    ];
  };
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
    gamemode.enable = true;
    wshowkeys.enable = true;
  };

  virtualisation.docker.enable = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # https://github.com/cachix/cachix/issues/259
    substituters = [
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
      "https://anyrun.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    ];
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
