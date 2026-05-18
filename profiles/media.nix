{ config, pkgs, ... }:

{
  services.jellyfin = {
    enable = true;
  };
  networking.firewall.allowedTCPPorts = [ 8096 ];

  services.nginx.virtualHosts."media.sslavos.com" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:8096/"; 
      proxyWebsockets = true;
    };
  };

  services.cloudflared.tunnels."113fd93b-5514-4d9e-86d2-7eb0c6d7ea9e".ingress."media.sslavos.com" = {
    service = "http://localhost:80";
  };
}
