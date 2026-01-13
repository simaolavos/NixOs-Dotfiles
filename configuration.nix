{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
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
	};
	firewall = {
		enable = true;
		allowedUDPPorts = [ 9 ];
	};

	defaultGateway = "193.136.164.222";
	nameservers = [ "1.1.1.1" ];
  };
  documentation = {
	enable = true;
	man.enable = true;
	dev.enable = true;	
  };



  time.timeZone = "Europe/Lisbon";

  i18n.defaultLocale = "en_US.UTF-8";


  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_PT.UTF-8";
    LC_IDENTIFICATION = "pt_PT.UTF-8";
    LC_MEASUREMENT = "pt_PT.UTF-8";
    LC_MONETARY = "pt_PT.UTF-8";
    LC_NAME = "pt_PT.UTF-8";
    LC_NUMERIC = "pt_PT.UTF-8";
    LC_PAPER = "pt_PT.UTF-8";
    LC_TELEPHONE = "pt_PT.UTF-8";
    LC_TIME = "pt_PT.UTF-8";
  };


  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver = {
    enable = true;
    xkb = {
	layout = "pt";
	variant = "";
	options = "caps:swapescape";
    };
  };

  console.keyMap = "pt-latin1";

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  users.users.simaolavos = {
    isNormalUser = true;
    description = "Simão Lavos";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
	openssh.authorizedKeys.keys = [
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINdDq2tDLBbOuSWGX6oT03uciK7u5HouhaE7DkVlFt/J simaolavos@simaolavos-archlinux"
	];
  };


  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim 
    spotify
    wget
    git
    unzip
    gnumake
    gcc
    man-pages
    alacritty
    neovim
    fastfetch
    wakeonlan
    dropbox
    keepass
  ];

  programs.firefox.enable = true;

  hardware.graphics.enable = true;

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia.open = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.openssh =  {
  	enable = true;
	settings.PasswordAuthentication = false;
	settings.KbdInteractiveAuthentication = false;
  };
  

  system.stateVersion = "25.05"; 

}
