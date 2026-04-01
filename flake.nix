{
  nixConfig = {
    # Completely prevent determinate from building from source
    extra-substituters = [
      "https://install.determinate.systems"
    ];

    extra-trusted-public-keys = [
      "cache.determinate.systems-1:99vU8v06t/48HVsY/uB8GIsV3VskDkHhLFeh9h5vH48="
    ];
  };
  description = "Broggle's Dendritic nix config";

  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    sops-nix.url = "github:Mic92/sops-nix";
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";

    lazyvim.url = "github:pfassina/lazyvim-nix";
    stylix.url = "github:danth/stylix";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nixcord.url = "github:kaylorben/nixcord";
  };
}
