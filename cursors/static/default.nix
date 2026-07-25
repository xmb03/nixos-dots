{ stdenv }:
stdenv.mkDerivation {
  pname = "static-cursor";
  version = "1.0";
  src = ./.;
  installPhase = ''
    mkdir -p $out/share/icons/static
    cp -r $src/cursors $out/share/icons/static/cursors
    cp $src/index.theme $out/share/icons/static/index.theme
  '';
}
