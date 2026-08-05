{ pkgs, lib, ... }:

{
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  virtualisation.oci-containers.backend = "docker";

  virtualisation.oci-containers.containers."music-grabber" = {
    image = "g33kphr33k/musicgrabber:latest";
    autoStart = true;

    environment = {
      DB_PATH = "/data/music_grabber.db";
      DEFAULT_CONVERT_TO_FLAC = "true";
      ENABLE_MUSICBRAINZ = "true";
      MUSIC_DIR = "/music";

      "PLAYLISTS_SUBDIR" = "Playlists";
      "PLAYLIST_ALBUM_AS_NAME" = "true";
    };

    volumes = [
      "/home/simaolavos/data:/data:rw"
      "/data/music:/music:rw"
    ];

    ports = [
      "38274:8080/tcp"
    ];

    log-driver = "journald";

    extraOptions = [
      "--network=musicgrabber_default"
      "--network-alias=music-grabber"
      "--shm-size=2g"
    ];
  };

  systemd.services."docker-network-musicgrabber_default" = {
    description = "Create Docker network musicgrabber_default";

    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    before = [ "docker-music-grabber.service" ];

    path = [ pkgs.docker ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop =
        "${pkgs.docker}/bin/docker network rm -f musicgrabber_default";
    };

    script = ''
      docker network inspect musicgrabber_default >/dev/null 2>&1 \
        || docker network create musicgrabber_default
    '';
  };

  systemd.services."docker-music-grabber" = {
    after = [ "docker-network-musicgrabber_default.service" ];
    requires = [ "docker-network-musicgrabber_default.service" ];

    serviceConfig = {
      Restart = lib.mkForce "always";
      RestartSec = "5s";
    };
  };

  networking.firewall.allowedTCPPorts = [ 38274 ];
}
