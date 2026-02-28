{
  flake.homeModules.shell = {
    pkgs,
    lib,
    config,
    ...
  }: let
    fishPlugs = [
      "grc"
      "puffer"
      "done"
      "fzf"
      "pisces"
      "fishbang"
    ];
  in {
    home.packages = with pkgs; [
      pay-respects

      grc
    ];
    programs = {
      eza = {
        enable = true;
        icons = "always";
        enableFishIntegration = true;
      };

      fish = {
        enable = true;
        shellInit = ''
          set fish_greeting "Oh god, no more nix please"
        '';
        interactiveShellInit = ''
          ${lib.getExe pkgs.direnv} hook fish | source
          ${lib.getExe pkgs.any-nix-shell} fish --info-right | source
        '';
        plugins =
          lib.map (name: {
            inherit name;
            inherit (builtins.getAttr name pkgs.fishPlugins) src;
          })
          fishPlugs;
        functions = {
          clangComp = "clang++ $argv -g -o $(path basename -E $argv)";
          gccComp = "g++ $argv -g -o $(path basename -E $argv)";
        };
        binds = {
        };

        shellAbbrs = {
          ga = "git add .";
          gc = {
            setCursor = true;
            expansion = "git commit -m \"%\"";
          };
          gp = "git push";
          gf = "git pull";
          gd = "git clone";
          gs = "git status";
          ls = "eza";
          nsp = "nix-shell -p";
          nrn = {
            setCursor = true;
            expansion = "nix run nixpkgs#%";
          };
          nr = "nix run";
        };

        shellAliases = let
          path = "/home/gradyb/etc/nixos/";
          g = "git -C ${path}";
        in {
          vi = "nvim";
          vim = "nvim";
          enc = "nvim /${path} ";
          cnc = "cd /${path}";
          nrs = "cd ${path} && nix fmt -- . && cd - && ${lib.getExe pkgs.nh} os switch ${path} && ${g} add . && ${g} commit -m \"successful build: $(date)\" &&  ${g} diff HEAD^ HEAD --stat";
          nfu = "nix flake update --flake ${path}/";
        };
      };
      starship = with config.lib.stylix.colors.withHashtag; let
        color = {
          # one = base03;
          # two = base04;
          # three = base09;
          # four = base01;
          # five = base05;
          # six = base02;
          # seven = base09;
          # eight = base01;
          one = "#212736";
          two = "#769ff0";
          three = "#a0a9cb";
          four = "#1d2230";
          five = "#a3aed2";
          six = "#394260";
          seven = "#e3e5e5";
          eight = "#090c0c";
        };
      in {
        enable = true;
        enableFishIntegration = true;
        enableTransience = true;
        ## Stolen tokyo night theme from starship.rs
        settings = {
          nodejs = {
            format = "[[ $symbol ($version) ](fg:${color.two} bg:${color.one})]($style)";
            symbol = "";
            style = "bg:${color.one}";
          };
          rust = {
            symbol = "";
            style = "bg:${color.one}";
            format = "[[ $symbol ($version) ](fg:${color.two} bg:${color.one})]($style)";
          };
          nix_shell = {
            symbol = "";
            style = "bg:${color.one}";
            impure_msg = "[impure shell](bold red)";
            format = "[[ $symbol ($version) ](fg:${color.two} bg:${color.one})]($style)";
          };
          time = {
            disabled = false;
            time_format = "%R";
            style = "bg:${color.four}";
            format = "[[  $time ](fg:${color.three} bg:${color.four})]($style)";
          };

          hostname = {
            ssh_only = false;
            style = "bg:${color.five} fg:${color.eight}";
            format = "[$hostname]($style)";
            trim_at = ".";
            disabled = false;
          };
          format = "[░▒▓](${color.five})$hostname[](bg:${color.two} fg:${color.five})$directory[](fg:${color.two} bg:${color.six})$git_branch$git_status[](fg:${color.six} bg:${color.one})$nodejs$rust$nix_shell[](fg:${color.one} bg:${color.four})$time[ ](fg:${color.four})$character";

          directory = {
            style = "fg:${color.seven} bg:${color.two}";
            format = "[ $path ]($style)";
            truncation_length = 3;
            truncation_symbol = "…/";
            substitutions = {
              Music = " ";
              Pictures = " ";
              Documents = "󰈙 ";
              Downloads = " ";
            };
          };
          git_branch = {
            format = "[[ $symbol $branch ](fg:${color.two} bg:${color.six})]($style)";
            symbol = "";
            style = "bg:${color.six}";
          };
          git_status = {
            style = "bg:${color.six}";
            format = "[[($all_status$ahead_behind )](fg:${color.two} bg:${color.six})]($style)";
          };
        };
      };
      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
    };

    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };
}
