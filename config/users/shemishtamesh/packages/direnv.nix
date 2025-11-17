{
  inputs,
  host,
  pkgs,
  ...
}:
let
  stable-pkgs = import inputs.nixpkgs-stable {
    system = host.system;
    config.allowUnfree = true;
  };
in
{
  programs = {
    direnv = {
      enable = true;
      package = if host.system != "aarch64-darwin" then pkgs.direnv else stable-pkgs.direnv;
    };
    zsh.initContent = # sh
      ''
        # ensure compatibility tmux <-> direnv
        if [ -n "$TMUX" ] && [ -n "$DIRENV_DIR" ]; then
            unset -m "DIRENV_*"  # unset env vars starting with DIRENV_
        fi
      '';
  };
}
