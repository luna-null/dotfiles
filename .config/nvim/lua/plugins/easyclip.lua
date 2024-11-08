return {
  'svermeulen/vim-easyclip',
  dependencies = {
    'tpope/vim-repeat',
  },
  lazy = false,
  keys = {
    {
      'gm',
      mode = 'n',
      'm',
      desc = 'Marks',
    },
    {
      'm',
      mode = { 'n', 'x', 'v' },
      'd',
      desc = 'Cut',
    },
    {
      'mm',
      mode = 'n',
      'dd',
      desc = 'Cut',
    },
    {
      'M',
      mode = 'n',
      'D',
      desc = 'Cut',
    },
  },
}
