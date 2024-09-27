return {
  'nvimdev/lspsaga.nvim',
  config = function()
    require('lspsaga').setup ({

    })
    vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>')
    vim.keymap.set('n', '<Space>f', '<cmd>Lspsaga finder<CR>')
    vim.keymap.set('n', 'gp', '<cmd>Lspsaga peek_definition<CR>')
    vim.keymap.set('n', '<Space>r', '<cmd>Lspsaga rename<CR>')
    vim.keymap.set('n', '<Space>o', '<cmd>Lspsaga outline<CR>')
    vim.keymap.set('n', '<leader>q', '<cmd>Lspsaga diagnostic_jump_next<CR>')
    vim.keymap.set('n', '<leader>Q', '<cmd>Lspsaga diagnostic_jump_prev<CR>')
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- optional
    'nvim-tree/nvim-web-devicons', -- optional
  },
}
