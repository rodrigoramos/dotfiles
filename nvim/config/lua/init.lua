vim.o.termguicolors = true

-- == Packer == --
local status, packer = pcall(require, "packer") 
if (not status) then 
  print("Packer is not installed") 
  return 
end 

vim.cmd [[packadd packer.nvim]]

packer.startup(function(use)
  use 'wbthomason/packer.nvim'

  -- "" File Explorer
  -- " NERD Tree
  -- "Plug 'scrooloose/nerdtree'
  -- "Plug 'ryanoasis/vim-devicons'
  
  ---- My configs Vim Enhancements
  use { 'machakann/vim-highlightedyank' }
  use { 'tpope/vim-commentary' }
  use { 'tpope/vim-surround' }
  use { 'gko/vim-coloresque' } -- Show hexa colors 
  
  -- Colorscheme: Tokyonight
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

  -- StatusLine: Lightline
  use { 'itchyny/lightline.vim' }
  use { 'itchyny/vim-gitbranch' }

  -- File Explorer Tree: Nvim Tree
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional
    },
 }

  -- Auto-completion: Foco no nvim-cmp com LSP
  use { "onsails/lspkind-nvim" }
  use { "rafamadriz/friendly-snippets" }
  use { 'hrsh7th/cmp-vsnip' }
  use { 'hrsh7th/vim-vsnip' }
  use { 'hrsh7th/cmp-nvim-lsp-signature-help' }
  use { 'ray-x/cmp-treesitter' }

  use { "hrsh7th/cmp-nvim-lsp" }
  use { "hrsh7th/cmp-buffer" }
  use { "hrsh7th/nvim-cmp" }

  -- Syntaxe Highlight: Treesitter -- incompatível com nvim 0.9 :( bad Ubuntu
  use { 'nvim-treesitter/nvim-treesitter' }

  -- Fuzzy Finder: Telescope
  use { 'nvim-telescope/telescope.nvim', tag = '0.1.8',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use { 'gbrlsnchs/telescope-lsp-handlers.nvim' }
  use { 'nvim-telescope/telescope-ui-select.nvim' }
  use {
    'filipdutescu/renamer.nvim',
    branch = 'master',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Code formatter: Prettier and null-ls
  use { 'neovim/nvim-lspconfig' }
  use({
      "jose-elias-alvarez/null-ls.nvim",
      config = function()
        local null_ls = require("null-ls")
        null_ls.setup({ 
          debouce = 100,
          sources = {
            null_ls.builtins.diagnostics.eslint_d,
            null_ls.builtins.formatting.eslint_d,
            null_ls.builtins.code_actions.eslint_d,
            null_ls.builtins.code_actions.gitsigns,
            null_ls.builtins.completion.vsnip,
            null_ls.builtins.diagnostics.tsc,
          } 
        })
      end,
      requires = { "nvim-lua/plenary.nvim" },
  })

  use { 'MunifTanjim/prettier.nvim' }

  -- Git Marker: Git Signs
  use { 'lewis6991/gitsigns.nvim' }
  
  -- Git Actions (Blame etc.)
  use { 'dinhhuy258/git.nvim' }
 
  -- Advanced LSP: Mason
  use { 'williamboman/mason.nvim' }
  use { 'williamboman/mason-lspconfig.nvim' }

  use { 'David-Kunz/jester' }
  use { 'rodrigoramos/ngswitcher.vim' }

  -- Debug
  use { 'puremourning/vimspector' }
  use { 'vim-test/vim-test' }


  -- Barra Superior
  --use { 'kyazdani42/nvim-web-devicons' }
  use { 'romgrk/barbar.nvim' }

  use { 'nvim-lua/plenary.nvim' }
  use { 'nvim-lua/popup.nvim' }



  use { 'yioneko/nvim-vtsls' }

  -- use({
  --   'weilbith/nvim-code-action-menu',
  --   cmd = 'CodeActionMenu',
  -- })

  -- use { 'kosayoda/nvim-lightbulb' }

 -------------------------------------------------

  -- use {
  --   "akinsho/horizon.nvim",
  --   tag = "*",
  --   config = function()
  --     vim.cmd([[colorscheme horizon]])
  --   end,
  -- } 

  ---- -- " File Search
  --use { 'junegunn/fzf', rtp = '~/.fzf', run = './install --all' } 
  --use { 'junegunn/fzf.vim' }

  --use { 'Shougo/denite.nvim', run = ':UpdateRemotePlugins' }
  
  ---- " Language Client
  --use { 'elixir-lsp/coc-elixir', run = 'yarn install && yarn prepack' }
  --use { 'neoclide/coc.nvim', branch = 'release' } 

  --use { 'David-Kunz/jester' }
  --use { 'sheerun/vim-polyglot' }

  ---- Tentei usar mas não consegui. Preciso investigar mais
  ---- use {
  ----   "pmizio/typescript-tools.nvim",
  ----   requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  ----   config = function()
  ----     require("typescript-tools").setup {}
  ----   end,
  ---- }

  ---- " Debug
  --use { 'puremourning/vimspector' }
  --use { 'vim-test/vim-test' }

  ---- " Typescript highlighting
  --use { 'leafgarland/typescript-vim' }
  --use { 'mxw/vim-jsx' }
  --use { 'pangloss/vim-javascript' }

  ---- " Barra Superior
  ----use { 'kyazdani42/nvim-web-devicons' }
  --use { 'romgrk/barbar.nvim' }




  ---- " Notes!
  ---- " Plug 'xolox/vim-misc'
  ---- " Plug 'xolox/vim-notes'

  ---- " Table
  ---- " Plug 'dhruvasagar/vim-table-mode'



  ---- use {
  ----  'milanglacier/minuet-ai.nvim'
  ---- }

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


-- == LSP Setup == 

-- local status, nvim_lsp = pcall(require, "lspconfig") 
-- if (not status) then return end 
 
local protocol = require('vim.lsp.protocol') 
 
-- == Auto-Complete: CMP Setup == 
local status, cmp = pcall(require, "cmp") 
if (not status) then return end 
local lspkind = require 'lspkind' 
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end
cmp.setup({ 
  snippet = { 
    expand = function(args) 
      vim.fn["vsnip#anonymous"](args.body) 
    end, 
  }, 
  mapping = cmp.mapping.preset.insert({ 
    ['<C-d>'] = cmp.mapping.scroll_docs(-4), 
    ['<C-f>'] = cmp.mapping.scroll_docs(4), 
    ['<C-Space>'] = cmp.mapping.complete(), 
    ['<C-e>'] = cmp.mapping.close(), 
    ['<CR>'] = cmp.mapping.confirm({ 
      behavior = cmp.ConfirmBehavior.Replace, 
      select = true 
    }), 
    ["<tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
        if #cmp.get_entries() == 1 then
          cmp.confirm({ select = true })
        end
      else
        fallback() -- the fallback function sends a already mapped key. in this case, it's probably `<tab>`.
      end
    end, { "i", "s" }),

    ["<s-tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
  }), 
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  sources = cmp.config.sources({ 
    { name = 'nvim_lsp' }, 
    { name = 'vsnip' },
    { name = 'treesitter' },
    { name = 'nvim_lsp_signature_help' },
  }), 
  formatting = { 
    format = lspkind.cmp_format({ with_text = true, maxwidth = 50 }) 
  } 
}) 
 
require'cmp'.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = '' }
  }, {
    { name = 'buffer' }
  })
})

