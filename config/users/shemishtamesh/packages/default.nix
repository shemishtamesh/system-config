{
  pkgs,
  stable-pkgs,
  host,
  ...
}:
let
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
    # ./tattoy.nix
    ./nixvim.nix
    ./nix-index.nix
    ./zen-browser.nix
    ./opencode.nix
    ./claude-code.nix
    ./nh.nix
    ./bitwarden.nix
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
    nps
    nix-diff
    nix-output-monitor
    nvd
    nixpkgs-track
    devenv
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
        ./nixcord.nix
        ./noctalia.nix
        # ./anyrun.nix
        ./quickshell
        # ./anki
        ./ssh.nix
        ./mpv.nix
        ./zathura.nix
        ./silverbullet.nix
      ];
      packages = with pkgs; [
        (callPackage ./ohrrpgce { })
        cht-sh
        tetrio-desktop
        furnace
        (stable-pkgs.bottles.override { removeWarningPopup = true; })
        stable-pkgs.blender
        stable-pkgs.openscad
        audacity
        musescore
        stable-pkgs.lmms
        stable-pkgs.krita
        stable-pkgs.aseprite
        imv
        pulsemixer
        stable-pkgs.inkscape
        hyprpicker
        hyprshot
        wl-clipboard
        stable-pkgs.gimp
        obs-studio
        stable-pkgs.libreoffice
        smassh
        slides
        difftastic
        altus
        easyeffects
        pavucontrol
        cliphist
        vlc
        qpwgraph
        transmission_4-gtk
        airshipper
        solarus-quest-editor
        scrcpy
        visidata
        android-tools
        drawy
      ];
    };
    shemishtamac = {
      modules = [
        ./karabiner-elements.nix
        ./databricks.nix
      ];
      packages = with pkgs; [
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
