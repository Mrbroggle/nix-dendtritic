{inputs, ...}: {
  imports = [
    inputs.flake-parts.flakeModules.modules
    inputs.home-manager.flakeModules.home-manager
  ];

  options = {
    flake = inputs.flake-parts.lib.mkSubmoduleOptions {
      wrapperModules = inputs.nixpkgs.lib.mkOption {
        default = {};
      };
    };
  };

  config = {
    transposition.styles.adHoc = true; # allows us to use styles across the nix files
    systems = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
}
