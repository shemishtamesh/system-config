{
  pkgs,
  shared,
  inputs,
  host,
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
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables = {
    MANROFFOPT = "-c";
    MANWIDTH = "999";
    MANPAGER = "nvim +Man!";
    EDITOR = "nvim";

    NIXOS_OZONE_WL = "1";
  };

  stylix = {
    enable = true;
    base16Scheme = shared.theme.scheme;
    fonts = shared.theme.fonts;
  };

  fonts.packages = with pkgs; [ nerd-fonts.fira-code ];

  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs = {
    zsh = {
      enable = true;
      enableLsColors = true;
      setOptions = [
        "HIST_IGNORE_SPACE"
        "HIST_IGNORE_DUPS"
        "SHARE_HISTORY"
        "HIST_FCNTL_LOCK"
        "EXTENDED_HISTORY"
        "AUTO_PUSHD"
        "PUSHD_MINUS"
        "CDABLE_VARS"
        "promptsubst"
        "autocd"
      ];
      histSize = 100000;
      interactiveShellInit = # sh
        ''
          # completions
          autoload -U compinit && compinit   # load + start completion
          zstyle ':completion:*:directory-stack' list-colors '=(#b) #([0-9]#)*( *)==95=38;5;12'
          autoload -U compinit
          zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
          zstyle ':completion:*' menu select
          zmodload zsh/complist
          compinit
          _comp_options+=(globdots)

          # vi mode
          bindkey -v
          export KEYTIMEOUT=1
          # Change cursor shape for different vi modes.
          function zle-keymap-select {
            if [[ ''${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
              echo -ne '\e[1 q'
            elif [[ ''${KEYMAP} == main ]] || [[ ''${KEYMAP} == viins ]] \
              || [[ ''${KEYMAP} = "" ]] || [[ $1 = 'beam' ]]; then
              echo -ne '\e[5 q'
            fi
          }
          zle -N zle-keymap-select
          zle-line-init() {
            zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
            echo -ne "\e[5 q"
          }
          zle -N zle-line-init
          echo -ne '\e[5 q' # Use beam shape cursor on startup.
          preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.


          # Edit line in vim with ctrl-e:
          autoload edit-command-line; zle -N edit-command-line
          bindkey '^e' edit-command-line
        '';
    };
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
