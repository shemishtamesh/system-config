{ inputs, pkgs, ... }:
{
  imports = [ inputs.voxtype.homeManagerModules.default ];
  services.voxtype = {
    enable = true;

    services.voxtype = {
      enable = true;

      package = inputs.voxtype.packages.${pkgs.stdenv.system}.onnx-cuda;

      settings = {
        engine = "parakeet";
        output = {
          mode = "type";
          fallback_to_clipboard = true;
        };
      };
    };
  };
}
