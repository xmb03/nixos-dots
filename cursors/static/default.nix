{ stdenv }:
stdenv.mkDerivation {
  pname = "static-cursor";
  version = "1.0";
  src = ./.;
  installPhase = ''
    mkdir -p $out/share/icons/static
    cp -r $src/* $out/share/icons/static/
  '';
}
