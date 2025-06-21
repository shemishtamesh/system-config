{
  pkgs,
  astal,
  system,
}:
let
  # system = "x86_64-linux";
  # astal = pkgs.astal;
  nativeBuildInputs = with pkgs; [
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    blueprint-compiler
    dart-sass
    esbuild
  ];

  astalPackages = with astal.packages.${system}; [
    io
    astal4
    battery
    wireplumber
    network
    mpris
    powerprofiles
    tray
    bluetooth
  ];
in
{
  packages.${system}.default = pkgs.stdenv.mkDerivation {
    name = "simple-bar";
    src = ./.;
    inherit nativeBuildInputs;
    buildInputs = astalPackages ++ [ pkgs.gjs ];
  };

  devShells.${system}.default = pkgs.mkShell {
    packages = nativeBuildInputs ++ astalPackages ++ [ pkgs.gjs ];
  };
}
