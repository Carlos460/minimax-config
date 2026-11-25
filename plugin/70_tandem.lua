-- tandem: collaborative editing, loaded from a local checkout for testing.
-- To remove: delete this file.
--
-- Commands: :TandemHost, :TandemJoin [ticket], :TandemLeave, :TandemPeers,
-- :TandemFollow [name], :TandemTicket. See the repo README.

local dir = vim.fn.expand("~/code/pair-coding")
if vim.fn.isdirectory(dir) == 0 then
  return
end

vim.opt.rtp:prepend(dir)
vim.cmd.runtime("plugin/tandem.lua")

-- The daemon is found automatically at <dir>/target/release/tandemd
-- (`cargo build --release -p tandemd` in the checkout).
require("tandem").setup({})

-- Show tandem's state in mini.statusline: the default layout plus a tandem
-- section, highlighted as a warning while disconnected.
if _G.MiniStatusline then
  MiniStatusline.config.content.active = function()
    local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
    local git = MiniStatusline.section_git({ trunc_width = 40 })
    local diff = MiniStatusline.section_diff({ trunc_width = 75 })
    local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
    local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
    local filename = MiniStatusline.section_filename({ trunc_width = 140 })
    local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
    local location = MiniStatusline.section_location({ trunc_width = 75 })
    local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
    local tandem = require("tandem").status()
    local tandem_hl = tandem:find("OFFLINE", 1, true) and "DiagnosticVirtualTextWarn" or "MiniStatuslineDevinfo"

    return MiniStatusline.combine_groups({
      { hl = mode_hl, strings = { mode } },
      { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
      "%<",
      { hl = "MiniStatuslineFilename", strings = { filename } },
      "%=",
      { hl = tandem_hl, strings = { tandem } },
      { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
      { hl = mode_hl, strings = { search, location } },
    })
  end
end
