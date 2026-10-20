{
  inputs,
  config,
  self,
  ...
}: let
  username = "gradyb";
in {
  flake.nixosConfigurations.iura = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.home-manager.nixosModules.home-manager
      config.flake.nixosModules.hostIura
      {_module.args = {inherit username self;};}
    ];
  };
  flake.nixosModules.hostIura = {pkgs, ...}: {
    nixpkgs.config.allowUnfree = true;
    networking.hostName = "iura";
    imports = with config.flake.nixosModules;
      [
        inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
        secrets
        base
        systemd-boot
        networking
        bluetooth
        hyprlandLua
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
            helix
          ];
        }
      ];

    system.stateVersion = "25.05";
  };
}
