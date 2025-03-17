{
  inputs,
  pkgs,
  host,
  ...
}:
{
  imports =
    [
      ./git.nix
      ./zsh.nix
      ./starship.nix
      ./zoxide.nix
      ./fzf.nix
      ./direnv.nix
      ./tmux.nix
      ./kitty.nix
      ./nixvim.nix
    ]
    ++ (
      if host.hostname == "shenixtamesh" then
        [
          ./protonup.nix
          ./hypridle.nix
          ./hyprland.nix
          ./waybar.nix
          ./wlogout.nix
          ./dunst.nix
          ./rofi.nix
        ]
      else
        [ ]
    );

  home.packages =
    with pkgs;
    [
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
    ]
    ++ (
      if host.hostname == "shenixtamesh" then
        [
          cht-sh
          inputs.zen-browser.packages.${system}.default
          tetrio-desktop
          bottles
          (callPackage ./ohrrpgce { })
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
          nh
          nix-diff
          nix-output-monitor
          nvd
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
        ]
      else
        [ ]
    );
}
