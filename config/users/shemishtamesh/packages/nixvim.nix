{
  inputs,
  pkgs,
  host,
  config,
  ...
}:
let
  nixvim_package = inputs.nixvim.packages.${host.system}.default.extend {
    colorschemes.base16.colorscheme =
      let
        palette = config.lib.stylix.colors.withHashtag;
      in
      pkgs.lib.mkForce {
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
    highlight =
      let
        cfg = config.stylix.targets.nixvim;
        transparent = {
          bg = "none";
          ctermbg = "none";
        };
      in
      with pkgs.lib;
      {
        Normal = mkIf cfg.transparentBackground.main transparent;
        NonText = mkIf cfg.transparentBackground.main transparent;
        SignColumn = mkIf cfg.transparentBackground.signColumn transparent;
      };
  };
  nvim_with_env_vars = pkgs.symlinkJoin {
    name = "nvim-with-env-vars";
    paths = [ nixvim_package ];
    postBuild = ''
      rm -f $out/bin/nvim
      cat > $out/bin/nvim <<EOF
      #!${pkgs.runtimeShell}
      export HOSTNAME="\$(hostname)"
      export OPENROUTER_API_KEY="\$(cat ${config.sops.secrets.openrouter_general_api_key.path})"
      exec ${pkgs.lib.getExe nixvim_package} "\$@"
      EOF
      chmod +x $out/bin/nvim
    '';
  };
in
{
  home = {
    packages = [
      nvim_with_env_vars
      pkgs.teamtype
    ];
    sessionVariables = {
      MANROFFOPT = "-c";
      MANWIDTH = "999";
      MANPAGER = "nvim +Man!";
      EDITOR = "nvim";
    };
  };
  sops.secrets.openrouter_general_api_key = { };
}
