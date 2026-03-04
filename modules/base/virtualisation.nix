{config, ...}: {
  flake.nixosModules.virtualisation = {
    pkgs,
    username,
    ...
  }: {
    programs.virt-manager.enable = true;
    virtualisation = {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
    };
    environment.systemPackages = with pkgs; [
      qemu
    ];
    networking.firewall.trustedInterfaces = ["virbr0"];

    home-manager.users.${username}.imports = [
      config.flake.homeModules.virtualisation
    ];
  };

  flake.homeModules.virtualisation = {
    config,
    pkgs,
    ...
  }: {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };
}
