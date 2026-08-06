{lib, ...}: {
  flake.homeModules.hyprlandLuaDeco = _: {
    programs.hypr-lua.settings.config = lib.mkMerge [
      {
        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 1;
        };
        decoration = {
          rounding = 5;
          blur.enabled = false;
        };
      }
    ];
  };
}