vim.cmd [[ 
  set completeopt=menuone,noinsert,noselect 
  highlight! default link CmpItemKind CmpItemMenuDefault 
]]


-- == Syntaxe Highlight: Treesitter ==  CAREFUL not supported nvim 0.9 - Bad Ubuntu
local status, ts = pcall(require, "nvim-treesitter.configs") 
if (not status) then return end 
 
ts.setup { 
  highlight = { 
    enable = true, 
    disable = {}, 
  }, 
  indent = { 
    enable = true, 
    disable = {}, 
  }, 
  ensure_installed = { 
    "tsx", 
    "json", 
    "yaml", 
    "css", 
    "html", 
    "lua",
    "typescript",
    "javascript"
  }, 
  autotag = { 
    enable = true, 
  }, 
} 
 
local parser_config = require "nvim-treesitter.parsers".get_parser_configs() 
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }

-- == Fuzzy Finder: Telescope == 
local actions = require "telescope.actions"
local telescope = require('telescope')
local themes = require'telescope.themes'
local a = themes.get_cursor({}),
telescope.setup {
  defaults = {
    mappings = {
     i = {
       ['<C-j>'] = actions.move_selection_next,
       ['<C-k>'] = actions.move_selection_previous,
     }
    },
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_cursor({})
    }
  }
}


telescope.load_extension('lsp_handlers')
telescope.load_extension('ui-select')

require'renamer'.setup()

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

-- == Code Formatter: Prettier == --
local status, prettier = pcall(require, "prettier") 
if (not status) then return end 
 
