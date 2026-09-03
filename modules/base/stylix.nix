{
  styles,
  inputs,
  config,
  ...
}: {
  flake.nixosModules.stylix = {
    pkgs,
    username,
    ...
  }: let
    style = styles pkgs;
  in {
    imports = [
      inputs.stylix.nixosModules.stylix
    ];
    stylix = {
      enable = true;
      inherit (style) base16Scheme image;

      polarity = "dark";
      cursor = {
        package = pkgs.apple-cursor;
        name = "macOS";
        size = 24;
      };

      targets.plymouth.enable = false;

      homeManagerIntegration.autoImport = true;
      homeManagerIntegration.followSystem = true;
    };

    home-manager.users.${username}.imports = [
      config.flake.homeModules.stylix
    ];
  };

  flake.homeModules.stylix = {
    pkgs,
    osConfig,
    ...
  }: {
    stylix = {
      enable = true;
      targets = {
        fish.enable = true;
        qt = {
          enable = true;
          platform = "qtct";
        };
        kde.enable = true;
        gtk.enable = true;
        spicetify.enable = true;
        btop.enable = true;
        neovim.enable = false;
        hyprpaper.enable = true;
        hyprland.enable = true;
        waybar.enable = true;
        swaync.enable = true;
        ghostty.enable = true;
        nixcord = {
          enable = true;
          extraCss = ''
            :root {
              --base00: #${osConfig.lib.stylix.colors.base01} !important;
              --base01: #${osConfig.lib.stylix.colors.base00} !important;
            }
          '';
        };
      };
    };

    xdg.configFile."kdeglobals".text = ''
      [General]
      TerminalApplication=ghostty
      [UiSettings]
      ColorScheme=*
    '';
  };
}
