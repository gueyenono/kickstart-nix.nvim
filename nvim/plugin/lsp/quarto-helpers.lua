-- Quarto-nvim
require('quarto').setup {
	debug = false,
	closePreviewOnExit = true,
	lspFeatures = {
		enabled = true,
		chunks = 'curly',
		languages = { 'r', 'python', 'julia', 'bash', 'html' },
		diagnostics = {
			enabled = true,
			triggers = { 'BufWritePost' },
		},
		completion = {
			enabled = true,
		},
	},
	codeRunner = {
		enabled = false,
		default_method = nil, -- 'molten' or 'slime'
		ft_runners = {}, -- filetype to runner, ie. `{ python = "molten" }`.
		-- Takes precedence over `default_method`
		never_run = { 'yaml' }, -- filetypes which are never sent to a code runner
	},
}

-- Headlines
require('headlines').setup {
	quarto = {
		query = vim.treesitter.query.parse(
			'markdown',
			[[
          (fenced_code_block) @codeblock
      ]]
		),
		codeblock_highlight = 'CodeBlock',
		treesitter_language = 'markdown',
	},
	markdown = {
		query = vim.treesitter.query.parse(
			'markdown',
			[[
          (fenced_code_block) @codeblock
      ]]
		),
		codeblock_highlight = 'CodeBlock',
	},
}

-- nabla.nvim: Popup for Math equations
require('nabla')
vim.keymap.set('n', '<localleader>qm', ':lua require "nabla".toggle_virt()<cr>', { desc = 'toggle [m]ath equations' })

-- img-clip.nvim:
