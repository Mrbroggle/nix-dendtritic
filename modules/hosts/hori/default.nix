{
  inputs,
  config,
  self,
  ...
}: let
  username = "gradyb";
in {
  flake.nixosConfigurations.hori = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.home-manager.nixosModules.home-manager
      config.flake.nixosModules.hostHori
      {_module.args = {inherit username self;};}
    ];
  };
  flake.nixosModules.hostHori = {pkgs, ...}: {
    nixpkgs.config.allowUnfree = true;
    networking.hostName = "hori";
    imports = with config.flake.nixosModules;
      [
        inputs.nixos-hardware.nixosModules.framework-13-7040-amd
        secrets
        base
        secureBootLoader
        tailscale
        networking
        bluetooth
        hyprlandLaptop
        stylix
        appSuite
        chat
        browsers
        display
        keyboard
        audio
        virtualisation
      ]
      ++ [
        {
          home-manager.users.${username}.imports = with config.flake.homeModules; [
            base
            shell
            neovim
          ];
        }
      ];

    system.stateVersion = "25.05";
  };
}
