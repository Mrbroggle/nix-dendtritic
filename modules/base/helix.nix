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
        nil
        nixfmt-rfc-style

        clang-tools
        lldb_18

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
          rulers = [80];
          lsp.display-messages = true;
        };
      };

      languages = {
        language = [
          {
            name = "nix";
            formatter = {command = "nixfmt";};
            language-servers = ["nil"];
          }
          {
            name = "go";
            formatter = {command = "goimports";};
          }
          {
            name = "svelte";
            language-servers = ["svelteserver" "tailwindcss-ls"];
          }
          {
            name = "javascript";
            language-servers = ["typescript-language-server" "tailwindcss-ls"];
          }
          {
            name = "cpp";
            formatter = {
              command = "clang-format";
              args = ["-style=llvm"];
            };
            language-servers = ["clangd"];
            debugger = {
              name = "lldb-dap";
              transport = "stdio";
              command = "lldb-dap";
              templates = [
                {
                  name = "binary";
                  request = "launch";
                  completion = [
                    {
                      name = "binary";
                      completion = "filename";
                    }
                  ];
                  args = {
                    program = "{0}";
                  };
                }
              ];
            };
          }
        ];

        language-server = {
          clangd = {
            command = "clangd";
            args = ["--background-index" "--clang-tidy"];
          };

          tailwindcss-ls = {
            command = "tailwindcss-language-server";
            args = ["--stdio"];
          };

          nil = {
            command = "nil";
            config.nil.nix.flake = {
              autoEvalInputs = true;
              autoArchive = true;
            };
          };
        };
      };
    };
  };
}
