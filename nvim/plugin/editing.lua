-- [[ Comment.nvim ]]
require("Comment").setup()
require("todo-comments").setup()

-- Better Around/Inside text objects
require("mini.ai").setup({
	n_lines = 500,
})

-- Add/delete/replace surroundings (brackets, quotes, etc.)
require("mini.surround").setup()

-- Simple and easy statusline
local statusline = require("mini.statusline")
statusline.setup({
	use_icons = vim.g.have_nerd_font, -- set use_icons based on Nerd Font availability
})

-- Configure statusline section for cursor location to show LINE:COLUMN
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
	return "%2l:%-2v"
end
