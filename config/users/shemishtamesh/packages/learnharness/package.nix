{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  asar,
  autoPatchelfHook,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  glib,
  gtk3,
  libdrm,
  libgbm,
  libxkbcommon,
  nspr,
  nss,
  pango,
  systemd,
  libx11,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  libxcb,
}:
stdenv.mkDerivation {
  pname = "learnharness";
  version = "0.4.1";
  src = fetchurl {
    url = "https://github.com/amosblomqvist/learnharness/releases/download/v0.4.1/LearnHarness-0.4.1-amd64.deb";
    hash = "sha256-/AnnrB+amuJr2K2+wnkT5B4BTiwMX2q7sOIgfMpnHSY=";
  };
  nativeBuildInputs = [
    dpkg
    asar
    autoPatchelfHook
  ];
  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libdrm
    libgbm
    libxkbcommon
    nspr
    nss
    pango
    systemd
    stdenv.cc.cc.lib
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxcb
  ];
  unpackPhase = "dpkg-deb -x $src .";
  installPhase = ''
    mkdir -p $out/lib $out/share
    cp -r opt/LearnHarness $out/lib/learnharness
    cp -r usr/share/icons $out/share/
    cd $out/lib/learnharness/resources
    asar extract app.asar app
    rm app.asar
    # disable the updater
    substituteInPlace app/electron/main.cjs \
      --replace-fail 'function setupAutoUpdater() {' 'function setupAutoUpdater() { return;'
  '';
  meta = {
    description = "AI learning application (internal payload; use the sandboxed launcher)";
    homepage = "https://learnharness.ai";
    license = lib.licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
  };
}
