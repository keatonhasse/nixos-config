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
    # alejandra = {
    #   url = "github:kamadorueda/alejandra/4.0.0";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    agenix,
    quadlet-nix,
    # alejandra,
    ...
  } @ inputs: let
    # systems = [
    # "x86_64-linux"
    # "aarch64-darwin"
    # ];
    # forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    forAllSystems = f:
      nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system: f nixpkgs.legacyPackages.${system});
  in {
    overlays = import ./overlays {inherit inputs;};
    packages = forAllSystems (pkgs: import ./pkgs {inherit pkgs;});
    # devShells = forAllSystems (pkgs: import ./shell.nix {inherit pkgs;});
    # formatter = forAllSystems (pkgs: pkgs.alejandra);
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
