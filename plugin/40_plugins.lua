-- ┌─────────────────────────┐
-- │ Plugins outside of MINI │
-- └─────────────────────────┘
--
-- This file contains installation and configuration of plugins outside of MINI.
-- They significantly improve user experience in a way not yet possible with MINI.
-- These are mostly plugins that provide programming language specific behavior.
--
-- Use this file to install and configure other such plugins.

-- Make concise helpers for installing/adding plugins in two stages
local add = vim.pack.add
local now_if_args, later = Config.now_if_args, Config.later

-- Tree-sitter ================================================================

-- Tree-sitter is a tool for fast incremental parsing. It converts text into
-- a hierarchical structure (called tree) that can be used to implement advanced
-- and/or more precise actions: syntax highlighting, textobjects, indent, etc.
--
-- Tree-sitter support is built into Neovim (see `:h treesitter`). However, it
-- requires two extra pieces that don't come with Neovim directly:
-- - Language parsers: programs that convert text into trees. Some are built-in
--   (like for Lua), 'nvim-treesitter' provides many others.
--   NOTE: It requires third party software to build and install parsers.
--   See the link for more info in "Requirements" section of the MiniMax README.
-- - Query files: definitions of how to extract information from trees in
--   a useful manner (see `:h treesitter-query`). 'nvim-treesitter' also provides
--   these, while 'nvim-treesitter-textobjects' provides the ones for Neovim
--   textobjects (see `:h text-objects`, `:h MiniAi.gen_spec.treesitter()`).
--
-- Add these plugins now if file (and not 'mini.starter') is shown after startup.
--
-- Troubleshooting:
-- - Run `:checkhealth vim.treesitter nvim-treesitter` to see potential issues.
-- - In case of errors related to queries for Neovim bundled parsers (like `lua`,
--   `vimdoc`, `markdown`, etc.), manually install them via 'nvim-treesitter'
--   with `:TSInstall <language>`. Be sure to have necessary system dependencies
--   (see MiniMax README section for software requirements).
now_if_args(function()
  -- Define hook to update tree-sitter parsers after plugin is updated
  local ts_update = function() vim.cmd('TSUpdate') end
  Config.on_packchanged('nvim-treesitter', { 'update' }, ts_update, ':TSUpdate')

  add({
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  })

  -- Define languages which will have parsers installed and auto enabled
  -- After changing this, restart Neovim once to install necessary parsers. Wait
  -- for the installation to finish before opening a file for added language(s).
  local languages = {
    -- These are already pre-installed with Neovim. Used as an example.
    'lua',
    'vimdoc',
    'markdown',
    -- Ported from the old config
    'luadoc', 'printf', 'vim',
    'c', 'cpp', 'cmake', 'make',
    'javascript', 'typescript', 'tsx', 'jsdoc',
    'html', 'css', 'scss',
    'php', 'phpdoc',
    'json', 'markdown_inline', 'bash',
    -- Add here more languages with which you want to use tree-sitter
    -- To see available languages:
    -- - Execute `:=require('nvim-treesitter').get_available()`
    -- - Visit 'SUPPORTED_LANGUAGES.md' file at
    --   https://github.com/nvim-treesitter/nvim-treesitter/blob/main
  }
  local isnt_installed = function(lang)
    return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0
  end
  local to_install = vim.tbl_filter(isnt_installed, languages)
  if #to_install > 0 then require('nvim-treesitter').install(to_install) end

  -- Enable tree-sitter after opening a file for a target language
  local filetypes = {}
  for _, lang in ipairs(languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end
  local ts_start = function(ev)
    vim.treesitter.start(ev.buf)
    -- Tree-sitter based indentation (ported from the old config)
    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
  Config.new_autocmd('FileType', filetypes, ts_start, 'Start tree-sitter')
end)

-- Show enclosing function / struct / loop header at the top of the window.
-- Toggle with `<Leader>oc`. Jump to the context with `[e` (was `[x` in the old
-- config; 'mini.bracketed' uses `[x` for conflict markers).
now_if_args(function()
  add({ 'https://github.com/nvim-treesitter/nvim-treesitter-context' })
  require('treesitter-context').setup({ max_lines = 3, multiline_threshold = 1 })

  local go_to_context = function() require('treesitter-context').go_to_context(vim.v.count1) end
  vim.keymap.set('n', '[e', go_to_context, { desc = 'Enclosing context' })
end)

-- Auto close / rename HTML, JSX and PHP tags
now_if_args(function()
  add({ 'https://github.com/windwp/nvim-ts-autotag' })
  require('nvim-ts-autotag').setup()
end)

-- Language servers ===========================================================

-- Language Server Protocol (LSP) is a set of conventions that power creation of
-- language specific tools. It requires two parts:
-- - Server - program that performs language specific computations.
-- - Client - program that asks server for computations and shows results.
--
-- Here Neovim itself is a client (see `:h vim.lsp`). Language servers need to
-- be installed separately based on your OS, CLI tools, and preferences.
-- See note about 'mason.nvim' at the bottom of the file.
--
-- Neovim's team collects commonly used configurations for most language servers
-- inside 'neovim/nvim-lspconfig' plugin.
--
-- Add it now if file (and not 'mini.starter') is shown after startup.
--
-- Troubleshooting:
-- - Run `:checkhealth vim.lsp` to see potential issues.
--
-- Servers, formatters, linters and 'codelldb' are installed with Mason
-- (ported from the old config). It must be set up before servers start, because
-- it puts its 'bin/' directory on $PATH. Use `:Mason` to manage them.
now_if_args(function()
  add({ 'https://github.com/mason-org/mason.nvim' })
  require('mason').setup()
end)

now_if_args(function()
  add({ 'https://github.com/neovim/nvim-lspconfig' })

  -- Use `:h vim.lsp.enable()` to automatically enable language server based on
  -- the rules provided by 'nvim-lspconfig'.
  -- Use `:h vim.lsp.config()` or 'after/lsp/' directory to configure servers.
  -- Server tweaks: 'after/lsp/clangd.lua', 'after/lsp/emmet_language_server.lua'
  vim.lsp.enable({
    'lua_ls',
    'html',
    'cssls',
    'clangd', -- also runs clang-tidy when the project has '.clang-tidy'
    'ts_ls',
    'intelephense',
    'emmet_language_server',
    'eslint',
  })
end)

-- Extra clangd features: AST, symbol info, type hierarchy (`<Leader>c`)
later(function()
  add({ 'https://github.com/p00f/clangd_extensions.nvim' })
  require('clangd_extensions').setup({})
end)

-- Formatting =================================================================

-- Programs dedicated to text formatting (a.k.a. formatters) are very useful.
-- Neovim has built-in tools for text formatting (see `:h gq` and `:h 'formatprg'`).
-- They can be used to configure external programs, but it might become tedious.
--
-- The 'stevearc/conform.nvim' plugin is a good and maintained solution for easier
-- formatting setup.
later(function()
  add({ 'https://github.com/stevearc/conform.nvim' })

  -- See also:
  -- - `:h Conform`
  -- - `:h conform-options`
  -- - `:h conform-formatters`
  local prettier = { 'prettierd', 'prettier', stop_after_first = true }

  -- A project's own formatter config wins over the editor indent settings
  local has_project_config = function(ctx, names)
    return #vim.fs.find(names, { upward = true, path = ctx.dirname }) > 0
  end
  require('conform').setup({
    default_format_opts = {
      -- Allow formatting from LSP server if no dedicated formatter is available
      lsp_format = 'fallback',
    },
    -- Map of filetype to formatters
    -- Make sure that necessary CLI tool is available
    formatters_by_ft = {
      lua = { 'stylua' },
      c = { 'clang-format' },
      cpp = { 'clang-format' },
      javascript = prettier,
      typescript = prettier,
      javascriptreact = prettier,
      typescriptreact = prettier,
      html = prettier,
      css = prettier,
      scss = prettier,
      json = prettier,
      php = { 'php_cs_fixer' },
    },
    formatters = {
      -- php-cs-fixer refuses to run on PHP versions newer than it officially supports
      php_cs_fixer = { env = { PHP_CS_FIXER_IGNORE_ENV = '1' } },
      -- Without a project config stylua uses tabs: use spaces with the buffer's width
      stylua = {
        prepend_args = function(_, ctx)
          if has_project_config(ctx, { '.stylua.toml', 'stylua.toml', '.editorconfig' }) then return {} end
          return { '--indent-type', 'Spaces', '--indent-width', tostring(vim.bo[ctx.buf].shiftwidth) }
        end,
      },
      -- Without a '.clang-format' file: LLVM style with the buffer's indent width
      ['clang-format'] = {
        prepend_args = function(_, ctx)
          if has_project_config(ctx, { '.clang-format', '_clang-format' }) then return {} end
          local width = vim.bo[ctx.buf].shiftwidth
          return { '--style={BasedOnStyle: LLVM, IndentWidth: ' .. width .. ', UseTab: Never}' }
        end,
      },
    },
    -- Format on save. php-cs-fixer boots PHP on every run and often needs >500ms
    format_on_save = function(buf_id)
      local slow = { php = 3000 }
      return { timeout_ms = slow[vim.bo[buf_id].filetype] or 500, lsp_format = 'fallback' }
    end,
  })
end)

-- Linting ====================================================================

-- Linters that aren't language servers. eslint is handled by the eslint server
-- and clang-tidy by clangd. A linter only runs when its executable is found
-- (stylelint also needs a config file in the project).
later(function()
  add({ 'https://github.com/mfussenegger/nvim-lint' })
  local lint = require('lint')

  lint.linters_by_ft = {
    php = { 'phpstan' },
    css = { 'stylelint' },
    scss = { 'stylelint' },
  }

  local stylelint_configs = {
    '.stylelintrc', '.stylelintrc.json', '.stylelintrc.yml', '.stylelintrc.yaml',
    '.stylelintrc.js', '.stylelintrc.cjs',
    'stylelint.config.js', 'stylelint.config.cjs', 'stylelint.config.mjs',
  }

  local available_linters = function(buf_id)
    local names = {}
    for _, name in ipairs(lint.linters_by_ft[vim.bo[buf_id].filetype] or {}) do
      local linter = lint.linters[name]
      local cmd = type(linter) == 'table' and linter.cmd or name
      if type(cmd) == 'function' then cmd = cmd() end

      local ok = vim.fn.executable(cmd) == 1
      if ok and name == 'stylelint' then
        local path = vim.api.nvim_buf_get_name(buf_id)
        ok = #vim.fs.find(stylelint_configs, { upward = true, path = path }) > 0
      end
      if ok then table.insert(names, name) end
    end
    return names
  end

  local try_lint = function(ev)
    local names = available_linters(ev.buf)
    if #names > 0 then lint.try_lint(names) end
  end
  local events = { 'BufReadPost', 'BufWritePost', 'InsertLeave' }
  Config.new_autocmd(events, nil, try_lint, 'Lint buffer')

  -- This loads after the first file is read, so lint that one now
  try_lint({ buf = vim.api.nvim_get_current_buf() })
end)

-- Snippets ===================================================================

-- Although 'mini.snippets' provides functionality to manage snippet files, it
-- deliberately doesn't come with those.
--
-- The 'rafamadriz/friendly-snippets' is currently the largest collection of
-- snippet files. They are organized in 'snippets/' directory (mostly) per language.
-- 'mini.snippets' is designed to work with it as seamlessly as possible.
-- See `:h MiniSnippets.gen_loader.from_lang()`.
later(function() add({ 'https://github.com/rafamadriz/friendly-snippets' }) end)

-- Ported from the old config =================================================

-- Gruvbox color scheme (replaces 'minischeme' from 'plugin/30_mini.lua')
Config.now(function()
  add({ 'https://github.com/ellisonleao/gruvbox.nvim' })
  require('gruvbox').setup({ contrast = 'hard' }) -- must come before :colorscheme
  vim.cmd('colorscheme gruvbox')
end)

-- Shared dependency of several plugins below
later(function() add({ 'https://github.com/nvim-lua/plenary.nvim' }) end)

-- Replaced by MINI / built-ins:
-- - trouble.nvim -> 'mini.pick' / 'mini.extra' pickers (`<Leader>f`) and quickfix
-- - flash.nvim   -> 'mini.jump2d' (`<CR>`), 'mini.jump' (`f`/`t`), and built-in
--   tree-sitter selection in Visual mode (`an` / `in` / `]n` / `[n`)

-- Doxygen / JSDoc comment generation (`<Leader>cc`)
later(function()
  add({ 'https://github.com/danymat/neogen' })
  require('neogen').setup({ snippet_engine = 'mini' })
end)

-- LazyGit in a floating window (`<Leader>gg`). Needs the `lazygit` executable.
later(function() add({ 'https://github.com/kdheepak/lazygit.nvim' }) end)

-- CMake: generate / build / run / debug targets (`<Leader>c`)
later(function()
  add({ 'https://github.com/Civitasv/cmake-tools.nvim' })
  require('cmake-tools').setup({})
end)

-- Honorable mentions =========================================================

-- 'mason-org/mason.nvim' (a.k.a. "Mason") is a great tool (package manager) for
-- installing external language servers, formatters, and linters. It provides
-- a unified interface for installing, updating, and deleting such programs.
--
-- The caveat is that these programs will be set up to be mostly used inside Neovim.
-- If you need them to work elsewhere, consider using other package managers.
--
-- You can use it like so:
-- now_if_args(function()
--   add({ 'https://github.com/mason-org/mason.nvim' })
--   require('mason').setup()
-- end)

-- Beautiful, usable, well maintained color schemes outside of 'mini.nvim' and
-- have full support of its highlight groups. Use if you don't like 'miniwinter'
-- enabled in 'plugin/30_mini.lua' or other suggested 'mini.hues' based ones.
-- Config.now(function()
--  -- Install only those that you need
--  add({
--    'https://github.com/sainnhe/everforest',
--    'https://github.com/Shatur/neovim-ayu',
--    'https://github.com/ellisonleao/gruvbox.nvim',
--  })
--
--   -- Enable only one
--   vim.cmd('color everforest')
-- end)
