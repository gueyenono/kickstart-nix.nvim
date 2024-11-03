local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

-- LSP Attach Event Handling
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
		map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
		map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
		map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
		map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
		map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
		map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
		map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
			local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
				end,
			})
		end

		if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, "[T]oggle Inlay [H]ints")
		end
	end,
})

-- Capabilities and Language Server setup
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

local lsp_flags = {
	allow_incremental_sync = true,
	debounce_text_changes = 150,
}

lspconfig.marksman.setup({
	capabilities = capabilities,
	filetypes = { "markdown", "quarto" },
	root_dir = util.root_pattern(".git", ".marksman.toml", "_quarto.yml"),
})

lspconfig.nil_ls.setup({
	autostart = true,
	capabilities = capabilities,
	-- cmd = { vim.env.NIL_PATH or "target/debug/nil" },
	filetypes = { "nix" },
	rootPatterns = { "flake.nix" },
	flags = lsp_flags,
	settings = {
		["nil"] = {
			testSetting = 42,
			formatting = {
				command = { "nixfmt" },
			},
		},
	},
})

lspconfig.cssls.setup({
	capabilities = capabilities,
	flags = lsp_flags,
})
--
lspconfig.html.setup({
	capabilities = capabilities,
	flags = lsp_flags,
})

lspconfig.yamlls.setup({
	capabilities = capabilities,
	flags = lsp_flags,
	settings = {
		yaml = {
			schemaStore = {
				enable = true,
				url = "",
			},
		},
	},
})

lspconfig.jsonls.setup({
	capabilities = capabilities,
	flags = lsp_flags,
})

lspconfig.ts_ls.setup({
	capabilities = capabilities,
	flags = lsp_flags,
	filetypes = { "js", "javascript", "typescript", "ojs" },
})

lspconfig.pyright.setup({
	capabilities = capabilities,
	flags = lsp_flags,
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "workspace",
			},
		},
	},
	root_dir = function(fname)
		return util.root_pattern(".git", "setup.py", "setup.cfg", "pyproject.toml", "requirements.txt")(fname)
			or util.path.dirname(fname)
	end,
})

lspconfig.rust_analyzer.setup({
	capabilities = capabilities,
	settings = {
		["rust-analyzer"] = {
			diagnostics = {
				enable = false,
			},
		},
	},
})

lspconfig.lua_ls.setup({
	capabilities = capabilities,
	flags = lsp_flags,
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				disable = { "trailing-space" },
			},
			workspace = {
				checkThirdParty = false,
			},
			doc = {
				privateName = { "^_" },
			},
			telemetry = {
				enable = false,
			},
		},
	},
})
