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
    adminUser = "admin";
    adminPassFile = config.age.secrets.couchdb-secret.path;
  };

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
