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
          with config.lib.stylix.colors.withHashtag;
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
