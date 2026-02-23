{
  inputs,
  config,
  self,
  ...
}: {
  flake.nixosConfigurations.hori = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.home-manager.nixosModules.home-manager
      config.flake.nixosModules.hostHori
      {_module.args = {inherit self;};}
    ];
  };
  flake.nixosModules.hostHori = {pkgs, ...}: {
    nixpkgs.config.allowUnfree = true;
    networking.hostName = "hori";
    imports = with config.flake.nixosModules;
      [
        inputs.nixos-hardware.nixosModules.framework-13-7040-amd
        base
        secureBootLoader
        tailscale
        networking
        bluetooth
        hyprlandLaptop
        stylix
        appSuite
        browsers
        display
        keyboard
      ]
      ++ [
        {
          home-manager.users.gradyb.imports = with config.flake.homeModules; [
            base
            stylix
            shell
            neovim
            appSuite
          ];
        }
      ];

    system.stateVersion = "25.05";
  };
}
