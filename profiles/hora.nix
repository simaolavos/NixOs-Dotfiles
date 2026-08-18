{ ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.oci-containers.backend = "docker";

  virtualisation.oci-containers.containers.hora = {
    image = "hora-ist:latest";
    pull = "never";
    autoStart = true;
    ports = [ "127.0.0.1:3100:3000/tcp" ];
    environment = {
      NODE_ENV = "production";
      PORT = "3000";
    };
    log-driver = "journald";
    extraOptions = [
      "--cap-drop=ALL"
      "--cpus=1.0"
      "--memory=512m"
      "--pids-limit=256"
      "--read-only"
      "--security-opt=no-new-privileges:true"
      "--tmpfs=/tmp:rw,noexec,nosuid,size=64m"
    ];
  };

  services.nginx.commonHttpConfig = ''
    limit_req_zone $http_cf_connecting_ip zone=hora_api:10m rate=5r/s;
  '';

  services.nginx.virtualHosts."horarios.sslavos.com" = {
    extraConfig = ''
      server_tokens off;
    '';
    locations."/" = {
      proxyPass = "http://127.0.0.1:3100/";
      proxyWebsockets = true;
    };
    locations."~ ^/api/" = {
      proxyPass = "http://127.0.0.1:3100";
      proxyWebsockets = true;
      extraConfig = ''
        limit_req zone=hora_api burst=15 nodelay;
        limit_req_status 429;
      '';
    };
  };

  services.cloudflared.tunnels."113fd93b-5514-4d9e-86d2-7eb0c6d7ea9e".ingress."horarios.sslavos.com" = {
    service = "http://localhost:80";
  };
}
