-- Evita falhas caso o nvim-dap ainda não tenha sido baixado pelo vim.pack na primeira execução
local dap_ok, dap = pcall(require, "dap")
if not dap_ok then return end

local dapui = require("dapui")

-- 1. Setup básico da Interface Visual
dapui.setup()

-- Gatilhos nativos para abrir e fechar os painéis ao debugar
dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

-- =====================================================================
-- 2. CONFIGURAÇÃO DE ADAPTADORES POR LINGUAGEM
-- =====================================================================

-- --- GOLANG ---
require("dap-go").setup() -- Integração direta com o Delve baixado no Mason

-- --- C / C++ (CodeLLDB) ---
dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
    args = { "--port", "${port}" },
  }
}
local c_cpp_config = {
  {
    name = "Launch Executable (C/C++)",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Caminho do binário compilado: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceRoot}",
    stopOnEntry = false,
  },
}
dap.configurations.cpp = c_cpp_config
dap.configurations.c = c_cpp_config

-- --- TYPESCRIPT / JAVASCRIPT / SVELTE (js-debug-adapter) ---
dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter",
    args = { "${port}" },
  }
}
local js_configs = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch Node.js (Arquivo Atual)",
    program = "${file}",
    cwd = "${workspaceRoot}",
  }
}
dap.configurations.javascript = js_configs
dap.configurations.typescript = js_configs
dap.configurations.svelte = js_configs

-- =====================================================================
-- 3. ATALHOS DE TECLADO EXCLUSIVOS DO DEBUG
-- =====================================================================
vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Iniciar/Continuar" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Linha Abaixo (Step Over)" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Entrar (Step Into)" })
vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Breakpoint" })
vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Debug: Abrir REPL" })
