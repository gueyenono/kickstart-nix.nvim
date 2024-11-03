require('r').setup {
  hook = {
    on_filetype = function()
      vim.api.nvim_buf_set_keymap(0, 'n', '<Enter>', '<Plug>RDSendLine', {})
      vim.api.nvim_buf_set_keymap(0, 'v', '<Enter>', '<Plug>RSendSelection', {})
    end,
  },
  pdfviewer = 'zathura',
  R_args = { '--quiet', '--no-save' },
  min_editor_width = 72,
  rconsole_width = 78,
  disable_cmds = {
    'RClearConsole',
    'RCustomStart',
    'RSPlot',
    'RSaveClose',
  },
  -- Check if the environment variable "R_AUTO_START" exists.
  auto_start = vim.env.R_AUTO_START == 'true' and 'on startup' or nil,
  objbr_auto_start = vim.env.R_AUTO_START == 'true' or nil,
}
