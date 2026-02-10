{ config, pkgs, inputs, ... }:

{
  imports =
    [ 
      ../profiles/hardware/rnl-simaolavos-hw.nix
	  ../profiles/core.nix
      ../profiles/network/rnl-simaolavos.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver = {
    enable = true;
    xkb = {
	layout = "pt";
	variant = "";
	options = "caps:escape";
    };
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.graphics.enable = true;



  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia.open = false;

  age.secrets.secret1 = {
	file = ../secrets/secret1.age;
    mode = "440";
    group = "wheel";
  };

  system.stateVersion = "25.05"; 

}
