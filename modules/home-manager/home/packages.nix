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
          with colors;
          {
            inherit base00;
            inherit base01;
            inherit base02;
            inherit base03;
            inherit base04;
            inherit base05;
            inherit base06;
            inherit base07;
            inherit base08;
            inherit base09;
            inherit base0A;
            inherit base0B;
            inherit base0C;
            inherit base0D;
            inherit base0E;
            inherit base0F;
            inherit base10;
            inherit base11;
            inherit base12;
            inherit base13;
            inherit base14;
            inherit base15;
            inherit base16;
            inherit base17;
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
