{ config, inputs, pkgs, theme, system, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ../general/scripts.nix
    ];

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    kernelModules = [ "snd-seq" "snd-rawmidi" "v4l2loopback" ];
  };
  security.polkit.enable = true;

  networking = {
    hostName = "shenixtamesh"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networkmanager.enable = true;

    nameservers = [
      "94.140.14.14"
      "94.140.15.15"
      "2a10:50c0::ad1:ff"
      "2a10:50c0::ad2:ff"
      "1.1.1.1"
    ];
    # If using dhcpcd:
    dhcpcd.extraConfig = "nohook resolv.conf";
    # If using NetworkManager:
    networkmanager.dns = "none";

    # Open ports in the firewall.
    firewall = {
      allowedTCPPorts = [ 8080 ];
      allowedTCPPortRanges = [
        { from = 1714; to = 1764; } # KDE Connect
      ];
      allowedUDPPortRanges = [
        { from = 1714; to = 1764; } # KDE Connect
      ];
      # # Or disable the firewall altogether.
      # enable = false;
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Jerusalem";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.ollama = {
    enable = true;
    openFirewall = true;
    environmentVariables = {
      OLLAMA_HOST = "0.0.0.0";
    };
  };
  services.open-webui = {
    enable = true;
    environment.OLLAMA_API_BASE_URL = "http://localhost:11434";
    host = "0.0.0.0";
  };

  services = {
    syncthing = {
      enable = true;
      user = "shemishtamesh";
      dataDir = "/home/shemishtamesh/Documents";
      configDir = "/home/shemishtamesh/.config/syncthing";
      overrideDevices = true;
      overrideFolders = true;
      settings = {
        devices = {
          "Pixel 7 Pro" = { id = "Q35X57O-SPYHCOF-6N3HLH4-OQUN6M7-7D7X7T4-DXI7ZCK-JTWUOSX-2YE3IAH"; };
          "work_pc" = { id = "QK20V3H-G5ZZKKA-STI2UJN-SWTWVOG-2SBLZ2A-T6MUGD4-Z2E0M5U-QJNOJQD"; };
        };
        folders = {
          "general_vault" = {
            path = "/home/shemishtamesh/Documents/general_vault";
            devices = [ "Pixel 7 Pro" "work_pc" ];
          };
        };
      };
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.shemishtamesh = {
    isNormalUser = true;
    description = "shemishtamesh";
    extraGroups = [ "networkmanager" "wheel" "input" "adbusers" "docker" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables = rec {
    MANROFFOPT = "-c";
    MANWIDTH = "999";
    MANPAGER = "nvim +Man!";
    EDITOR = "nvim";

    NIXOS_OZONE_WL = "1";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    qalculate-gtk
    fastfetch
    inputs.zen-browser.packages.${system}.default
    speechd
    gimp
    aseprite
    imv
    pulsemixer
    inkscape
    acpi
    hypridle
    hyprpaper
    hyprpicker
    hyprshot
    hyprlock
    ripgrep
    bat
    fd
    zoxide
    eza
    fzf
    rmtrash
    playerctl
    brightnessctl
    vim
    neovim
    visidata
    tldr
    tree-sitter
    wl-clipboard
    btop
    wev
    tree
    nh
    nix-output-monitor
    nvd
    smassh
    bitwarden
    kitty
    starship
    tmux
    wget
    curl
    git
    zoxide
    yazi
    axel
    difftastic
    killall
    waybar
    rofi-wayland
    rofimoji
    wtype
    dunst
    libnotify
    whatsapp-for-linux
    gcc
    cargo
    rustc
    python3
    nodejs
    discord-screenaudio
    slack
    spotify
    obs-studio
    pavucontrol
    cliphist
    wlogout
    mpv
    vlc
    obsidian
    lorien
    transmission_4-gtk
    qpwgraph
  ];

  stylix = {
    enable = true;
    base16Scheme = theme.scheme;
    image = theme.wallpaper;
    fonts = theme.fonts;
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  environment.shells = with pkgs; [ bash zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
  programs.zsh = {
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
    enableLsColors = true;
    interactiveShellInit = /* sh */ ''
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

  programs.hyprland.enable = true;

  programs.adb.enable = true;

  # programs.nixvim.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  virtualisation.docker.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # xdg.portal = {
  #   enable = true;
  #   extraPortals = [
  #     pkgs.xdg-desktop-portal-kde # for kdeconnect
  #   ];
  # };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
