require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

require("mason-tool-installer").setup({
	ensure_installed = {
		-- --- GO ---
		"gopls", -- LSP nativo de Go
		"golangci-lint", -- Linter avançado de Go
		"gofumpt", -- Formatador estrito de Go
		"goimports", -- Organizador de imports de Go

		-- --- TS / JS / SVELTE ---
		"vtsls", -- LSP moderno de TypeScript/JavaScript
		"svelte-language-server", -- LSP nativo de Svelte
		"eslint_d", -- Linter rápido de JS/TS
		"prettierd", -- Formatador rápido de Web (Svelte/JS/TS/JSON)

		-- --- C / C++ ---
		"clangd", -- LSP de C/C++
		"clang-format", -- Formatador oficial de C/C++

		-- --- LUA (Para suas configurações do próprio Neovim) ---
		"lua-language-server", -- Autocompletar seu init.lua
		"stylua", -- Formatar seus arquivos .lua

		--- DEBUGGERS (DAP) ---
		"delve", -- Debugger oficial de Go (dlv)
		"js-debug-adapter", -- Debugger oficial da Microsoft para JS/TS/Svelte
		"codelldb", -- Debugger ultra-rápido baseado em LLVM para C/C++
	},

	-- Roda a instalação assim que o Neovim inicia
	auto_install = true,

	-- Atualiza pacotes automaticamente ao iniciar (opcional, mude para false se preferir fixo)
	run_on_start = true,
})

require("mason-nvim-dap").setup({
	ensure_installed = { "codelldb", "delve", "js-debug-adapter" },
	automatic_installation = true,
	handlers = {
		function(config)
			require("mason-nvim-dap").default_setup(config)
		end,
	},
})
require("mason-lspconfig").setup()

vim.keymap.set("n", "gD", vim.lsp.buf.definition, { desc = "Show LSP definition" })
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "See available code actions" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Smart rename" })
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format Local buffer" })
vim.keymap.set("n", "df", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
vim.keymap.set("n", "<leader>D", function()
	vim.diagnostic.open_float({ Float = true })
end, { desc = "Show diagnostics in line" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show cursor diagnostics" }) -- Cursor diagnostics
vim.keymap.set("n", "pd", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to previous diagnostic" })
vim.keymap.set("n", "nd", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next diagnostic" }) -- jump to next diagnostic in buffer
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show documentation for what is under cursor" }) -- show documentation for what is under cursor

local severity = vim.diagnostic.severity
vim.diagnostic.config({
	signs = {
		text = {
			[severity.ERROR] = " ",
			[severity.WARN] = " ",
			[severity.HINT] = "󰠠 ",
			[severity.INFO] = " ",
		},
	},
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("mini.completion").get_lsp_capabilities())

vim.lsp.config("*", { capabilities = capabilities })

-- vim.lsp.enable({
--   "lua_ls",
--   "marksman",
--   "gopls",
--   "rust_analyzer",
--   "svelte",
--   "clangd",
--   "vtsls"
-- })
