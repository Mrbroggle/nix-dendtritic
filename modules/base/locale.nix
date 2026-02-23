{
  flake.nixosModules.base = {pkgs, ...}: {
    services = {
      automatic-timezoned.enable = true;
      localtimed.enable = true;
      geoclue2.geoProviderUrl = "https://api.beacondb.net/v1/geolocate";
    };
    # Select internationalisation properties.
    i18n.defaultLocale = "en_AU.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_AU.UTF-8";
      LC_IDENTIFICATION = "en_AU.UTF-8";
      LC_MEASUREMENT = "en_AU.UTF-8";
      LC_MONETARY = "en_AU.UTF-8";
      LC_NAME = "en_AU.UTF-8";
      LC_NUMERIC = "en_AU.UTF-8";
      LC_PAPER = "en_AU.UTF-8";
      LC_TELEPHONE = "en_AU.UTF-8";
      LC_TIME = "en_AU.UTF-8";
    };

    fonts.packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.hack
      liberation_ttf
    ];
  };
}
