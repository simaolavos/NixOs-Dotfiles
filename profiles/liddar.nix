{ config, pkgs, ... }:

{
  services.lidarr = {
    enable = true;
    openFirewall = true;
  };

  services.transmission = {
    enable = true;
    openFirewall = true;
    settings = {
      download-dir = "/data/music"; 
      rpc-bind-address = "0.0.0.0"; 
      rpc-whitelist = "127.0.0.1,192.168.1.*"; 
    };
  };

  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };
}
