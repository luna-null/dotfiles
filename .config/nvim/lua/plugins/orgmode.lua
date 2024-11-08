return {
  {
    'nvim-orgmode/orgmode',
    event = 'VeryLazy',
    ft = { 'org' },
    config = function()
      -- Setup orgmode
      local Menu = require("org-modern.menu")
      require('orgmode').setup({
        org_agenda_files = '~/Documents/org/**/*',
        org_default_notes_file = '~/Documents/org/notes.org',
        org_capture_templates = {
          t = { 
            description = 'Task', 
            template = '* TODO %?\n%u',
            target = '~/Documents/org/todo.org'
          },
          j = {
            description = 'Journal',
            template = '\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?',
            target = '~/Documents/org/journal/%<%Y-%m>.org'
          },
          e = {
            description = 'Event',
            subtemplates = {
              r = {
                description = 'recurring',
                template = '** %?\n %T',
                target = '~/Documents/org/calendar.org',
                headline = 'recurring'
              },
              o = {
                description = 'one-time',
                template = '** %?\n %T',
                target = '~/Documents/org/calendar.org',
                headline = 'one-time'
              },
            },
          },
          n = {
            description = 'Note',
            
          },
          r = {
              description = "Repo",
              template = "* [[%x][%(return string.match('%x', '([^/]+)$'))]]%?",
              target = "~/Documents/org/repos.org",
          },
        },
        org_deadline_warning_days = 14,
        calendar_week_start_day = 0,
        org_highlight_latex_and_related = "native",
        ui = {
          menu = {
            handler = function(data)
              Menu:new({
                window = {
                  margin = { 1, 0, 1, 0 },
                  padding = { 0, 1, 0, 1 },
                  title_pos = "center",
                  border = "single",
                  zindex = 1000,
                },
                icons = {
                  separator = "➜",
                },
              }):open(data)
            end,
          },
        },
      })
      -- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
      -- add ~org~ to ignore_install
      -- require('nvim-treesitter.configs').setup({
      --   ensure_installed = { 'org' },
      -- })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'org',
        callback = function()
          vim.keymap.set('i', '<S-CR>', '<cmd>lua require("orgmode").action("org_mappings.meta_return")<CR>', {
            silent = true,
            buffer = true,
          })
        end,
      })
    end,
  },
  {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true, -- or `opts = {}`
  },
  {
    'akinsho/org-bullets.nvim',
    config = function()
      require("org-bullets").setup {
        concealcursor = false, -- If false then when the cursor is on a line underlying characters are visible
        symbols = {
          -- list symbol
          list = "•",
          -- headlines can be a list
          headlines = { "◉", "○", "✸", "✿" },
          -- or a function that receives the defaults and returns a list
          headlines = function(default_list)
            table.insert(default_list, "♥")
            return default_list
          end,
          -- or false to disable the symbol. Works for all symbols
          -- headlines = false,
          -- or a table of tables that provide a name
          -- and (optional) highlight group for each headline level
          headlines = { 
            { "◉", "MyBulletL1" },
            { "○", "MyBulletL2" },
            { "✸", "MyBulletL3" },
            { "✿", "MyBulletL4" },
          },
          checkboxes = {
            half = { "", "@org.checkbox.halfchecked" },
            done = { "✓", "@org.keyword.done" },
            todo = { "˟", "@org.keyword.todo" },
          },
        },
      }
    end,
  },
  {
    "chipsenkbeil/org-roam.nvim",
    tag = "0.1.0",
    dependencies = {
      {
        "nvim-orgmode/orgmode",
        tag = "0.3.4",
      },
    },
    config = function()
      require("org-roam").setup({
        directory = "~/org_roam_files",
        -- optional
        org_files = {
        }
      })
    end
  },
  {
    'TravonteD/org-capture-filetype',
    -- opts = {},
  },
  {
    "massix/org-checkbox.nvim",
    config = function()
      require("orgcheckbox").setup()
    end,
    ft = { "org" },
  },
  {
    "chipsenkbeil/org-mouse.nvim",
    dependencies = { "nvim-orgmode/orgmode" },
    config = function()
      require("org-mouse").setup()
    end
  },
  {
    'BartSte/nvim-khalorg',
  },
  {
    'dhruvasagar/vim-table-mode',
  },
  {
    'danilshvalov/org-modern.nvim',
  },
  {
    'ranjithshegde/orgWiki.nvim',
  },
} -- only for lunar vim}
