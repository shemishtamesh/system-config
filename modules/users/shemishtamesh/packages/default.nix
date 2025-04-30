{
  inputs,
  pkgs,
  host,
  ...
}:
let
  shared_modules = [
    ./kitty.nix
    ./git.nix
    ./zsh.nix
    ./starship.nix
    ./zoxide.nix
    ./fzf.nix
    ./bat.nix
    ./btop.nix
    ./direnv.nix
    ./tmux.nix
    ./nixvim.nix
  ];
  shared_packages = with pkgs; [
    libqalculate
    ripgrep
    fd
    eza
    tree
    tldr
    atool
    unrar
    unzip
    wget
    curl
    visidata
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
  ];
  per_host = {
    shenixtamesh = {
      modules = [
        ./protonup.nix
        ./hypridle.nix
        ./hyprlock.nix
        ./hyprpaper.nix
        ./hyprland
        ./waybar.nix
        ./wlogout.nix
        ./dunst.nix
        ./rofi.nix
        ./nixcord.nix
        ./spotify.nix
        ./zen-browser.nix
      ];
      packages = with pkgs; [
        (callPackage ./ohrrpgce { })
        slack
        obsidian
        zathura
        mpv
        bitwarden
        cht-sh
        tetrio-desktop
        furnace
        (pkgs.bottles.override { removeWarningPopup = true; })
        blender
        openscad
        chromium
        audacity
        musescore
        lmms
        krita
        aseprite
        imv
        pulsemixer
        inkscape
        hyprpicker
        hyprshot
        tree-sitter
        wl-clipboard
        gimp
        obs-studio
        libreoffice
        smassh
        koji
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
      ];
    };
    shemishtamac = {
      modules = [
        ./karabiner-elements.nix
        ./databricks.nix
      ];
      packages = with pkgs; [
        slack
        obsidian
        zathura
        mpv
        bitwarden
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
