{
  inputs,
  pkgs,
  host,
  ...
}:
let
  stable-pkgs = import inputs.nixpkgs-stable {
    inherit (host) system;
    config.allowUnfree = true;
  };
  shared_modules = [
    ./documentation.nix
    # ./kitty.nix
    ./wezterm.nix
    ./git.nix
    ./zsh.nix
    ./starship.nix
    ./zoxide.nix
    ./fzf.nix
    ./atuin.nix
    ./carapace.nix
    ./bat.nix
    ./btop.nix
    ./direnv.nix
    ./tmux.nix
    ./tattoy.nix
    ./nixvim.nix
    ./nix-index.nix
    ./mpv.nix
    ./zathura.nix
    ./opencode.nix
  ];
  shared_packages = with pkgs; [
    libqalculate
    ripgrep
    fd
    eza
    tldr
    atool
    unrar
    unzip
    wget
    curl
    glow
    rmtrash
    trash-cli
    fastfetch
    yazi
    killall
    nh
    nps
    nix-diff
    nix-output-monitor
    nvd
    devenv
    bitwarden-desktop
    obsidian
    slack
  ];
  per_host = {
    shenixtamesh = {
      modules = [
        ./hyprland
        ./hypridle.nix
        # ./hyprlock.nix
        # ./hyprpaper.nix
        ./hyprcursor.nix
        # ./hyprlauncher.nix
        # ./rofi.nix
        # ./waybar.nix
        ./protonup.nix
        # ./wlogout.nix
        # ./dunst.nix
        ./spotify.nix
        ./zen-browser.nix
        ./nixcord.nix
        ./noctalia.nix
        # ./anyrun.nix
        # ./quickshell
        # ./anki
        ./ssh.nix
      ];
      packages = with pkgs; [
        (callPackage ./ohrrpgce { })
        cht-sh
        tetrio-desktop
        furnace
        (pkgs.bottles.override { removeWarningPopup = true; })
        blender
        openscad
        audacity
        musescore
        stable-pkgs.lmms
        krita
        stable-pkgs.aseprite
        imv
        pulsemixer
        inkscape
        hyprpicker
        hyprshot
        wl-clipboard
        gimp
        obs-studio
        libreoffice
        smassh
        slides
        difftastic
        altus
        easyeffects
        pavucontrol
        cliphist
        vlc
        lorien
        qpwgraph
        transmission_4-gtk
        airshipper
        solarus-quest-editor
        scrcpy
        visidata
        android-tools
      ];
    };
    shemishtamac = {
      modules = [
        ./karabiner-elements.nix
        ./databricks.nix
      ];
      packages = with pkgs; [
        maccy
        google-cloud-sdk
        stable-pkgs.visidata
      ];
    };
  };
in
{
  # sorting to help comparing different builds
  imports = builtins.sort builtins.lessThan (
    shared_modules ++ (per_host.${host.hostname}.modules or [ ])
  );
  home.packages = builtins.sort (a: b: a.outPath < b.outPath) (
    shared_packages ++ (per_host.${host.hostname}.packages or [ ])
  );
}
