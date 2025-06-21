{
  pkgs,
  astal,
  host,
}:
let
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

  astalPackages = with astal.packages.${host.system}; [
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
  packages.${host.system}.default = pkgs.stdenv.mkDerivation {
    name = "simple-bar";
    src = ./.;
    inherit nativeBuildInputs;
    buildInputs = astalPackages ++ [ pkgs.gjs ];
  };

  devShells.${host.system}.default = pkgs.mkShell {
    packages = nativeBuildInputs ++ astalPackages ++ [ pkgs.gjs ];
  };
}
