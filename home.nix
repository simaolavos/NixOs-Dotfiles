 { config, pkgs, ...}:

 {

	home.username = "simaolavos";
	home.homeDirectory = "/home/simaolavos";
	home.stateVersion = "25.05";
	programs.bash = {
		enable = true;
		shellAliases = {
			n = "vim";
		};
	};
 }
