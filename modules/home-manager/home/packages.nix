{
  inputs,
  pkgs,
  config,
  ...
}:

{
  imports = [
    ./apps/protonup.nix
  ];

  home.packages = with pkgs; [
    (inputs.nixvim.packages.${system}.default.extend {
      colorschemes.base16 = {
        enable = true;

        colorscheme =
          let
            colors = config.lib.stylix.colors.withHashtag;
          in
          {
            base00 = colors.base00;
            base01 = colors.base01;
            base02 = colors.base02;
            base03 = colors.base03;
            base04 = colors.base04;
            base05 = colors.base05;
            base06 = colors.base06;
            base07 = colors.base07;
            base08 = colors.base08;
            base09 = colors.base09;
            base0A = colors.base0A;
            base0B = colors.base0B;
            base0C = colors.base0C;
            base0D = colors.base0D;
            base0E = colors.base0E;
            base0F = colors.base0F;
          };
      };

      highlight =
        let
          cfg = config.stylix.targets.nixvim;
          transparent = {
            bg = "none";
            ctermbg = "none";
          };
        in
        {
          Normal = lib.mkIf cfg.transparent_bg.main transparent;
          NonText = lib.mkIf cfg.transparent_bg.main transparent;
          SignColumn = lib.mkIf cfg.transparent_bg.sign_column transparent;
        };
    })
    # inputs.nixvim.packages.${pkgs.system}.default
    atool
    unrar
    unzip
    tetrio-desktop
    bottles
    cht-sh
    (callPackage ./apps/ohrrpgce { })
    inputs.zen-browser.packages.${system}.default
    libreoffice
    blender
    openscad
    chromium
    audacity
    musescore
    lmms
    gimp
    krita
    aseprite
    imv
    pulsemixer
    inkscape
    hypridle
    hyprpaper
    hyprpicker
    hyprshot
    hyprlock
    libqalculate
    ripgrep
    bat
    fd
    zoxide
    eza
    fzf
    rmtrash
    trash-cli
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
    koji
    zoxide
    glow
    slides
    yazi
    axel
    difftastic
    killall
    waybar
    rofimoji
    wtype
    dunst
    libnotify
    whatsapp-for-linux
    discord-screenaudio
    slack
    spotify
    obs-studio
    easyeffects
    pavucontrol
    cliphist
    wlogout
    zathura
    mpv
    vlc
    obsidian
    lorien
    qpwgraph
    fastfetch
    transmission_4-gtk
    tremc
    steam-tui
    lutris
  ];
}
