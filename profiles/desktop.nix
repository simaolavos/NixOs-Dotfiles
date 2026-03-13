{ config, pkgs, ...}:

{

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  virtualisation.docker.enable = true;

  users.users.simaolavos.extraGroups = [ "docker" ];



  environment.systemPackages = with pkgs; [
    fastfetch
    wakeonlan
    docker
    virt-manager
  ];
}
