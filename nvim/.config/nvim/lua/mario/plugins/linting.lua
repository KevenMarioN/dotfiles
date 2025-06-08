return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

     -- 🔧 Registro manual do linter golangci_lint
    lint.linters.golangci_lint = {
      cmd = "golangci-lint",
      stdin = false,
      args = { "run", "--out-format", "json" },
      stream = "stdout",
      ignore_exitcode = true,
      parser = function(output, _)
        local diagnostics = {}
        local ok, decoded = pcall(vim.fn.json_decode, output)
        if not ok or not decoded then
          return diagnostics
        end

        for _, issue in ipairs(decoded.Issues or {}) do
          table.insert(diagnostics, {
            lnum = issue.Pos.Line - 1,
            col = issue.Pos.Column - 1,
            end_lnum = issue.Pos.Line - 1,
            end_col = issue.Pos.Column,
            message = issue.Text,
            source = "golangci-lint",
            severity = vim.diagnostic.severity.WARN,
          })
        end

        return diagnostics
      end,
    }

    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      python = { "pylint" },
      go = { "golangci_lint" }
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
