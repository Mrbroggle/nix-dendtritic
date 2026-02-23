{inputs, ...}: {
  flake.homeModules.neovim = {
    pkgs,
    lib,
    osConfig,
    ...
  }: {
    imports = [inputs.lazyvim.homeManagerModules.default];
    home.packages = with pkgs; [
      neovide
    ];
    programs.lazyvim = {
      enable = true;

      ignoreBuildNotifications = true; # Suppress build-time warnings
      pluginSource = "nixpkgs";
      extras = {
        lang = {
          nix = {
            enable = true;
            installDependencies = true;
            installRuntimeDependencies = true;
          };
          go = {
            enable = true;
            installDependencies = true;
            installRuntimeDependencies = true;
          };
        };
      };
      extraPackages = with pkgs; [
        nixd # Nix LSP
        alejandra # Nix formatter
        nixfmt
        statix
      ];
      plugins = {
        colourscheme = let
          colors = osConfig.lib.stylix.colors.withHashtag;

          themeTrigger = osConfig.stylix.base16Scheme;
          luaColorLines = builtins.concatStringsSep "\n                " (
            lib.mapAttrsToList (name: value: "${name} = '${value}',") (
              lib.filterAttrs (
                name: value: (builtins.match "base0[0-9A-F]" name != null) && (builtins.isString value)
              )
              colors
            )
          );
        in ''
          -- Theme Trigger: ${themeTrigger}
          return {
            { -- Start of plugin spec
              "nvim-mini/mini.base16",
              lazy = false,
              priority = 1000,
              config = function()
                require('mini.base16').setup({
                  palette = {
                    ${luaColorLines}
                  },
                  use_cterm = true,
                })
              end,
            }, -- End of plugin spec
          }
        '';
        alejandra = ''
          return {
            {
              "stevearc/conform.nvim",
              opts = {
                formatters_by_ft = {
                  nix = { "alejandra" },
                },
              },
            },
          }
        '';
      };
    };
  };
}
