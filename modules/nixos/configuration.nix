{
  pkgs,
  theme,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./configuration/boot.nix
    ./configuration/networking.nix
  ];

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Asia/Jerusalem";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  hardware = {
    keyboard.qmk.enable = true;

    bluetooth.enable = true; # enables support for Bluetooth
    bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  };

  services = {
    pulseaudio.enable = false;
    blueman.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    udev.extraRules = ''
      KERNEL=="i2c-[0-9]*", GROUP="wheel", MODE="0660"
    ''; # external monitor brightness control
    xserver = {
      # Enable the X11 windowing system.
      enable = true;

      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
      xkb = {
        # Configure keymap in X11
        layout = "us";
        variant = "";
      };
    };
    printing.enable = true; # Enable CUPS to print documents.
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
    syncthing = {
      enable = true;
      user = "shemishtamesh";
      dataDir = "/home/shemishtamesh/Documents";
      configDir = "/home/shemishtamesh/.config/syncthing";
      overrideDevices = true;
      overrideFolders = true;
      settings = {
        devices = {
          "Pixel 7 Pro" = {
            id = "Q35X57O-SPYHCOF-6N3HLH4-OQUN6M7-7D7X7T4-DXI7ZCK-JTWUOSX-2YE3IAH";
          };
          "work_pc" = {
            id = "QK20V3H-G5ZZKKA-STI2UJN-SWTWVOG-2SBLZ2A-T6MUGD4-Z2E0M5U-QJNOJQD";
          };
        };
        folders = {
          "general_vault" = {
            path = "/home/shemishtamesh/Documents/general_vault";
            devices = [
              "Pixel 7 Pro"
              "work_pc"
            ];
          };
        };
      };
    };
    ollama = {
      enable = true;
      openFirewall = true;
      environmentVariables = {
        OLLAMA_HOST = "0.0.0.0";
      };
    };
    open-webui = {
      enable = true;
      environment.OLLAMA_API_BASE_URL = "http://localhost:11434";
      host = "0.0.0.0";
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.shemishtamesh = {
    isNormalUser = true;
    description = "shemishtamesh";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "adbusers"
      "docker"
    ];
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
    base16Scheme = theme.scheme;
    image = theme.wallpaper;
    fonts = theme.fonts;
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
    hyprland.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
  };

  virtualisation.docker.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
