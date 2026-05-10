return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status")

		-- Paleta Gruvbox (Cores 'Dark' padrão)
		local colors = {
			bg = "#282828",
			fg = "#ebdbb2",
			yellow = "#fabd2f",
			cyan = "#8ec07c",
			darkblue = "#458588",
			green = "#b8bb26",
			orange = "#fe8019",
			violet = "#d3869b",
			magenta = "#b16286",
			blue = "#83a598",
			red = "#fb4934",
			grey = "#928374",
			inactive_bg = "#3c3836",
		}

		local my_lualine_theme = {
			normal = {
				a = { bg = colors.grey, fg = colors.bg, gui = "bold" },
				b = { bg = colors.inactive_bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			insert = {
				a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
				b = { bg = colors.inactive_bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			visual = {
				a = { bg = colors.orange, fg = colors.bg, gui = "bold" },
				b = { bg = colors.inactive_bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			command = {
				a = { bg = colors.green, fg = colors.bg, gui = "bold" },
				b = { bg = colors.inactive_bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			replace = {
				a = { bg = colors.red, fg = colors.bg, gui = "bold" },
				b = { bg = colors.inactive_bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			inactive = {
				a = { bg = colors.inactive_bg, fg = colors.grey, gui = "bold" },
				b = { bg = colors.inactive_bg, fg = colors.grey },
				c = { bg = colors.inactive_bg, fg = colors.grey },
			},
		}

		lualine.setup({
			options = {
				theme = my_lualine_theme,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = colors.orange },
					},
					{ "encoding" },
					{ "fileformat" }, -- Removi o símbolo fixo de Mac para ser mais neutro, mas pode manter se preferir
					{ "filetype" },
				},
			},
		})
	end,
}
