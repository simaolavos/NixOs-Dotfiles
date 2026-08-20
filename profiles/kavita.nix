{ config, ... }:

{
  age.secrets.kavita-token = {
    file = ../secrets/kavita-token.age;
    owner = "kavita";
    group = "kavita";
    mode = "0400";
  };

  services.kavita = {
    enable = true;
    tokenKeyFile = config.age.secrets.kavita-token.path;
    settings = {
      IpAddresses = "127.0.0.1";
      Port = 5000;
    };
  };

  # Kavita scans this directory for EPUBs, PDFs, comics, and manga.
  systemd.tmpfiles.rules = [
    "d /data/books 2775 kavita kavita - -"
  ];

  users.users.simaolavos.extraGroups = [ "kavita" ];

  services.nginx.virtualHosts."books.sslavos.com" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:5000/";
      proxyWebsockets = true;
    };
  };

  services.cloudflared.tunnels."113fd93b-5514-4d9e-86d2-7eb0c6d7ea9e".ingress."books.sslavos.com" = {
    service = "http://localhost:80";
  };
}
