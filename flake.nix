{
  description = "Hyperland on Nixos";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      # url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-nightly = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };
  outputs = { nixpkgs, home-manager, noctalia, firefox-nightly, zen-browser, ... }: {
    nixosConfigurations.hyprland-btw = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix

        {
          nixpkgs.overlays = [ firefox-nightly.overlays.default ];
        }

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.devoid = import ./home.nix;
            extraSpecialArgs = { inherit firefox-nightly zen-browser; }; 
            backupFileExtension = "backup";
          };
        }
        noctalia.nixosModules.default
      ];
    };
  };
}
