{ config, lib, pkgs, ... }:

{
  age.secrets.couchdb-secret = {
    file = ../secrets/couchdb-secrets.age;
    owner = "couchdb";
    group = "couchdb";
  };

  services.couchdb = {
    enable = true;
    port = 5984;
    bindAddress = "127.0.0.1";
  };

  systemd.services.couchdb.preStart = ''
    if ! grep -q "\[admins\]" /var/lib/couchdb/local.ini 2>/dev/null; then
      echo "[admins]" >> /var/lib/couchdb/local.ini
      echo "admin = $(cat ${config.age.secrets.couchdb-secret.path})" >> /var/lib/couchdb/local.ini
      chmod 600 /var/lib/couchdb/local.ini
    fi
  '';

  services.nginx.virtualHosts."sync.sslavos.com" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:5984/";
      proxyWebsockets = true;
    };
  };

  # Expor pelo Cloudflare Tunnel
  services.cloudflared.tunnels."113fd93b-5514-4d9e-86d2-7eb0c6d7ea9e".ingress."sync.sslavos.com" = {
    service = "http://localhost:80";
  };
}
