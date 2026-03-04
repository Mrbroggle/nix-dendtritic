{
  flake.nixosModules = {
    tailscale = _: {
      services.tailscale = {
        enable = true;
        useRoutingFeatures = "both";
      };
    };
    networking = {pkgs, ...}: {
      networking = {
        # wireless.iwd.enable = true;
        networkmanager.enable = true;
        # nftables.enable = true;
        # firewall = {
        #   enable = true;
        # };
      };
      environment.systemPackages = with pkgs; [
        protonvpn-gui
      ];
      # networking.networkmanager.wifi.backend = "iwd";

      # dnsmasq.enable = true;
      # environment.systemPackages = with pkgs; [
      #   nftables
      #   dnsmasq
      # ];
    };
  };
}