prettier.setup { 
  bin = 'prettierd', 
  filetypes = { 
    "css", 
    "javascript", 
    "javascriptreact", 
    "typescript", 
    "typescriptreact", 
    "json", 
    "scss", 
    "less" 
  } 
}

-- == Git Marker: Git Signs == --
require('gitsigns').setup {}

-- == Git Actions (Blame etc.): Git.nvim == --
local status, git = pcall(require, "git") 
if (not status) then return end 
 
git.setup({ 
  keymaps = { 
    -- Open blame window 
    blame = "<Leader>gb", 
    -- Open file/folder in git repository 
    browse = "<Leader>go", 
  } 
})

-- == Advanced LSP: Mason == --
local status, mason = pcall(require, "mason") 
if (not status) then return end 
local status2, lspconfig = pcall(require, "mason-lspconfig") 
if (not status2) then return end 
 
mason.setup({}) 
 
lspconfig.setup { 
  automatic_installation = true,
  ensure_installed = { "eslint", "vtsls" }, 
}

-- local nvim_lsp = require "lspconfig" 
-- nvim_lsp.ts_ls.setup {}


-- == LSP Config + Cmp == --
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- require('lspconfig')['ts_ls'].setup {
--   capabilities = capabilities
-- }

require('lspconfig')['eslint'].setup {
  capabilities = capabilities
}

require("lspconfig.configs").vtsls = require("vtsls").lspconfig

require('lspconfig')['vtsls'].setup {
  capabilities = capabilities
}

-- == Barbar Setup == 
require'barbar'.setup {
  highlight_alternate = true
} 

-- Barbar and NvimTree integration
local nvim_tree_events = require('nvim-tree.events')
local bufferline_api = require('bufferline.api')

local function get_tree_size()
  return require'nvim-tree.view'.View.width
end

nvim_tree_events.subscribe('TreeOpen', function()
  bufferline_api.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe('Resize', function()
  bufferline_api.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe('TreeClose', function()
  bufferline_api.set_offset(0)
end)

local lsp_cmds = vim.api.nvim_create_augroup('lsp_cmds', {clear = true})

vim.api.nvim_create_autocmd('LspAttach', {
  group = lsp_cmds,
  desc = 'LSP actions',
  callback = function()
    local bufmap = function(mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, {buffer = true})
    end

    bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
    bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
    bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
    bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
    bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
    bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
    -- bufmap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
    bufmap('n', '<F2>', "<cmd>lua require'renamer'.rename()<cr>")
    bufmap({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>')
    bufmap({'n', 'x'}, '<Leader>ff', '<cmd>lua vim.lsp.buf.format({async = true})<cr>')
    bufmap('n', '<Leader>fa', '<cmd>lua vim.lsp.buf.format({async = true})<cr>')
    bufmap({'n', 'x'}, '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    bufmap('n', '<Leader>rn', "<cmd>lua require'renamer'.rename()<cr>")
    bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
    bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
    bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  end
})



-- require("nvim-lightbulb").setup({
--   autocmd = { enabled = true }
-- })
--
-- nmap <silent> [g <Plug>(coc-diagnostic-prev)
-- nmap <silent> ]g <Plug>(coc-diagnostic-next)

-- " GoTo code navigation
-- nmap <silent> gd <Plug>(coc-definition)
-- nmap <silent> gy <Plug>(coc-type-definition)
-- nmap <silent> gi <Plug>(coc-implementation)
-- nmap <silent> gr <Plug>(coc-references)

-- " Use K to show documentation in preview window
-- nnoremap <silent> K :call ShowDocumentation()<CR>

---------------------------------------------

-- require('minuet').setup {
--     virtualtext = {
--         auto_trigger_ft = {'*'},
--         keymap = {
--             -- accept whole completion
--             accept = '<A-A>',
--             -- accept one line
--             accept_line = '<A-a>',
--             -- accept n lines (prompts for number)
--             accept_n_lines = '<A-z>',
--             -- Cycle to prev completion item, or manually invoke completion
--             prev = '<A-[>',
--             -- Cycle to next completion item, or manually invoke completion
--             next = '<A-]>',
--             dismiss = '<A-e>',
--         },
--     },
--     provider = "gemini",
--     provider_options = {
--         gemini = {
--             model = 'gemini-2.0-flash',
--             system = "see [Prompt] section for the default value",
--             few_shots = "see [Prompt] section for the default value",
--             chat_input = "See [Prompt Section for default value]",
--             stream = true,
--             api_key = '',
--             optional = {},
--         },
--     }
-- }
