{
  flake.homeModules.hyprpaper = {
    pkgs,
    styles,
    ...
  }: {
    services.hyprpaper = let
      inherit (styles pkgs) image;
    in {
      enable = true;
      settings = {
        ipc = "on";
        preload = [
          "${image}"
        ];

        wallpaper = [
          ",${image}"
        ];
      };
    };
  };
}
