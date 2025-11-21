{
  description = "Hyperland on Nixos";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
   noctalia = {
     url = "github:noctalia-dev/noctalia-shell";
     inputs.nixpkgs.follows = "nixpkgs";
   };
  };
  outputs = { nixpkgs, home-manager, noctalia, ... }: {
    nixosConfigurations.hyprland-btw = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.devoid = import ./home.nix;
            backupFileExtension = "backup";
          };
        }
        noctalia.nixosModules.default
      ];
    };
  };
}
