return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	config = function()
		local transparent = false -- mude para true se quiser transparência

		require("gruvbox").setup({
			terminal_colors = true,
			undercurl = true,
			underline = true,
			bold = true,
			italic = {
				strings = true,
				emphasis = true,
				comments = true,
				operators = false,
				folds = true,
			},
			strikethrough = true,
			invert_selection = false,
			invert_signs = false,
			invert_tabline = false,
			invert_intend_guides = false,
			inverse = true, -- inverte cores para busca e seleção
			contrast = "hard", -- opções: "soft", "medium", "hard"
			palette_overrides = {},
			overrides = {
				-- Se precisar forçar transparência em elementos específicos:
				-- SignColumn = {bg = "none"},
			},
			transparent_mode = transparent,
		})

		vim.cmd("colorscheme gruvbox")
	end,
}
