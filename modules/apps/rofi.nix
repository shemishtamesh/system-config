{ pkgs, config, ... }:

{
  stylix.targets.rofi.enable = false;
  programs.rofi.enable = true;
  programs.rofi = {
    package = pkgs.rofi-wayland;
    extraConfig = {
      show-icons = true;
      modi = "combi,drun,window,recursivebrowser,calc,char:rofimoji -f emoji*.csv math.csv nerd_font.csv";
      combi-modi = "drun,window,recursivebrowser,char:rofimoji -f emoji*.csv math.csv nerd_font.csv";
      sidebar-mode = true;
    };
    plugins = with pkgs; [ rofi-calc ];
    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        "*" = {
            # font = "Montserrat 9";

            bg0 = mkLiteral "#24242480";
            # bg1 = mkLiteral "#363636";
            # bg2 = mkLiteral "#f5f5f520";
            # bg3 = mkLiteral "#f5f5f540";
            # bg4 = mkLiteral "#0860f2E6";

            # fg0 = mkLiteral "#f5f5f5";
            # fg1 = mkLiteral "#f5f5f580";

            # background-color = mkLiteral "transparent";
            # text-color = mkLiteral "@fg0";
            # padding = mkLiteral "0px";
            # margin = mkLiteral "0px";
        };

        # window {
        #   fullscreen: true;
        #   padding: 1em;
        #   background-color: @bg0;
        # }

        # mainbox {
        #   padding:  8px;
        # }

        # inputbar {
        #   background-color: @bg2;

        #   margin:   0px calc( 50% - 120px );
        #   padding:  2px 4px;
        #   spacing:  4px;

        #   border:         1px;
        #   border-radius:  2px;
        #   border-color:   @bg3;

        #   children: [icon-search,entry];
        # }

        # prompt {
        #   enabled:  false;
        # }

        # icon-search {
        #   expand:   false;
        #   filename: "search";
        #   vertical-align: 0.5;
        # }

        # entry {
        #   placeholder:        "Search";
        #   placeholder-color:  @bg2;
        # }

        # listview {
        #   margin:   48px calc( 50% - 560px );
        #   spacing:  48px;
        #   columns:  6;
        #   fixed-columns: true;
        # }

        # element, element-text, element-icon {
        #   cursor: pointer;
        # }

        # element {
        #   padding:      8px;
        #   spacing:      4px;

        #   orientation:    vertical;
        #   border-radius:  16px;
        # }

        # element selected {
        #   background-color: @bg4;
        # }

        # element-icon {
        #   size: 4em;
        #   horizontal-align: 0.5;
        # }

        # element-text {
        #   horizontal-align: 0.5;
        # }
      };
  };
  nixpkgs.overlays = [
    (final: prev: {
      rofi-calc = prev.rofi-calc.override { rofi-unwrapped = prev.rofi-wayland-unwrapped; };
    })
  ];
}


