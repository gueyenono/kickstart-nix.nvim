# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{inputs}: final: prev:
with final.pkgs.lib; let
  pkgs = final;

  # Use this to create a plugin from a flake input
  mkNvimPlugin = src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  # Fetch plugin from Github
  fromGitHub = rev: ref: repo:
    pkgs.vimUtils.buildVimPlugin {
      pname = "${pkgs.lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = builtins.fetchGit {
        url = "https://github.com/${repo}.git";
        ref = ref;
        rev = rev;
      };
    };

  # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
  # otherwise it could have an incompatible signature when applying this overlay.
  pkgs-wrapNeovim = inputs.nixpkgs.legacyPackages.${pkgs.system};

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix {inherit pkgs-wrapNeovim;};

  # A plugin can either be a package or an attrset, such as
  # { plugin = <plugin>; # the package, e.g. pkgs.vimPlugins.nvim-cmp
  #   config = <config>; # String; a config that will be loaded with the plugin
  #   # Boolean; Whether to automatically load the plugin as a 'start' plugin,
  #   # or as an 'opt' plugin, that can be loaded with `:packadd!`
  #   optional = <true|false>; # Default: false
  #   ...
  # }
  all-plugins = with pkgs.vimPlugins; [
    # Themes and fonts
    kanagawa-nvim

    # Autoformat and linting
    conform-nvim
    nvim-lint

    # Treesitter
    nvim-treesitter.withAllGrammars

    # LSP dependencies
    nvim-lspconfig

    # Quarto and helpers
    quarto-nvim
    otter-nvim
    nabla-nvim
    headlines-nvim
    vim-slime

    # R plugin
    (fromGitHub "ad7035e574677fa9bc339aaf7b38c317ffc0fd3b" "main" "R-nvim/R.nvim")

    # Dependencies
    lspkind-nvim
    plenary-nvim

    # UI
    alpha-nvim
    nvim-web-devicons
    which-key-nvim
    gitsigns-nvim

    # Editing
    comment-nvim # Commenting plugin (./plugins/editing/editing.lua)
    todo-comments-nvim # highlight and search for todo comments like TODO, HACK, BUG in your code base
    indent-blankline-nvim
    nvim-surround # Improved support for surround selection
    eyeliner-nvim # Highlights unique characters for f/F and t/T motions | https://github.com/jinh0/eyeliner.nvim
    vim-illuminate
    indent-blankline-nvim

    # Not sure which category
    mini-nvim # Swiss army knife

    # Telescope
    telescope-nvim
    telescope-fzf-native-nvim
    telescope-ui-select-nvim

    # Completions engines (cmp)
    nvim-autopairs
    luasnip
    cmp-nvim-lsp
    cmp-buffer
    cmp-calc
    cmp-emoji
    cmp-latex-symbols
    cmp-nvim-lsp-signature-help
    cmp-pandoc-references
    cmp-path
    cmp-spell
    cmp-treesitter
    cmp-nvim-lua
    cmp_luasnip
    cmp-cmdline
    cmp-cmdline-history
    (fromGitHub "18b88eeb7e47996623b9aa0a763677ac00a16221" "main" "R-nvim/cmp-r") # cmp-r
  ];

  extraPackages = with pkgs; [
    # Utilities (primarly for R.nvim)
    gcc
    gnumake

    # PDF viewer
    zathura

    # language servers, etc.

    # > Lua
    lua-language-server
    stylua
    luajitPackages.luacheck

    # > Nix
    nil
    alejandra

    # Markdown
    marksman
    vale

    # Javascript
    javascript-typescript-langserver
    prettierd

    # YAML
    yaml-language-server

    # Python
    pyright
    black
    isort

    # Rust
    rust-analyzer

    # JSON/CSS/HTML
    vscode-langservers-extracted

    # Quarto
    quarto

    # Tex distribution
    texliveSmall
  ];
in {
  # This is the neovim derivation
  # returned by the overlay
  nvim-pkg = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
  };

  # This can be symlinked in the devShell's shellHook
  nvim-luarc-json = final.mk-luarc-json {
    plugins = all-plugins;
  };

  # You can add as many derivations as you like.
  # Use `ignoreConfigRegexes` to filter out config
  # files you would not like to include.
  #
  # For example:
  #
  # nvim-pkg-no-telescope = mkNeovim {
  #   plugins = [];
  #   ignoreConfigRegexes = [
  #     "^plugin/telescope.lua"
  #     "^ftplugin/.*.lua"
  #   ];
  #   inherit extraPackages;
  # };
}
