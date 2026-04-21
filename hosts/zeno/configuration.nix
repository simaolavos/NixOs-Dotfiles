{ config, pkgs, ... }:

{
  imports =
    [
      ../../profiles/network/zeno.nix
      ../../profiles/hardware/zeno-hw.nix
      ../../profiles/core.nix
      ./home.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;


  system.stateVersion = "25.05";

}
