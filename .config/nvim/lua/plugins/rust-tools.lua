return {
  "simrat39/rust-tools.nvim",
  config = function()
    require('rust-tools').setup({
      server = {
        settings = {
          ["rust-analyzer"] = {
            completion = {
              callable = {
                snippets = true,  -- Ensure function arguments are completed as snippets
              },
            },
          },
        },
      },
    })
    end,
}

