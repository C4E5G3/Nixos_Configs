{
  description = "flake for marcus_N1 with Home Manager enabled";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{
    self,
    nixpkgs,
    home-manager,
    ...
  }: {
    nixosConfigurations = {
      marcus_N1 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.marcus = { pkgs, ... }: {
              home.username = "marcus";
              home.homeDirectory = "/home/marcus";
              programs.home-manager.enable = true;
              home.packages = with pkgs; [
                mailspring
                keepassxc
              ];
              home.stateVersion = "23.05";
            };
          }
        ];
      };
    };
  };
}
