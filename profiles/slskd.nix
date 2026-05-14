{ config, pkgs, ... }:

{

  age.secrets.slskd-secrets = {
    file = ../secrets/slskd-secrets.age;
    owner = "slskd";
    group = "slskd";
  };

  services.slskd = {
    enable = true;

    domain = "localhost";
    openFirewall = true; 

    environmentFile = config.age.secrets.slskd-secrets.path;

    
    settings = {
      directories = {
        downloads = "/data/music/soulseek/downloads";
        incomplete = "/data/music/soulseek/incomplete";
      };

      shares = {
        directories = [ "/data/music" ];
      };

      web = {
        address = "0.0.0.0";
        port = 5080;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 5080 5081 2234 ];
}
