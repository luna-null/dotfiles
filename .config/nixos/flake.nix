{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell.url = "github:numtide/devshell";
    
    # Home manager
    # home-manager = {
    #   url = "github:nix-community/home-manager/release-24.05";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # Nvimdots
    # nvimdots.url = "github:ayamir/nvimdots";
    
    # nixGL
    nixgl.url = "github:nix-community/nixGL";

    # nixvim = {
    #   url = "github:nix-community/nixvim";
    #   # If using a stable channel you can use `url = "github:nix-community/nixvim/nixos-<version>"`
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    # lix-module = {
    #   url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = {
    self,
    nixpkgs,
    # nixpkgs-stable,
    home-manager,
    flake-utils,
    flake-parts,
    devshell,
    nixgl,
    spicetify-nix,
    # lix-module,
    ...
  } @ inputs: 
  let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
    overlays = [ nixgl.overlay ];
  in {
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./system-modules;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      f = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          # > Our main nixos configuration file <
          ./configuration.nix
        ];
      };
    };

   # # Standalone home-manager configuration entrypoint
   # # Available through 'home-manager --flake .#your-username@your-hostname'
   #  homeConfigurations = {
   #    "le@f" = home-manager.lib.homeManagerConfiguration {
   #      pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
   #      extraSpecialArgs = {inherit inputs outputs spicetify-nix;};
   #      modules = [
   #        # > Our main home-manager configuration file <
   #        ./home-manager/home.nix
   #        ./home-manager/modules/spicetify-nix
   #      ];
   #    };
   # };
  };
}
