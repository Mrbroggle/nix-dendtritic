{
  flake.homeModules.hyprpaper = {
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
      };
    };
  };
}
