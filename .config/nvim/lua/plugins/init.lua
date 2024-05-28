return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
    lazy=false,
  },

  {
    "git@gitlab.com:gitlab-org/editor-extensions/gitlab.vim.git",
    event = { "BufReadPre", "BufNewFile" }, -- Activate when a file is created/opened
    ft = { "go", "javascript", "python", "ruby" }, -- Activate when a supported filetype is open
    cond = function()
      return vim.env.GITLAB_TOKEN ~= nil and vim.env.GITLAB_TOKEN ~= "" -- Only activate if token is present in environment variable (remove to use interactive workflow)
    end,
    opts = {
      statusline = {
        enabled = true, -- Hook into the builtin statusline to indicate the status of the GitLab Duo Code Suggestions integration
      },
    },
    lazy=false,
  },
  {
    "ray-x/go.nvim",
    lazy=false,
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
  {
    "fatih/vim-go",
    config = function()
      require("go").setup()
    end,
    lazy=false,
    enabled=true,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
    lazy=false,
  },
  
  {
  	"williamboman/mason.nvim",
  	opts = {
  		ensure_installed = {
  			"lua-language-server", "stylua",
  			"html-lsp", "css-lsp" , "prettier"
  		},
  	},
    lazy=false,
  },
  
  {
  	"nvim-treesitter/nvim-treesitter",
  	opts = {
  		ensure_installed = {
  			"vim", "lua", "vimdoc",
       "html", "css", "go"
  		},
  	},
    lazy=false,
  },
}
