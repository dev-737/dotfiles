{
  description = "Niri on Nixos";
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
    sops-nix.url = "github:Mic92/sops-nix";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, noctalia, zen-browser, sops-nix, ... }: { # firefox-nightly
    nixosConfigurations.hyprland-btw = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        ./noctalia.nix
	sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        # {
        #   nixpkgs.overlays = [ firefox-nightly.overlays.default ];
        # }
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.devoid = import ./home.nix;
            extraSpecialArgs = { inherit zen-browser; }; 
            # extraSpecialArgs = { inherit firefox-nightly zen-browser; }; 
            backupFileExtension = "backup";
          };
        }
        # noctalia.nixosModules.default
      ];
    };
  };

  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };
}
