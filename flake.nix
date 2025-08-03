{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tsnsrv = {
      url = "github:boinkor-net/tsnsrv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixarr = {
      url = "github:rasmus-kirk/nixarr/dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    agenix,
    quadlet-nix,
    ...
  } @ inputs: let
    forAllSystems = f:
      nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system: f nixpkgs.legacyPackages.${system});
  in {
    overlays = import ./overlays {inherit inputs;};
    packages = forAllSystems (pkgs: import ./pkgs {inherit pkgs;});
    nixosConfigurations = {
      zeus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [./hosts/zeus];
      };
      anton = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [./hosts/anton];
      };
    };
  };
}
