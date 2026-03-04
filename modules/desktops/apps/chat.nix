{
  inputs,
  config,
  ...
}: {
  flake.nixosModules.chat = {
    pkgs,
    username,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      altus
    ];
    home-manager.users.${username}.imports = [
      config.flake.homeModules.chat
    ];
  };

  flake.homeModules.chat = {pkgs, ...}: {
    imports = [
      inputs.nixcord.homeModules.nixcord
    ];

    programs.nixcord = {
      enable = true;
      vesktop.enable = true;
    };
  };
}
