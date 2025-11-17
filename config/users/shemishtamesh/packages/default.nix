{
  inputs,
  pkgs,
  host,
  ...
}:
let
  stable-pkgs = import inputs.nixpkgs-stable {
    system = host.system;
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
        ./protonup.nix
        ./hypridle.nix
        ./hyprlock.nix
        ./hyprpaper.nix
        ./hyprcursor.nix
        ./hyprland
        ./waybar.nix
        ./wlogout.nix
        ./dunst.nix
        ./rofi.nix
        ./spotify.nix
        ./zen-browser.nix
        ./nixcord.nix
        # ./anyrun.nix
        # ./astal
        ./quickshell
        # ./anki
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
