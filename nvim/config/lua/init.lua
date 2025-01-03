vim.o.termguicolors = true

-- == Packer == --
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- "" File Explorer
  -- " NERD Tree
  -- "Plug 'scrooloose/nerdtree'
  -- "Plug 'ryanoasis/vim-devicons'
  
  -- " Nvim Tree
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional
    },
 }

 use {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("tokyonight").setup({
        style = "storm",
        transparent = true,
        styles = {
          sidebars = "transparent",
          floats = "transparent"
        }
      })
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
    end,
  }

  -- use {
  --   "akinsho/horizon.nvim",
  --   tag = "*",
  --   config = function()
  --     vim.cmd([[colorscheme horizon]])
  --   end,
  -- } 

  -- -- " File Search
  use { 'junegunn/fzf', rtp = '~/.fzf', run = './install --all' } 
  use { 'junegunn/fzf.vim' }

  use { 'Shougo/denite.nvim', run = ':UpdateRemotePlugins' }
  
  -- " Language Client
  use { 'elixir-lsp/coc-elixir', run = 'yarn install && yarn prepack' }
  use { 'neoclide/coc.nvim', branch = 'release' } 
  use { 'nvim-treesitter/nvim-treesitter' }

  use { 'David-Kunz/jester' }
  use { 'sheerun/vim-polyglot' }

  -- Tentei usar mas não consegui. Preciso investigar mais
  -- use {
  --   "pmizio/typescript-tools.nvim",
  --   requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  --   config = function()
  --     require("typescript-tools").setup {}
  --   end,
  -- }

  -- " Debug
  use { 'puremourning/vimspector' }
  use { 'vim-test/vim-test' }

  -- " Typescript highlighting
  use { 'leafgarland/typescript-vim' }
  use { 'mxw/vim-jsx' }
  use { 'pangloss/vim-javascript' }

  -- " Barra Superior
  --use { 'kyazdani42/nvim-web-devicons' }
  use { 'romgrk/barbar.nvim' }


  -- " Plugins Angular
  -- " Plug 'softoika/ngswitcher.vim'
  -- " Plug '~/git/fork/ngswitcher.vim'
  use { 'rodrigoramos/ngswitcher.vim' }

  -- " Vim Enhancements
  use { 'machakann/vim-highlightedyank' }
  use { 'tpope/vim-commentary' }
  use { 'tpope/vim-surround' }
  use { 'gko/vim-coloresque' } -- Show hexa colors 

  -- " Notes!
  -- " Plug 'xolox/vim-misc'
  -- " Plug 'xolox/vim-notes'

  -- " Table
  -- " Plug 'dhruvasagar/vim-table-mode'

  -- " Linha de rodapé
  use { 'itchyny/lightline.vim' }
  use { 'itchyny/vim-gitbranch' }

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

end)

-- == NvimTree Setup == 

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 50,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
    custom = { "^.git$", "^node_modules" } 
  },
  actions = {
    open_file = {
      quit_on_open = true
    }
  }
})

-- -- == Barbar Setup == 
-- require'barbar'.setup {
--   highlight_alternate = true
-- } 

-- -- Barbar and NvimTree integration
-- local nvim_tree_events = require('nvim-tree.events')
-- local bufferline_api = require('bufferline.api')

-- local function get_tree_size()
--   return require'nvim-tree.view'.View.width
-- end

-- nvim_tree_events.subscribe('TreeOpen', function()
--   bufferline_api.set_offset(get_tree_size())
-- end)

-- nvim_tree_events.subscribe('Resize', function()
--   bufferline_api.set_offset(get_tree_size())
-- end)

-- nvim_tree_events.subscribe('TreeClose', function()
--   bufferline_api.set_offset(0)
-- end)


-- Treesitter Setup
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
}

local actions = require "telescope.actions"
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
      }
    }
  }
}


local previewers = require('telescope.previewers')
local builtin = require('telescope.builtin')
local conf = require('telescope.config')

local delta = previewers.new_termopen_previewer {
  get_command = function(entry)
    -- note we can't use pipes
    -- this command is for git_commits and git_bcommits
    return { 'git', '-c', 'core.pager=delta', '-c', 'delta.side-by-side=false', 'diff', entry.value .. '^!' }

    -- this is for status
    -- You can get the AM things in entry.status. So we are displaying file if entry.status == '??' or 'A '
    -- just do an if and return a different command
    -- return { 'git', '-c', 'core.pager=delta', '-c', 'delta.side-by-side=false', 'diff', entry.value }
  end
}


git_commits_delta = function(opts)
  opts = opts or {}
  opts.previewer = delta

  builtin.git_commits(opts)
end

git_bcommits_delta = function(opts)
  opts = opts or {}
  opts.previewer = delta

  builtin.git_bcommits(opts)
end
