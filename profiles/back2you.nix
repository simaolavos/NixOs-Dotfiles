{ ... }:

# Back2You (AMS project site): static site served by the hardened nginx image
# built from the project's Dockerfile. The image is loaded locally, never pulled.

{
  virtualisation.docker.enable = true;
  virtualisation.oci-containers.backend = "docker";

  virtualisation.oci-containers.containers.back2you = {
    image = "back2you-web:latest";
    pull = "never";
    autoStart = true;
    ports = [ "127.0.0.1:3101:8080/tcp" ];
    log-driver = "journald";
    extraOptions = [
      "--cap-drop=ALL"
      "--cpus=0.5"
      "--memory=128m"
      "--pids-limit=64"
      "--read-only"
      "--security-opt=no-new-privileges:true"
      "--tmpfs=/tmp:rw,noexec,nosuid,size=16m"
    ];
  };

  services.nginx.commonHttpConfig = ''
    limit_req_zone $http_cf_connecting_ip zone=back2you:10m rate=20r/s;
  '';

  # security headers (CSP etc.) come from the container's nginx and pass through the proxy
  services.nginx.virtualHosts."back2you.sslavos.com" = {
    extraConfig = ''
      server_tokens off;
    '';
    locations."/" = {
      proxyPass = "http://127.0.0.1:3101/";
      extraConfig = ''
        limit_req zone=back2you burst=40 nodelay;
        limit_req_status 429;
      '';
    };
  };

  services.cloudflared.tunnels."113fd93b-5514-4d9e-86d2-7eb0c6d7ea9e".ingress."back2you.sslavos.com" = {
    service = "http://localhost:80";
  };
}
