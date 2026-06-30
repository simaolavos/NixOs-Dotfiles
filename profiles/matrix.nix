{ config, pkgs, ... }:
{

  age.secrets.matrix-secrets = {
    file = ../secrets/matrix-secrets.age;
    owner = "matrix-synapse";
    group = "matrix-synapse";
  };

  services.matrix-synapse = {
    enable = true;
    extraConfigFiles = [
      config.age.secrets.matrix-secrets.path
    ];
    settings = {
      server_name = "sslavos.com"; 
      public_baseurl = "https://matrix.sslavos.com/";
      
      listeners = [
        {
          port = 8008;
          bind_addresses = [ "127.0.0.1" ];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [
            {
              names = [ "client" "federation" ];
              compress = false;
            }
          ];
        }
      ];

      enable_registration = false;
    };
  };

  services.nginx.virtualHosts."matrix.sslavos.com" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:8008";
      proxyWebsockets = true;
    };
  };

  services.cloudflared.tunnels."113fd93b-5514-4d9e-86d2-7eb0c6d7ea9e".ingress."matrix.sslavos.com" = {
    service = "http://localhost:80";
  };
}
