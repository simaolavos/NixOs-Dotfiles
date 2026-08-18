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
  };

  services.nginx.virtualHosts."horarios.sslavos.com" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:3100/";
      proxyWebsockets = true;
    };
  };

  services.cloudflared.tunnels."113fd93b-5514-4d9e-86d2-7eb0c6d7ea9e".ingress."horarios.sslavos.com" = {
    service = "http://localhost:80";
  };
}
