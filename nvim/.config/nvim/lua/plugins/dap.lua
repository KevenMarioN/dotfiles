local dap = require("dap")
vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "Toggle Break" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Inspect" })
vim.keymap.set("n", "<leader>dk", dap.terminate, { desc = "Kill" })

vim.keymap.set("n", "<leader>dso", dap.step_over, { desc = "Step Over" })
vim.keymap.set("n", "<leader>dsi", dap.step_into, { desc = "Step Into" })
vim.keymap.set("n", "<leader>dsu", dap.step_out, { desc = "Step Out" })
vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run Last" })

local dapui = require("dapui")
vim.keymap.set("n", "<leader>duu", dapui.open, { desc = "open ui" })
vim.keymap.set("n", "<leader>duc", dapui.close, { desc = "open ui" })

require("dapui").setup()
dap.configurations.cpp = {
	{
		name = "Launch file",
		type = "cppdbg",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopAtEntry = true,
	},
	{
		name = "Attach to gdbserver :1234",
		type = "cppdbg",
		request = "launch",
		MIMode = "gdb",
		miDebuggerServerAddress = "localhost:1234",
		miDebuggerPath = "/usr/bin/gdb",
		cwd = "${workspaceFolder}",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
	},
}

dap.adapters.delve = function(callback, config)
	if config.mode == "remote" and config.request == "attach" then
		callback({
			type = "server",
			host = config.host or "127.0.0.1",
			port = config.port or "38697",
		})
	else
		callback({
			type = "server",
			port = "${port}",
			executable = {
				command = "dlv",
				args = { "dap", "-l", "127.0.0.1:${port}", "--log", "--log-output=dap" },
				detached = vim.fn.has("win32") == 0,
			},
		})
	end
end

dap.configurations.go = {
	{
		type = "delve",
		name = "Debug",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
	},
	{
		type = "delve",
		name = "Debug test", -- configuration for debugging test files
		request = "launch",
		mode = "test",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
	},
	-- works with go.mod packages and sub packages
	{
		type = "delve",
		name = "Debug test (go.mod)",
		request = "launch",
		mode = "test",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
	},
}
