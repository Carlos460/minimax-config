-- ┌─────────────────────┐
-- │ C development tools │
-- └─────────────────────┘
--
-- Ported from the old config: async `make` into the quickfix list, man page
-- lookup and a valgrind runner. Functions live in `Config.cdev`.
-- Mappings:
-- - `<Leader>rk` / `<Leader>rc` / `<Leader>rm` - see 'plugin/20_keymaps.lua'
-- - `<Leader>k` / `<Leader>rv` (C/C++ buffers) - see 'after/ftplugin/c.lua'

local M = {}

-- Run `make <args>` in the background and load gcc/clang errors into quickfix.
M.make = function(args)
  vim.cmd('silent! wall')
  local cmd = vim.list_extend({ 'make' }, args or {})
  local title = table.concat(cmd, ' ')
  vim.notify(title .. ' ...')

  vim.system(cmd, { text = true, cwd = vim.fn.getcwd() }, function(res)
    vim.schedule(function()
      local out = (res.stdout or '') .. (res.stderr or '')
      vim.fn.setqflist({}, ' ', {
        title = title,
        lines = vim.split(out, '\n', { trimempty = true }),
        efm = vim.o.errorformat, -- default understands gcc/clang + "Entering directory"
      })

      local errors = vim.tbl_filter(function(item) return item.valid == 1 end, vim.fn.getqflist())

      if res.code == 0 and #errors == 0 then
        vim.notify(title .. ': ok')
      else
        vim.notify(('%s: exit %d, %d issue(s)'):format(title, res.code, #errors), vim.log.levels.WARN)
        vim.cmd('copen')
      end
    end)
  end)
end

-- Ask for arguments, then run `make`
M.make_prompt = function()
  vim.ui.input({ prompt = 'make ' }, function(input)
    if input == nil then return end
    M.make(vim.split(input, ' ', { trimempty = true }))
  end)
end

-- Open the man page for the word under the cursor, preferring syscalls (2) and
-- libc (3) over shell commands of the same name (e.g. printf(3), not printf(1)).
M.man_cword = function()
  local word = vim.fn.expand('<cword>')
  for _, sec in ipairs({ '2', '3', '3p', '' }) do
    local args = sec == '' and { 'man', '-w', word } or { 'man', '-w', sec, word }
    if vim.system(args):wait().code == 0 then
      if sec == '' then
        vim.cmd.Man(word)
      else
        vim.cmd.Man(sec, word)
      end
      return
    end
  end
  vim.notify('no man page for ' .. word, vim.log.levels.WARN)
end

-- Run a program under valgrind in a terminal split. Remembers the last command.
local last_valgrind = 'valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./'
M.valgrind = function()
  local cmd = vim.fn.input('run: ', last_valgrind, 'shellcmd')
  if cmd == '' then return end
  last_valgrind = cmd
  vim.cmd('botright 15split | terminal ' .. cmd)
  vim.cmd('startinsert')
end

Config.cdev = M
