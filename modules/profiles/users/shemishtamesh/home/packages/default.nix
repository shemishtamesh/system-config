{
  inputs,
  pkgs,
  host,
  ...
}:
let
  shared_modules = [
    ./git.nix
    ./zsh.nix
    ./starship.nix
    ./zoxide.nix
    ./fzf.nix
    ./direnv.nix
    # ./tmux.nix
    ./kitty.nix
    ./nixvim.nix
  ];
  shared_packages = with pkgs; [
    libqalculate
    ripgrep
    bat
    fd
    eza
    tree
    tldr
    btop
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
    slack
    obsidian
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
        ./hyprland.nix
        ./waybar.nix
        ./wlogout.nix
        ./dunst.nix
        ./rofi.nix
      ];
      packages = with pkgs; [
        (callPackage ./ohrrpgce { })
        inputs.zen-browser.packages.${system}.default
        cht-sh
        tetrio-desktop
        bottles
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
        wev
        gimp
        obs-studio
        libreoffice
        smassh
        koji
        bitwarden
        slides
        difftastic
        wtype
        libnotify
        whatsapp-for-linux
        discord-screenaudio
        spotify
        easyeffects
        pavucontrol
        cliphist
        zathura
        mpv
        vlc
        lorien
        qpwgraph
        transmission_4-gtk
        tremc
        steam-tui
        lutris
      ];
    };
    shemishtamac = {
      modules = [ ./karabiner-elements.nix ];
    };
  };
in
{
  imports = shared_modules ++ (per_host.${host.hostname}.modules or [ ]);
  home.packages = shared_packages ++ (per_host.${host.hostname}.packages or [ ]);
}
