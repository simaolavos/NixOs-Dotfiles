{ config, ... }:
{
  services.navidrome = {
    enable = true;
    settings = {
      Address = "127.0.0.1";
      Port = 4533;
      MusicFolder = "/data/music";
      AutoImportPlaylists = true;
      # This path is relative to MusicFolder.
      PlaylistsPath = "Playlists";

      # MusicGrabber keeps each track's original MusicBrainz release and date.
      # Group albums by the visible Album Artist + Album tags instead, so a
      # playlist tagged as a Various Artists compilation becomes one album.
      PID.Album = "albumartistid,album";
    };
  };
  services.nginx.virtualHosts."music.sslavos.com" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:4533/";
      proxyWebsockets = true;
    };
  };

  services.cloudflared.tunnels."113fd93b-5514-4d9e-86d2-7eb0c6d7ea9e".ingress."music.sslavos.com" = {
    service = "http://localhost:80";
  };
}
