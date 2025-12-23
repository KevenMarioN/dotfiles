-- ================================================================================================
-- TITLE : yamlls (YAML Language Server) LSP Setup
-- LINKS :
--   > github: https://github.com/redhat-developer/yaml-language-server
-- ================================================================================================

--- @param capabilities table LSP client capabilities (typically from nvim-cmp or similar)
--- @return nil
return function(capabilities)
	vim.lsp.config('yamlls', {
		capabilities = capabilities,
		settings = {
			yaml = {
				schemas = {
					["https://raw.githubusercontent.com/compose-spec/compose-go/master/schema/compose-spec.json"] = "docker-compose*.yml",
				},
				validate = true,
				format = {
					enable = true,
				},
			},
		},
		filetypes = { "yaml" },
	})
end
