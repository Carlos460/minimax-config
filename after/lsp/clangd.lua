-- clangd settings ported from the old config. Merged on top of the defaults
-- from 'nvim-lspconfig'. See `:h vim.lsp.config()`.
return {
  cmd = {
    'clangd',
    '--background-index',
    '--clang-tidy', -- runs clang-tidy when a '.clang-tidy' file is found
    '--header-insertion=iwyu',
    '--completion-style=detailed',
    '--function-arg-placeholders=1',
  },
}
