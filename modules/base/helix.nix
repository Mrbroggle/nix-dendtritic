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
            auto-format = true;
            formatter = {command = "nixfmt";};
          }
          {
            name = "go";
            auto-format = true;
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
        ];

        language-server = {
          tailwindcss-ls = {
            command = "tailwindcss-language-server";
            args = ["--stdio"];
          };
        };
      };
    };
  };
}
