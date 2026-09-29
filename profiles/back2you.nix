{ config, ... }:


{
  age.secrets.back2you-htpasswd = {
    file = ../secrets/back2you-htpasswd.age;
    mode = "0444";
  };

  virtualisation.docker.enable = true;
  virtualisation.oci-containers.backend = "docker";

  virtualisation.oci-containers.containers.back2you = {
    image = "back2you-web:latest";
    pull = "never";
    autoStart = true;
    ports = [ "127.0.0.1:3101:8080/tcp" ];
    volumes = [ "${config.age.secrets.back2you-htpasswd.path}:/etc/nginx/auth/htpasswd:ro" ];
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

  services.nginx.virtualHosts."back2you.sslavos.com" = {
    extraConfig = ''
      server_tokens off;

      # Cloudflare sets X-Forwarded-Proto: send plain-http visitors to https
      if ($http_x_forwarded_proto = "http") {
        return 301 https://$host$request_uri;
      }

      # browsers remember to use https for this host only (no includeSubDomains/preload)
      add_header Strict-Transport-Security "max-age=31536000" always;
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
