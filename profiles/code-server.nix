
{ config, lib, ... }:

{
  age.secrets.code-pass = {
    file = ../secrets/code-server.age;
    mode = "0400";
  };

  services.code-server = {
    enable   = true;
    host     = "127.0.0.1";
    port     = 4444;
    auth     = "password";
    hashedPassword = "";
  };
  systemd.services.code-server.serviceConfig.EnvironmentFile = config.age.secrets.code-pass.path;


services.cloudflared.tunnels."113fd93b-5514-4d9e-86d2-7eb0c6d7ea9e".ingress."code.sslavos.com" = {
  service = "http://localhost:4444";
};


}
