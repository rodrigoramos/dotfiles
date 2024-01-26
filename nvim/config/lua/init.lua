
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
    dotfiles = true,
  },
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


-- -- Treesitter Setup
-- require'nvim-treesitter.configs'.setup {
--   ensure_installed = { "typescript", "javascript" },
--   highlight = {
--     enable = true,
--   },
-- }


