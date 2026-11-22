-- ┌──────────┐
-- │ Debugger │
-- └──────────┘
--
-- Ported from the old config: nvim-dap with codelldb for C/C++, plus dap-ui
-- and inline variable values.
-- - Adapter: `codelldb` from Mason (`:MasonInstall codelldb`)
-- - Launch configs: launch executable, attach to process, launch from script
--   (see 'lua/dap_launch_script.lua')
-- - Mappings: function keys below, `<Leader>d` group in 'plugin/20_keymaps.lua'

Config.later(function()
  vim.pack.add({
    'https://github.com/mfussenegger/nvim-dap',
    'https://github.com/nvim-neotest/nvim-nio', -- required by nvim-dap-ui
    'https://github.com/rcarriga/nvim-dap-ui',
    'https://github.com/theHamsta/nvim-dap-virtual-text',
  })
  local dap = require('dap')

  -- Adapter ------------------------------------------------------------------
  dap.adapters.codelldb = {
    type = 'executable',
    command = vim.fn.stdpath('data') .. '/mason/bin/codelldb',
  }

  -- Launch configurations ----------------------------------------------------
  require('dap_launch_script').setup(dap)

  dap.configurations.c = {
    {
      name = 'Launch executable',
      type = 'codelldb',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      args = function()
        return vim.split(vim.fn.input('Arguments: '), ' ', { trimempty = true })
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
    },
    {
      name = 'Attach to process',
      type = 'codelldb',
      request = 'attach',
      pid = require('dap.utils').pick_process,
      cwd = '${workspaceFolder}',
    },
    {
      -- Placeholder: replaced by the `on_config` listener in 'lua/dap_launch_script.lua'
      name = 'Launch from script',
      type = 'codelldb',
      request = 'launch',
      launch_from_script = true,
    },
  }
  dap.configurations.cpp = dap.configurations.c

  -- UI -----------------------------------------------------------------------
  -- Scopes / watches / stack / breakpoints panels + console, opened automatically
  local dapui = require('dapui')
  dapui.setup()
  require('nvim-dap-virtual-text').setup({})
  dap.listeners.after.event_initialized['dapui'] = function() dapui.open() end
  dap.listeners.before.event_terminated['dapui'] = function() dapui.close() end
  dap.listeners.before.event_exited['dapui'] = function() dapui.close() end

  vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticError' })
  vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticWarn', linehl = 'Visual' })

  -- Function keys ------------------------------------------------------------
  local map = function(lhs, rhs, desc) vim.keymap.set('n', lhs, rhs, { desc = desc }) end
  map('<F5>', dap.continue, 'Debug: continue / start')
  map('<F10>', dap.step_over, 'Debug: step over')
  map('<F11>', dap.step_into, 'Debug: step into')
  map('<F12>', dap.step_out, 'Debug: step out')
end)
