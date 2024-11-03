-- otter.nvim: LSP features in code cells / embedded code (e.g. Quarto, Rmarkdown)

require'otter'.setup{
	dev = false,
	opts = {
		verbose = {
			no_code_found = false,
		},
	},
}
