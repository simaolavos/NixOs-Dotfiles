{ config, pkgs, ... }:

{
  users.groups.media = {};

  users.users.jellyfin.extraGroups = [ "media" ];
  users.users.sonarr.extraGroups = [ "media" ];
  users.users.radarr.extraGroups = [ "media" ];
  users.users.qbittorrent.extraGroups = [ "media" ];

  users.users.simaolavos.extraGroups = [ "media" ];

  services.sonarr.enable = true;
  services.radarr.enable = true;
  services.prowlarr.enable = true; 

  services.qbittorrent = {
    enable = true;
  };
  systemd.services.qbittorrent.serviceConfig.UMask = "0002";

  services.jellyseerr = {
    enable = true;
  };

  networking.firewall.allowedTCPPorts = [
    8989 # Sonarr
    7878 # Radarr
    9696 # Prowlarr
    8080 # qBittorrent WebUI
    5055
  ];

  services.nginx.virtualHosts."requests.sslavos.com" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:5055/";
      proxyWebsockets = true;
    };
  };

  services.cloudflared.tunnels."113fd93b-5514-4d9e-86d2-7eb0c6d7ea9e".ingress."requests.sslavos.com" = {
    service = "http://localhost:80";
  };

  virtualisation.oci-containers.containers."flaresolverr" = {
    image = "ghcr.io/flaresolverr/flaresolverr:latest";
    ports = [ "8191:8191" ];
    environment = {
      LOG_LEVEL = "info";
    };
  };
}
