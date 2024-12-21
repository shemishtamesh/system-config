{
  pkgs,
  lib,
}:

pkgs.stdenv.mkDerivation rec {
  pname = "cht-sh";
  version = "latest";

  src = pkgs.fetchurl {
    url = "https://cht.sh/:cht.sh";
    sha256 = "sha256-0xNeQrgA/y56rETU3+UA8PTix+sAocIZGw3IsoQx8VU=";
  };

  buildPhase = "true"; # No build step is needed
  buildPhase = "true"; # No build step needed.

  installPhase = ''
    mkdir -p $out/bin
    install -m755 ${src} $out/bin/cht.sh
  '';

  meta = with lib; {
    description = "Cheat Sheet command-line interface";
    homepage = "https://cht.sh/";
    license = licenses.mit; # Assume MIT, adjust if necessary
    maintainers = with maintainers; [ yourname ];
  };
}
