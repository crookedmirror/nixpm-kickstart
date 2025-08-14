{

  description = "My system configuration";

  inputs = {
    nixpkgs.follows = "chaotic/nixpkgs";
    home-manager.follows = "chaotic/home-manager";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nur.url = "github:nix-community/NUR";

    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "chaotic/nixpkgs";
    };
    spicetify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "chaotic/nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      chaotic,
      home-manager,
      nixgl,
      spicetify,
      nur,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      homeStateVersion = "25.05";
      user = "jarvis";
    in
    {
      homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};

        extraSpecialArgs = {
          inherit
            inputs
            homeStateVersion
            user
            ;
        };
        modules = [
          ./home-manager/home.nix
          chaotic.homeManagerModules.default
          spicetify.homeManagerModules.default
          nur.modules.homeManager.default
        ];
      };
    };

}
