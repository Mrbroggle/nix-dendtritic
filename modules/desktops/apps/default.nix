{
  inputs,
  config,
  ...
}: {
  flake.nixosModules.appSuite = {
    pkgs,
    username,
    ...
  }: {
    imports = [
      inputs.spicetify-nix.nixosModules.default
    ];
    environment.systemPackages = with pkgs; [
      mpv
      celluloid
      gnome-network-displays
      gparted
      kdePackages.okular
      obsidian
      qbittorrent
      networkmanagerapplet
      ghidra
    ];

    services = {
      udisks2.enable = true;
      smartd.enable = true;
      gvfs.enable = true;
    };

    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
      };
      gamescope = {
        enable = true;
        capSysNice = true;
      };
      spicetify = let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
      in {
        enable = true;
        enabledExtensions = with spicePkgs.extensions; [
          adblock
          hidePodcasts
          shuffle
        ];
        enabledCustomApps = with spicePkgs.apps; [
          newReleases
          ncsVisualizer
        ];
        enabledSnippets = with spicePkgs.snippets; [
          pointer
        ];
      };
    };

    home-manager.users.${username}.imports = [
      config.flake.homeModules.appSuite
    ];
  };

  flake.homeModules.appSuite = {
    config,
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [prismlauncher];
    programs = {
      ghostty = {
        enable = true;
        enableFishIntegration = true;
        settings = {
          font-family = "FiraCode Nerd Font Bold";
          confirm-close-surface = false;
        };
      };
    };
  };
}
