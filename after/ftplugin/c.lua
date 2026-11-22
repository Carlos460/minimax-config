-- C (and C++, see 'after/ftplugin/cpp.lua') buffer settings ported from the old config

-- Indentation (4 spaces) is the global default from 'plugin/10_options.lua'

-- Helpers from 'plugin/50_cdev.lua'.
-- `<Leader>mv` from the old config moved to `<Leader>rv` (`<Leader>m` is 'mini.map').
local map = function(lhs, rhs, desc) vim.keymap.set('n', lhs, rhs, { buffer = 0, desc = desc }) end
map('<Leader>k', function() Config.cdev.man_cword() end, 'Man page for word')
map('<Leader>rv', function() Config.cdev.valgrind() end, 'Run under valgrind')
