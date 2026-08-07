{
  flake.homeModules = {
    hyprlandLua = {
      config,
      lib,
      ...
    }: {
      home.sessionVariables = {
        GDK_SCALE = 2;
      };

      services.kanshi = {
        enable = true;
        systemdTarget = "graphical-session.target";

        settings = [
          {
            profile = {
              name = "Undocked";
              exec = "hyprctl dispatch split:grabroguewindows; notify-send -t 10000 Kanshi 'Swaped to Undocked Config'";
              outputs = [
                {
                  criteria = "eDP-1";
                  scale = 1.875;
                  # scale = 1.0;
                  # mode = "1920x1200@120Hz";
                  status = "enable";
                }
              ];
            };
          }
          {
            profile = {
              name = "Docked";
              exec = "hyprctl dispatch split:grabroguewindows; notify-send -t 10000 Kanshi 'Swaped to Docked Config'";
              outputs = [
                {
                  criteria = "Lenovo Group Limited G24-20 U533B517";
                  position = "0,0";
                  mode = "1920x1080@120.00Hz";
                }
                {
                  criteria = "Acer Technologies KA222Q E3 14300123E3E00";
                  position = "-1080,-200";
                  mode = "1920x1080@60.00Hz";
                  transform = "90";
                }
                {
                  criteria = "eDP-1";
                  status = "disable";
                }
              ];
            };
          }
        ];
      };
    };
    hyprlandLuaDisplays = _: {
      home = {
        sessionVariables.NIXOS_OZONE_WL = "1";
      };
    };
  };
}
