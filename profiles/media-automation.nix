{ config, pkgs, ... }:

{
  users.groups.media = {};

  users.users.jellyfin.extraGroups = [ "media" ];
  users.users.sonarr.extraGroups = [ "media" ];
  users.users.radarr.extraGroups = [ "media" ];
  users.users.transmission.extraGroups = [ "media" ];

  users.users.simaolavos.extraGroups = [ "media" ];

  services.sonarr.enable = true;  
  services.radarr.enable = true;   
  services.prowlarr.enable = true; 
  
  services.transmission = {
    enable = true;
    settings = {
      download-dir = "/data/media/downloads";
      incomplete-dir = "/data/media/incomplete";
      rpc-bind-address = "127.0.0.1";
      rpc-whitelist = "127.0.0.1";
    };
  };

  services.nginx.virtualHosts."sonarr.sslavos.com" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:8989/";
      proxyWebsockets = true;
    };
  };

  services.cloudflared.tunnels."113fd93b-5514-4d9e-86d2-7eb0c6d7ea9e".ingress."sonarr.sslavos.com" = {
    service = "http://localhost:80";
  };
}
