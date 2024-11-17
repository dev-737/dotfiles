local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("lazy").setup({
  checker = { enabled = true },
  change_detection = { notify = true },
  defaults = {
    lazy = true,
  },

  -- color scheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- Ensure it loads first
    config = function()
      local catppuccin = require("catppuccin")
      catppuccin.setup({
        transparent_background = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          telescope = true,
          notify = true,
          noice = true,
          mason = true,
          diffview = true,
        },
      })
      catppuccin.load("macchiato")
    end,
  },
  -- {
  --   "navarasu/onedark.nvim",
  --   name = "onedark",
  --   enabled = false,
  --   config = function()
  --     local onedark = require("onedark")
  --     onedark.setup({ style = "warmer" })
  --     onedark.load()
  --   end,
  -- },
  -- {
  --   "rmehri01/onenord.nvim",
  --   enabled = false,
  --   config = function()
  --     require("onenord").setup()
  --   end,
  -- },
  -- {
  --   "olimorris/onedarkpro.nvim",
  --   enabled = false,
  --   config = function()
  --     vim.cmd("colorscheme onedark")
  --   end,
  -- },
  -- {
  --   "folke/tokyonight.nvim",
  --   enabled = false,
  --   --  -- make sure we load this during startup if it is your main colorscheme
  --   -- priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     -- load the colorscheme here
  --     vim.cmd("colorscheme tokyonight")
  --   end,
  -- },
  -- {
  --   "shaunsingh/nord.nvim",
  --   priority = 1000, -- Ensure it loads first
  --   name = "nord.nvim",
  --   config = function()
  --     vim.cmd("colorscheme nord")
  --   end,
  -- },

  -- typescript language server
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  },

  -- syntax highlight
  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
  },
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    event = "VeryLazy",
    dependencies = {
      -- LSP Support
      { "neovim/nvim-lspconfig" }, -- Required
      {
        "williamboman/mason-lspconfig.nvim",
      }, -- Optional
      {  -- Optional
        "williamboman/mason.nvim",
        build = function()
          pcall(vim.cmd, "MasonUpdate")
        end,
      },
      -- Autocompletion
      { "hrsh7th/nvim-cmp" },         -- Required
      { "hrsh7th/cmp-nvim-lsp" },     -- Required
      { "L3MON4D3/LuaSnip" },         -- Required
      { "hrsh7th/cmp-path" },         -- Optional
      { "saadparwaiz1/cmp_luasnip" }, -- Optional
      { "hrsh7th/cmp-cmdline" },      -- Optional
      { "hrsh7th/cmp-nvim-lua" },     -- Optional
      { "hrsh7th/cmp-buffer" },       -- Optional

      -- Snippets
      { "rafamadriz/friendly-snippets" }, -- Optional
    },
  },
  -- better inline errors
  { "https://git.sr.ht/~whynothugo/lsp_lines.nvim", event = "VeryLazy" },
  -- cool UI for LSP
  {
    "glepnir/lspsaga.nvim",
    event = "VeryLazy",
    branch = "main",
  },
  -- vscode lookin error/warning list
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
    opts = {}, -- for default options, refer to the configuration section for custom setup.

    event = "VeryLazy",
  },
  -- ui for cmd line
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
  -- cool notifications
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
  },
  -- auto closing
  {
    "windwp/nvim-autopairs",
    event = "VeryLazy",
  },
  {
    "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
  },
  -- welcome screen on nvim startup
  {
    "glepnir/dashboard-nvim",
    event = "VimEnter",
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
  },
  -- terminal
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    version = "*",
  },
  -- editor tabs
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  }, -- catppuccin/nvim was a dependency
  -- fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
  },
  { "nvim-telescope/telescope-fzf-native.nvim",     build = "make",    lazy = true },
  -- filetree
  {
    "nvim-tree/nvim-tree.lua",
    event = "VeryLazy",
  },
  -- ui component
  { "MunifTanjim/nui.nvim", lazy = true },
  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
  },
  -- Git
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
  },
  -- formatting and linting
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
    event = "VeryLazy",
  },
  -- toggle comments
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
      require("Comment").setup()
    end,
  },
  -- highlight hex/rgb with colors
  {
    "NvChad/nvim-colorizer.lua",
    event = "VeryLazy",
  },
  -- highlight text occurences in buffer
  {
    "RRethy/vim-illuminate",
    event = "VeryLazy",
  },
  -- lsp progress in bottom
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
  },
  -- Max charecter per line alert tool
  {
    "m4xshen/smartcolumn.nvim",
    opts = {
      colorcolumn = "120",
      disabled_filetypes = { "NvimTree", "lazy", "mason", "help", "text", "markdown", "dashboard" },
    },
    event = "VeryLazy",
  },
  -- uh those things that help you know which scope you're inside
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
      require("ibl").setup()
    end,
    event = "VeryLazy",
  },
  -- the best git project commit diffbar/diffview
  -- vscode like git sidebar, suepr useful
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = "VeryLazy",
  },
  -- vsocde-like top symbols winbar
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    event = "VeryLazy",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
  },
  -- the thing that shows git blame
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
  },
  -- displays keybindings in dashboard
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
  },
  -- matching brace colors
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "VeryLazy",
    config = function()
      require("rainbow-delimiters.setup").setup({
        strategy = {
          -- ...
        },
        query = {
          -- ...
        },
        highlight = {
          -- ...
        },
      })
    end,
  },
  -- github copilot
  {
    "github/copilot.vim",
    event = "VeryLazy",
  },
  -- neovim config completion
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- Library items can be absolute paths
        -- "~/projects/my-awesome-lib",
        -- Or relative, which means they will be resolved as a plugin
        -- "LazyVim",
        -- When relative, you can also provide a path to the library in the plugin dir
        "luvit-meta/library", -- see below
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  {                                        -- optional completion source for require statements and module annotations
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    event = "VeryLazy",
    ft = { "markdown" },
  },
  { "f-person/git-blame.nvim", event = "VeryLazy" },
  { "andweeb/presence.nvim",   event = "VeryLazy" }
})
