{ inputs, pkgs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };

    users.simaolavos = { pkgs, ... }: {
      home.stateVersion = "24.11";
      
      imports = [
        ../../home/vim.nix
      ];
    };
  };
}
