{ config, lib, ... }:

{

  services.gitea = {
    enable = true;

    settings = {
      server = {
        DOMAIN   = "git.sslavos.com";
        ROOT_URL = "https://git.sslavos.com/";

        HTTP_ADDRESS = "127.0.0.1";
        HTTP_PORT    = 3000;

        DISABLE_SSH      = false;
        START_SSH_SERVER = false;
        SSH_PORT         = 22;
      };

      service.REGISTER_EMAIL_CONFIRM = true;

      log = {
        MODE  = "file";
        LEVEL = "warn";
      };
    };
  };

  services.nginx.virtualHosts."git.sslavos.com" = {
    locations."/" = {
      proxyPass    = "http://127.0.0.1:3000/";
      proxyWebsockets = true;
    };
  };

  services.cloudflared.tunnels."113fd93b-5514-4d9e-86d2-7eb0c6d7ea9e".ingress."git.sslavos.com" = {
    service = "http://localhost:80";
  };
}
