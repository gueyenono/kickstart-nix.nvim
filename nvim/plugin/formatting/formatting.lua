-- Plugin setup with options
require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    local disable_filetypes = { c = true, cpp = true }
    local lsp_format_opt
    if disable_filetypes[vim.bo[bufnr].filetype] then
      lsp_format_opt = 'never'
    else
      lsp_format_opt = 'fallback'
    end
    return {
      timeout_ms = 500,
      lsp_format = lsp_format_opt,
    }
  end,
  formatters_by_ft = {
    -- r = { "rPackages.styler" },
    markdown = { 'vale' },
    lua = { 'stylua' },
    nix = { 'alejandra' },
    python = { 'isort', 'black' },
    javascript = { 'prettierd', stop_after_first = true },
  },
}

-- Autocmd for BufWritePre event to autoformat before saving
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function()
    require('conform').format()
  end,
})

-- Define the command ConformInfo
vim.api.nvim_create_user_command('ConformInfo', function()
  require('conform').info()
end, {})

-- Keybinding for formatting
vim.keymap.set('', '<leader>f', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end, { noremap = true, silent = true, desc = '[F]ormat buffer' })
