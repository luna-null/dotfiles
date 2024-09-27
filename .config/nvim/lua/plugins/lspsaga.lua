return {
  'nvimdev/lspsaga.nvim',
  config = function()
    require('lspsaga').setup({

    })
    vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>')
    vim.keymap.set('n', '<leader>cf', '<cmd>Lspsaga finder<CR>')
    vim.keymap.set('n', 'gp', '<cmd>Lspsaga peek_definition<CR>')
    vim.keymap.set('n', '<leader>co', '<cmd>Lspsaga outline<CR>')
    vim.keymap.set('n', '<leader>q', '<cmd>Lspsaga diagnostic_jump_next<CR>')
    vim.keymap.set('n', '<leader>Q', '<cmd>Lspsaga diagnostic_jump_prev<CR>')
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- optional
    'nvim-tree/nvim-web-devicons',     -- optional
  },
}
