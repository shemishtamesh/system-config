{
  inputs,
  pkgs,
  config,
  ...
}:

{
  home.packages = with pkgs; [
    (inputs.nixvim.packages.${system}.default.extend {
      colorschemes.base16 = {
        enable = true;

        colorscheme =
          # with config.lib.stylix.colors.withHashtag;
          let
            palette = config.lib.stylix.colors.withHashtag;
          in
          lib.mkForce {
            base00 = palette.base11 or palette.base00;
            inherit (palette)
              base01
              base02
              base03
              base04
              base05
              base06
              base07
              base08
              base09
              base0A
              base0B
              base0C
              base0D
              base0E
              base0F
              ;
          };
        settings.telescope_borders = true;
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
          Normal = lib.mkIf cfg.transparentBackground.main transparent;
          NonText = lib.mkIf cfg.transparentBackground.main transparent;
          SignColumn = lib.mkIf cfg.transparentBackground.signColumn transparent;
        };
    })
  ];
}
