{
  # Description of this flake configuration
  description = "xmb03 NixOS + home-manager configuration";

  # Input dependencies - sources this flake depends on
  inputs = {
    # Main Nixpkgs repository (unstable channel for latest packages)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager for user-level package management
    home-manager = {
      url = "github:nix-community/home-manager/master";
      # Use the same nixpkgs as the system (avoids duplication)
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Stylix - automatic theming system that generates colors from wallpaper
    stylix.url = "github:nix-community/stylix";

    # Textfox - Firefox CSS theme for stylish browser appearance
    textfox.url = "github:adriankarlen/textfox";

    # NUR (Nix User Repository) - community package repository
    nur.url = "github:nix-community/NUR";
  };

  # Outputs define what this flake produces (system configurations)
  outputs = { nixpkgs, home-manager, stylix, textfox, nur, ... }@inputs: {
    # Define a NixOS system configuration named "nixos"
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      # System architecture (64-bit Intel/AMD)
      system = "x86_64-linux";
      # Pass all inputs as special arguments for use in submodules
      specialArgs = { inherit inputs; };
      # List of modules that make up the system configuration
      modules = [
        # Main system configuration (packages, services, users)
        ./configuration.nix
        # Stylix NixOS module for system-wide theming
        stylix.nixosModules.stylix
        # Home Manager integration as a NixOS module
        home-manager.nixosModules.home-manager
        {
          # Home Manager specific options
          home-manager = {
            # Use packages from the system nixpkgs (not a separate channel)
            useGlobalPkgs = true;
            # Install user packages system-wide (available to all users)
            useUserPackages = true;
            # Backup existing files with .bak extension before overwriting
            backupFileExtension = "bak";
            # Pass inputs as extra special arguments to home-manager modules
            extraSpecialArgs = { inherit inputs; };

            # Import the user configuration for user "xmb03"
            users.xmb03 = import ./home.nix;
          };
        }
      ];
    };
  };
}
