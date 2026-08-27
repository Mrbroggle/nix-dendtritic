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
        typescript-language-server
        tailwindcss-language-server

        nil
        nixfmt
        alejandra

        clang-tools
        lldb_18

        gopls

        ols

        rust-analyzer
        clippy
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
            formatter = {
              command = "alejandra";
            };
            language-servers = ["nil"];
          }
          {
            name = "rust";
            auto-format = true;
            formatter = {
              command = "clippy";
            };
            language-servers = ["rust-analyzer"];
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
          {
            name = "cpp";
            formatter = {
              command = "clang-format";
              args = [
                "--style={BasedOnStyle: LLVM, IndentWidth: 8, TabWidth: 8, UseTab: Never}"
                "--assume-filename=%{buffer_name}"
              ];
            };
            auto-format = true;
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
          {
            name = "c";
            formatter = {
              command = "clang-format";
              args = [
                "--style={BasedOnStyle: LLVM, IndentWidth: 8, TabWidth: 8, UseTab: Never}"
                "--assume-filename=%{buffer_name}"
              ];
            };
            auto-format = true;
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
            args = [
              "--background-index"
              "--clang-tidy"
            ];
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
