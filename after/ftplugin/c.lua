-- C (and C++, see 'after/ftplugin/cpp.lua') buffer settings ported from the old config

-- 4-space indentation (everything else uses 2)
vim.bo.expandtab = true
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4

-- Helpers from 'plugin/50_cdev.lua'.
-- `<Leader>mv` from the old config moved to `<Leader>rv` (`<Leader>m` is 'mini.map').
local map = function(lhs, rhs, desc) vim.keymap.set('n', lhs, rhs, { buffer = 0, desc = desc }) end
map('<Leader>k', function() Config.cdev.man_cword() end, 'Man page for word')
map('<Leader>rv', function() Config.cdev.valgrind() end, 'Run under valgrind')
