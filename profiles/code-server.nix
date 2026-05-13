
{ config, lib, ... }:

{
  services.code-server = {
    enable   = true;
    host     = "127.0.0.1";
    port     = 4444;
    auth     = "password";
    hashedPassword = "";
  };


services.cloudflared.tunnels."113fd93b-5514-4d9e-86d2-7eb0c6d7ea9e".ingress."code.sslavos.com" = {
  service = "http://localhost:4444";
};

}
