-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'
-- ~/.config/nvim/lua/mappings.lua
-- in your init.lua use: require('mappings')

-- backup, swap and undo
vim.opt.backup = false
vim.opt.swapfile = true
vim.opt.writebackup = false
vim.opt.undofile = false
vim.opt.autoread = true

-- indent
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- search
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.wrapscan = true
vim.opt.smartcase = true

-- sign column
vim.opt.number = true -- Make line numbers default
vim.opt.numberwidth = 4
vim.opt.signcolumn = "yes"

-- display hidden character
vim.opt.list = true
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("lead:⋅")
vim.opt.listchars:append("trail:⋅")
vim.opt.listchars:append("eol:")
vim.opt.listchars:append("tab:▸▸")
vim.opt.fillchars:append("diff: ")
vim.opt.fillchars:append("eob: ")

-- status and tab bar
vim.opt.laststatus = 3
vim.opt.showmode = false
vim.opt.showtabline = 0

-- completion menu
vim.opt.completeopt = { "menu", "menuone", "noselect", "noinsert" }
vim.opt.pumheight = 10

-- misc
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.cursorline = true
vim.opt.foldenable = false
vim.opt.wrap = true
vim.opt.updatetime = 100
vim.opt.shell = "/usr/bin/env bash"
vim.opt.confirm = true
-- vim.opt.termguicolors = true

vim.opt.cmdheight = 0

vim.opt.clipboard = unnamed

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`
-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo historycmap ;\ \(\)<Left><Left>
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.nrformats:append("alpha")

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- [[ Keymaps ]]
--  See `:help vim.keymap.set()`
vim.keymap.set('n', '<Esc>', '<Esc>:noh<CR>')
vim.keymap.set('n', '<Tab>', 'l')
vim.keymap.set('n', '<S-Tab>', 'h')
vim.keymap.set('n', '<M-Tab>', '<cmd>BufferNext<CR>')
vim.keymap.set('n', '<M-S-Tab>', '<cmd>BufferPrev<CR>')
vim.keymap.set('n', '<C-M-t>', ':tabnew<CR>', { desc = 'Open [N]ew Tab' })
vim.keymap.set('n', '<M-T>', ':BufferRestore<CR>', { desc = 'Restore Tab' })
vim.keymap.set('n', '<m-w>', ':bufferclose<cr>', { desc = 'close tab' })

-- Move normally while holding down Alt
-- vim.keymap.set({ 'n', 'i' }, '<M-h>', '<Left>')
-- vim.keymap.set({ 'n', 'i' }, '<M-j>', '<Down>')
-- vim.keymap.set({ 'n', 'i' }, '<M-k>', '<Up>')
-- vim.keymap.set({ 'n', 'i' }, '<M-l>', '<Right>')
-- vim.keymap.set({ 'n', 'i' }, '<M-Esc>', '<Backspace>')


-- Copy, Paste
vim.keymap.set({ 'n', 'v' }, '<C-S-c>', '"+y')
vim.keymap.set({ 'n', 'v' }, '<C-S-v>', '"+p')

-- Regex Shortcuts
-- These mappings save you some keystrokes and put you where you start typing your search pattern. After typing it you move to the replacement part , type it and hit return. The second version adds confirmation flag.
vim.keymap.set({ 'n' }, '<C-;>', ':%s:::g<Left><Left><Left>')

vim.keymap.set('c', ";\\", "\\(\\)<Left><Left>")

-- Allow saving as root when not in root
-- vim.keymap.set('c', 'w!!', ':w ! sudo tee % > /dev/null')

vim.keymap.set('n', '<Space>W', ":let _s=@/<Bar>:%s/\\s\\+$//e<Bar>:let @/=_s<Bar><CR>", { desc = 'Remove All Trailing Whitespace' })
vim.keymap.set('n', '<Space>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Search and Replace the Word Under the Cursor'})

-- Function for removing all trailing whitespace. Will remove §'s in line.  TODO: Fix that
local function remove_whitespace()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  local function remover()
    -- Places a § dummy variable at the cursor,
    -- then removes all spaces before and after,
    -- then removes all §'s on the line.
    -- 'silent!' is there to keep the function from
    -- stopping itself from continuing on to the next
    -- command in case one of them errors.
    vim.cmd('normal ha§')
    vim.cmd('silent! s/\\s\\+§\\s\\+//')
    vim.cmd('silent! s/§\\s\\+//')
    vim.cmd('silent! s/\\s\\+§//')
    vim.cmd('silent! s/\\s§//')
    vim.cmd('silent! s/§\\s//')
    vim.cmd('silent! s/§//g')
  end

  local success, result_or_error = pcall(remover)

  if success then
    local message = string.format("Removed whitespace at %d:%d", line, col)
    print(message)
  else
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    local message = string.format("Removed whitespace at %d:%d", line, col)
    print(message)
  end
  -- local cmd_cursor_alignment = string.format('<cmd>call cursor(%d,%d)<CR>',line, col)
  -- vim.cmd(cmd_cursor_alignment)
  vim.api.nvim_win_set_cursor(0, { line, col })
end

vim.keymap.set('n', '<Space>w', remove_whitespace, { desc = 'Remove [w]hitespace at Cursor' })


local function toggle_relativenumber()
  local relNumState = vim.wo.relativenumber

  if relNumState then
    vim.wo.relativenumber = false
    print('relativenumbers off')
  else
    vim.wo.relativenumber = true
    print('relativenumbers on')
  end
end

vim.keymap.set('n', '<leader>td', '<cmd>LspStop<CR>', { desc = '[T]oggle [D]iagnostics' })

vim.keymap.set('n', '<leader>tn', toggle_relativenumber, { desc = '[T]oggle relativenumbers for [l]ines' })

vim.keymap.set('n', '<leader>n.', 'o{}<Esc>i<CR><Esc>v`(>', { desc = 'Nest indent' })
vim.keymap.set('n', '<leader>n,', toggle_relativenumber, { desc = '[T]oggle relativenumbers for [l]ines' })

-- Diagnostic keymaps
vim.keymap.set('n', '<Space>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Terminal
vim.keymap.set('n', '<leader>`', ':terminal<CR>', { desc = 'Terminal mode' })

-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows


--  See `:help wincmd` for a list of all window commands

-- [[ Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Set Haskell indentation to 2 spaces
vim.api.nvim_create_autocmd("FileType", {
  pattern = "haskell",
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.expandtab = true
  end,
})

-- Set the mapping when Neovim starts
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true, silent = true })
  end
})
-- Set the mapping when Neovim starts
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true, silent = true })
  end
})


-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)


-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --

  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`. This is equivalent to the following Lua:
  --    require('gitsigns').setup({ ... })
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `config` key, the configuration only runs
  -- after the plugin has been loaded:
  --  config = function() ... end


  {                     -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').add {
        { '<leader>c', group = '[C]ode' },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      }
    end,
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  -- LSP Plugins
  { import = 'plugins' },
},
  {
    ui = {
      -- If you are using a Nerd Font: set icons to an empty table which will use the
      -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
      icons = vim.g.have_nerd_font and {} or {
        cmd = '⌘',
        config = '🛠',
        event = '📅',
        ft = '📂',
        init = '⚙',
        keys = '🗝',
        plugin = '🔌',
        runtime = '💻',
        require = '🌙',
        source = '📄',
        start = '🚀',
        task = '📌',
        lazy = '💤 ',
      },
    },
  }
)

-- Ensure 'formatoptions' is set correctly after plugins are loaded
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  command = "set formatoptions=jcql"
})
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
