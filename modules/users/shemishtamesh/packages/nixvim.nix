{
  inputs,
  pkgs,
  config,
  ...
}:

{
  home.packages = with pkgs; [
    (inputs.nixvim.wrappedNvim stdenv.system (
      inputs.nixvim.packages.${system}.nvim.extend {
        colorschemes.base16 = {
          enable = true;

          colorscheme =
            with config.lib.stylix.colors.withHashtag;
            lib.mkForce {
              inherit
                base00
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
      }
    ))
  ];
}
