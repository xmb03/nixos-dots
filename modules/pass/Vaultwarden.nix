{ config, pkgs, lib, ... }:

let
  vaultwardenCerts = pkgs.runCommand "vaultwarden-certs" { buildInputs = [ pkgs.openssl ]; } ''
    mkdir -p $out
    openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
      -keyout $out/key.pem -out $out/cert.pem \
      -subj "/CN=localhost" \
      -addext "subjectAltName=DNS:localhost,IP:127.0.0.1"
    chmod 600 $out/key.pem $out/cert.pem
  '';
in
{
  services.vaultwarden = {
    enable = true;

    dbBackend = "sqlite";

    config = {
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      ROCKET_TLS = ''{certs="${vaultwardenCerts}/cert.pem",key="${vaultwardenCerts}/key.pem"}'';
      DOMAIN = "https://localhost:8222";
      WEBSOCKET_ENABLED = true;
      SIGNUPS_ALLOWED = true;
    };

    environmentFile = [ "/var/lib/vaultwarden.env" ];
  };

  security.pki.certificateFiles = [ "${vaultwardenCerts}/cert.pem" ];
}
