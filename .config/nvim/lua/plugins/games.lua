return {
  {
    'Eandrju/cellular-automaton.nvim',
    keys = {
      {
        '<Space>fmlr',
        mode = 'n',
        '<cmd>CellularAutomaton make_it_rain<CR>',
        desc = 'Make it [R]ain',
      },
      {
        '<Space>fmls',
        mode = 'n',
        '<cmd>CellularAutomaton scramble<CR>',
        desc = '[S]cramble',
      },
      {
        '<Space>fmlg',
        mode = 'n',
        '<cmd>CellularAutomaton game_of_life<CR>',
        desc = '[G]ame of Life',
      },
    }
  },
  {
    'alec-gibson/nvim-tetris',
    keys = {
      {
        '<Space>fmlt',
        mode = 'n',
        '<cmd>Tetris<CR>',
        desc = '[T]etris',
      },
    },
  },
  {
    'seandewar/nvimesweeper',
    keys = {
      {
        '<Space>fmlm',
        mode = 'n',
        '<cmd>Nvimesweeper<CR>',
        desc = '[M]inesweeper',
      },
    },
  },
  {
    'seandewar/killersheep.nvim',
    keys = {
      {
        '<Space>fmlp',
        mode = 'n',
        '<cmd>KillKillKill<CR>',
        desc = 'KillerShee[p]',
      },
    },
  },
  {
    'rktjmp/playtime.nvim',
    keys = {
      {
        '<Space>fmlo',
        mode = 'n',
        '<cmd>Playtime<CR>',
        desc = 'S[o]litaire',
      },
    },
  },
  {
    'alanfortlink/blackjack.nvim',
    keys = {
      {
        '<Space>fmlb',
        mode = 'n',
        '<cmd>BlackJackNewGame<CR>',
        desc = '[B]lackjack',
      },
    },
  },
  {
    'jim-fx/sudoku.nvim',
    cmd = "Sudoku",
    config = function()
      -- These are the defaults for the settings
      require("sudoku").setup({
        persist_settings = true, -- safe the settings under vim.fn.stdpath("data"), usually ~/.local/share/nvim,
        persist_games = true,    -- persist a history of all played games
        default_mappings = true, -- if set to false you need to set your own, like the following:
        mappings = {
          { key = "x",     action = "clear_cell" },
          { key = "r1",    action = "insert=1" },
          { key = "r2",    action = "insert=2" },
          { key = "r3",    action = "insert=3" },
          -- ...
          { key = "r9",    action = "insert=9" },
          { key = "gn",    action = "new_game" },
          { key = "gr",    action = "reset_game" },
          { key = "gs",    action = "view=settings" },
          { key = "gt",    action = "view=tip" },
          { key = "gz",    action = "view=zen" },
          { key = "gh",    action = "view=help" },
          { key = "u",     action = "undo" },
          { key = "<C-r>", action = "redo" },
          { key = "+",     action = "increment" },
          { key = "-",     action = "decrement" },
        },
        custom_highlights = {
          board = { fg = "#7d7d7d" },
          number = { fg = "white", bg = "black" },
          active_menu = { fg = "white", bg = "black", gui = "bold" },
          hint_cell = { fg = "white", bg = "yellow" },
          square = { bg = "#292b35", fg = "white" },
          column = { bg = "#14151a", fg = "#d5d5d5" },
          row = { bg = "#14151a", fg = "#d5d5d5" },
          settings_disabled = { fg = "#8e8e8e", gui = "italic" },
          same_number = { fg = "white", gui = "bold" },
          set_number = { fg = "white", gui = "italic" },
          error = { fg = "white", bg = "#843434" },
        }
      })
    end,
    keys = {
      {
        '<Space>fmlk',
        mode = 'n',
        '<cmd>Sudoku<CR>',
        desc = 'Sudo[k]u',
      },
    },
  },
  'ThePrimeagen/vim-be-good',
}
