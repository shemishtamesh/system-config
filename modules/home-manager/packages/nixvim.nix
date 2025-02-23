{
  inputs,
  pkgs,
  config,
  ...
}:

{
  home.packages = with pkgs; [
    (inputs.nixvim.packages.${system}.nvim.extend {
      colorschemes.base16 = {
        enable = true;

        # colorscheme = with config.lib.stylix.colors.withHashtag; {
        colorscheme = lib.mkForce {
          # inherit base00;
          base00 = "#0000ff";
          # base00 = config.lib.stylix.colors.withHashtag.base01;
          base01 = config.lib.stylix.colors.withHashtag.base01;
          base02 = config.lib.stylix.colors.withHashtag.base02;
          base03 = config.lib.stylix.colors.withHashtag.base03;
          base04 = config.lib.stylix.colors.withHashtag.base04;
          base05 = config.lib.stylix.colors.withHashtag.base05;
          base06 = config.lib.stylix.colors.withHashtag.base06;
          base07 = config.lib.stylix.colors.withHashtag.base07;
          base08 = config.lib.stylix.colors.withHashtag.base08;
          base09 = config.lib.stylix.colors.withHashtag.base09;
          base0A = config.lib.stylix.colors.withHashtag.base0A;
          base0B = config.lib.stylix.colors.withHashtag.base0B;
          base0C = config.lib.stylix.colors.withHashtag.base0C;
          base0D = config.lib.stylix.colors.withHashtag.base0D;
          base0E = config.lib.stylix.colors.withHashtag.base0E;
          base0F = config.lib.stylix.colors.withHashtag.base0F;
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
