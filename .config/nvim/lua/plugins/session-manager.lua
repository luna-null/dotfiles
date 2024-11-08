return
{
  'Shatur/neovim-session-manager',
  keys = {
    {
      '<Space>zs',
      '<cmd>SessionManager save_current_session<cr>',
      desc = '[S]ave Current Session',
    },
    {
      '<Space>zl',
      '<cmd>SessionManager load_session<cr>',
      desc = '[L]oad session',
    },
    {
      '<Space>zz',
      '<cmd>SessionManager available_commands<cr>',
      desc = 'Session Manager Command[z]',
    },
    {
      '<Space>zo',
      '<cmd>SessionManager load_last_session<cr>',
      desc = '[O]pen Last Session',
    },
    {
      '<Space>zd',
      '<cmd>SessionManager load_current_dir_session<cr>',
      desc = 'Load Current [D]ir Session',
    },


  }
}
