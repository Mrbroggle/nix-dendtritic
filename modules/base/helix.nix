{
  flake.homeModules.helix = {
    lib,
    pkgs,
    ...
  }: {
    programs.helix = {
      enable = true;
      extraPackages = with pkgs; [
        svelte-language-server
        nodePackages.typescript-language-server
        nil # or nixd
        nixfmt-rfc-style
        clang-tools
        gopls
        tailwindcss-language-server
      ];

      settings = {
        editor = {
          auto-format = true;
          line-number = "relative";
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          lsp.display-messages = true;
        };
      };

      languages = {
        language = [
          {
            name = "nix";
            formatter = {
              command = "nixfmt";
            };
            language-servers = ["nil"];
          }
          {
            name = "go";
            formatter = {
              command = "goimports";
            };
          }
          {
            name = "svelte";
            language-servers = [
              "svelteserver"
              "tailwindcss-ls"
            ];
          }
          {
            name = "javascript";
            language-servers = [
              "typescript-language-server"
              "tailwindcss-ls"
            ];
          }
        ];

        language-server = {
          tailwindcss-ls = {
            command = "tailwindcss-language-server";
            args = ["--stdio"];
          };
          nil = {
            command = "nil";
            config = {
              nil = {
                nix = {
                  flake = {
                    autoEvalInputs = true;
                    autoArchive = true;
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
