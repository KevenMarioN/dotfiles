return {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,     -- Avisa sobre parâmetros não utilizados
        shadow = true,           -- Avisa sobre variáveis sombreadas
      },
      staticcheck = true,        -- Ativa análises extras do staticcheck
      gofumpt = true,            -- Usa uma formatação mais estrita (se instalado)
      completeUnimported = true, -- Autocompila pacotes mesmo sem o import explícito
    },
  },
}
