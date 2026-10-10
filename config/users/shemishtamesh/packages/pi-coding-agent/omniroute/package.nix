{ pkgs, lib, ... }:

pkgs.buildNpmPackage {
  pname = "omniroute";
  version = "3.8.51";

  src = pkgs.fetchurl {
    url = "https://registry.npmjs.org/omniroute/-/omniroute-3.8.51.tgz";
    sha256 = "sha256-QhaZ/do0vYW88DUlfojjWe3AM8AbhdVLakkhwc2k0u8=";
  };

  dontBuild = true;

  meta = {
    description = "unified ai router with auto fallback";
    homepage = "https://www.omniroute.online/";
    license = lib.licenses.mit;
    platforms = pkgs.lib.platforms.linux;
  };
}
