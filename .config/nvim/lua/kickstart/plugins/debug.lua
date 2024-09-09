-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
  },
  keys = function(_, keys)
    local dap = require 'dap'
    local dapui = require 'dapui'
    return {
      -- Basic debugging keymaps, feel free to change to your liking!
      { '<F5>', dap.continue, desc = 'Debug: Start/Continue' },
      { '<F10>', dap.step_over, desc = 'Debug: Step Over' },
      {'<F11>', dap.step_into, desc = 'Debug: Step Into' },
      {'<S-F11>', dap.step_out, desc = 'Debug: Step Out' },
      { '<leader>b', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
      {
        '<leader>B',
        function()
          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Breakpoint',
      },
      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      { '<F7>', dapui.toggle, desc = 'Debug: See last session result.' },
      unpack(keys),
    }
  end,
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
      },
    opts = function(_, opts)
     -- add more things to the ensure_installed table protecting against community packs modifying it
     opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
       "codelldb",
       "cpptools",
     })
    end,
    }

    vim.fn.sign_define('DapStopped',{ text="", texthl='green',linehl='black', numhl='yellow' })
    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '',
          step_over = '',
          step_out = '',
          step_back = '',
          run_last = '↻',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
    -- Haskell config
    dap.adapters.haskell = {
      type = 'executable';
      command = 'haskell-debug-adapter';
      args = {'--hackage-version=0.0.33.0'};
    }
    dap.configurations.haskell = {
      {
        type = 'haskell',
        request = 'launch',
        name = 'Debug',
        workspace = '${workspaceFolder}',
        startup = "${file}",
        stopOnEntry = true,
        logFile = vim.fn.stdpath('data') .. '/haskell-dap.log',
        logLevel = 'WARNING',
        ghciEnv = vim.empty_dict(),
        ghciPrompt = "λ> ",
        -- Adjust the prompt to the prompt you see when you invoke the stack ghci command below 
        ghciInitialPrompt = "λ> ",
        ghciCmd= "stack ghci --test --no-load --no-build --main-is TARGET --ghci-options -fprint-evld-with-show",
      },
    }
    
    -- Dotnet Config
    dap.adapters.coreclr = {
      type = 'executable',
      command = '/path/to/dotnet/netcoredbg/netcoredbg',
      args = {'--interpreter=vscode'}
    }
    dap.configurations.cs = {
      {
        type = "coreclr",
        name = "launch - netcoredbg",
        request = "launch",
        program = function()
            return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
        end,
      },
    }
    -- Lua Config
    dap.adapters["local-lua"] = {
      type = "executable",
      command = "node",
      args = {
        "/absolute/path/to/local-lua-debugger-vscode/extension/debugAdapter.js"
      },
      enrich_config = function(config, on_config)
        if not config["extensionPath"] then
          local c = vim.deepcopy(config)
          -- 💀 If this is missing or wrong you'll see 
          -- "module 'lldebugger' not found" errors in the dap-repl when trying to launch a debug session
          c.extensionPath = "/absolute/path/to/local-lua-debugger-vscode/"
          on_config(c)
        else
          on_config(config)
        end
      end,
    }
    -- Perl Config
    dap.adapters.perl = {
      type = 'executable',
      -- Path to perl-debug-adapter - will be different based on the installation method
      -- mason.nvim
      command = vim.env.MASON .. '/bin/perl-debug-adapter',
      -- AUR (or if perl-debug-adapter is in PATH)
      -- command = 'perl-debug-adapter',
      args = {},
    }

    dap.configurations.perl = {
        {
           type = 'perl',
           request = 'launch',
           name = 'Launch Perl',
           program = '${workspaceFolder}/${relativeFile}',
        }
    }
    -- this is optional but can be helpful when starting out
    -- Bash Config
    dap.adapters.bashdb = {
      type = 'executable';
      command = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/bash-debug-adapter';
      name = 'bashdb';
    }
    dap.configurations.sh = {
      {
        type = 'bashdb';
        request = 'launch';
        name = "Launch file";
        showDebugOutput = true;
        pathBashdb = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb';
        pathBashdbLib = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir';
        trace = true;
        file = "${file}";
        program = "${file}";
        cwd = '${workspaceFolder}';
        pathCat = "cat";
        pathBash = "/bin/bash";
        pathMkfifo = "mkfifo";
        pathPkill = "pkill";
        args = {};
        env = {};
        terminalKind = "integrated";
      }
    }
    -- C/C++/Rust (gdb) config
    dap.adapters.gdb = {
      type = "executable",
      command = "gdb",
      args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
    }
    dap.configurations.c = {
      {
        name = "Launch",
        type = "gdb",
        request = "launch",
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = "${workspaceFolder}",
        stopAtBeginningOfMainSubprogram = false,
      },
      {
        name = "Select and attach to process",
        type = "gdb",
        request = "attach",
        program = function()
           return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        pid = function()
           local name = vim.fn.input('Executable name (filter): ')
           return require("dap.utils").pick_process({ filter = name })
        end,
        cwd = '${workspaceFolder}'
      },
      {
        name = 'Attach to gdbserver :1234',
        type = 'gdb',
        request = 'attach',
        target = 'localhost:1234',
        program = function()
           return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}'
      },
    }



    dap.set_log_level 'TRACE'
  end,
}
