{ config, pkgs, inputs, ... }:

{
  imports =
    [ 
      ../profiles/hardware/rnl-simaolavos-hw.nix
	  ../profiles/core.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  networking = {
  	hostName = "rnl-simaolavos"; 

  	networkmanager.enable = true;

  	interfaces.enp4s0 = {
		wakeOnLan = {
			enable = true;
			policy = ["magic"];
  		};
		ipv4 = {
			addresses = [{
				address = "193.136.164.195";
				prefixLength = 27;
			}];
		};

		ipv6 = {
			addresses = [{
				address = "2001:690:2100:82::195";
				prefixLength = 64;
			}];
		};

	};
	firewall = {
		enable = true;
		allowedUDPPorts = [ 9 ];
	};

	defaultGateway = "193.136.164.222";
	nameservers = [ "1.1.1.1" ];
  };


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

  hardware.bluetooth.enable = true;

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia.open = false;

  age.secrets.secret1 = {
	file = ./secrets/secret1.age;
    mode = "440";
    group = "wheel";
  };

  system.stateVersion = "25.05"; 

}
