{ config, pkgs, ... }:

{
  imports =
    [ 
      ../profiles/hardware/rnl-simaolavos-hw.nix
	  ../profiles/core.nix
      ../profiles/network/rnl-simaolavos.nix
      ../profiles/home.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  age.secrets.secret1 = {
	file = ../secrets/secret1.age;
    mode = "440";
    group = "wheel";
  };

  system.stateVersion = "25.05"; 

}
