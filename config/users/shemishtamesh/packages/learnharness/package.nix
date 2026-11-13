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
  version = "0.6.1";
  src = fetchurl {
    url = "https://github.com/amosblomqvist/learnharness/releases/download/v0.6.1/LearnHarness-0.6.1-amd64.deb";
    hash = "sha256-LIZbewtw8c6p/EBVivA5l2i3uZZFf7b4HWKLLdJCzl0=";
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
      --replace-fail 'function setupAutoUpdater() {' 'function setupAutoUpdater() { return;' \
      --replace-fail 'void win.loadURL(url);' '
        // TODO: Remove this workaround when Electron reliably emits ready-to-show on Wayland.
        // https://github.com/electron/electron/issues/48859
        win.webContents.once("did-finish-load", () => win.show());
        void win.loadURL(url);
      '
  '';
  meta = {
    description = "AI learning application";
    homepage = "https://learnharness.ai";
    license = lib.licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
  };
}
