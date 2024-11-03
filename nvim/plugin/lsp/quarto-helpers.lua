-- Quarto-nvim
require("quarto").setup({
	lspFeatures = {
		enabled = true,
		languages = { "r", "python", "julia", "bash", "html" },
		diagnostics = {
			enabled = true,
			triggers = { "BufWrite" },
		},
		completion = {
			enabled = true,
		},
	},
})

-- Headlines
require("headlines").setup({
	quarto = {
		query = vim.treesitter.query.parse(
			"markdown",
			[[
          (fenced_code_block) @codeblock
      ]]
		),
		codeblock_highlight = "CodeBlock",
		treesitter_language = "markdown",
	},
	markdown = {
		query = vim.treesitter.query.parse(
			"markdown",
			[[
          (fenced_code_block) @codeblock
      ]]
		),
		codeblock_highlight = "CodeBlock",
	},
})

-- nabla.nvim: Popup for Math equations
require("nabla")
vim.keymap.set("n", "<localleader>qm", ':lua require "nabla".toggle_virt()<cr>', { desc = "toggle [m]ath equations" })

-- img-clip.nvim:
