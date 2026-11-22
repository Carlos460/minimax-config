# Usage — development key reference

Quick reference for the mappings most useful while writing code. `<Leader>` is
`<Space>`. Press `<Space>` (or `g`, `[`, `]`, `s`, `\`, `z`, `<C-w>`) and wait to
see every available mapping in the 'mini.clue' popup.

## Find (mini.pick)

| Key | Action |
|---|---|
| `<Space>ff` | Files |
| `<Space>fg` | Live grep |
| `<Space>fG` | Grep word under cursor |
| `<Space>fb` | Buffers |
| `<Space>fl` / `fL` | Lines in all buffers / current buffer |
| `<Space>fs` / `fS` | LSP symbols: workspace / document |
| `<Space>fR` | LSP references |
| `<Space>fd` / `fD` | Diagnostics: workspace / buffer |
| `<Space>ft` | TODO / FIXME / HACK / NOTE in the project |
| `<Space>fh` | Help tags |
| `<Space>fr` | Resume last picker |

Inside a picker: type to filter, `<C-n>`/`<C-p>` to move, `<Tab>` to preview,
`<CR>` to choose, `<Esc>` to close.

## Files and buffers

| Key | Action |
|---|---|
| `<Space>ed` | File explorer at the current directory |
| `<Space>ef` | File explorer at the current file |
| `[b` / `]b` | Previous / next buffer |
| `<Space>ba` | Alternate buffer |
| `<Space>bd` | Delete buffer |
| `<C-h/j/k/l>` | Move between windows |
| `<C-s>` | Save |

In the explorer: `l` to open, `h` to go up, edit the listing to create, rename or
delete files, then `=` to apply. `g?` shows all keys.

## LSP

| Key | Action |
|---|---|
| `K` / `<Space>lh` | Hover documentation |
| `<Space>ls` | Go to definition |
| `<Space>lt` | Go to type definition |
| `<Space>li` | Go to implementation |
| `<Space>lR` | References (quickfix) |
| `<Space>lr` | Rename |
| `<Space>la` | Code actions |
| `<Space>lf` | Format (buffer, or selection in Visual mode). Also runs on save |
| `<Space>ld` | Diagnostic popup |
| `[d` / `]d` | Previous / next diagnostic |
| `<Space>ih` | Toggle inlay hints |

## Completion and snippets

| Key | Action |
|---|---|
| `<Tab>` / `<S-Tab>` | Next / previous completion item |
| `<CR>` | Accept item |
| `<C-Space>` | Trigger completion |
| `<C-j>` | Expand snippet |
| `<C-l>` / `<C-h>` | Next / previous snippet placeholder |

## Trouble lists

| Key | Action |
|---|---|
| `<Space>xx` / `xX` | Diagnostics: buffer / workspace |
| `<Space>xs` | Document symbols |
| `<Space>xr` | LSP references / definitions |
| `<Space>xq` | Quickfix list |

## C / C++

| Key | Action |
|---|---|
| `<Space>ch` | Switch source / header |
| `<Space>ci` | clangd symbol info |
| `<Space>cH` | clangd type hierarchy |
| `<Space>cA` | clangd AST (Normal or Visual) |
| `<Space>cc` | Generate Doxygen comment |
| `<Space>k` | Man page for word under cursor (sections 2, 3 first) |

### Build and run

| Key | Action |
|---|---|
| `<Space>rk` | `make` in the background; errors go to quickfix / Trouble |
| `<Space>rc` | `make clean` |
| `<Space>rm` | `make` with arguments |
| `<Space>rv` | Run a program under valgrind (C/C++ buffers) |
| `<Space>cg` | CMake generate |
| `<Space>cb` | CMake build |
| `<Space>cr` | CMake run target |
| `<Space>cd` | CMake debug target |
| `<Space>ct` / `cv` | CMake select launch target / build type |
| `[q` / `]q` | Previous / next quickfix item |
| `<Space>eq` | Toggle quickfix list |

### Debug (nvim-dap + codelldb)

| Key | Action |
|---|---|
| `<F5>` | Start / continue (pick: launch executable, attach, launch from script) |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<Space>db` | Toggle breakpoint |
| `<Space>dB` | Conditional breakpoint |
| `<Space>dh` | Hover value under cursor |
| `<Space>dr` | Toggle REPL |
| `<Space>du` | Toggle debugger UI |
| `<Space>dl` | Run last configuration |
| `<Space>dt` | Terminate |

"Launch from script" asks for a shell script that runs your program (for
example one ending in `gdb --args ./app --flag`) and debugs that command.

## Git

| Key | Action |
|---|---|
| `<Space>gg` | LazyGit |
| `[h` / `]h` | Previous / next hunk |
| `gh` / `gH` | Apply (stage) / reset hunk (operator: `ghgh` for one hunk) |
| `<Space>go` | Toggle diff overlay |
| `<Space>gd` / `gD` | Diff: all / buffer |
| `<Space>gc` | Commit |
| `<Space>gl` / `gL` | Log: all / buffer |
| `<Space>gs` | Show commit info at cursor |
| `[x` / `]x` | Previous / next merge-conflict marker |

## Moving around

| Key | Action |
|---|---|
| `S` | Flash jump to any visible location |
| `<M-s>` | Flash select a tree-sitter node |
| `<CR>` | 'mini.jump2d' jump |
| `f`/`t` then `;` | Jump to character, `;` repeats |
| `[e` | Jump to the enclosing function / block (treesitter context) |
| `<Space>oc` | Toggle the sticky context header |
| `[t` / `]t` | Previous / next tree-sitter node |
| `[i` / `]i` | Top / bottom of indent scope |
| `[c` / `]c` | Previous / next comment |

## Editing

| Key | Action |
|---|---|
| `gcc` / `gc{motion}` | Toggle comment |
| `sa{motion}{char}` | Add surrounding (e.g. `saiw"`) |
| `sd{char}` / `sr{old}{new}` | Delete / replace surrounding |
| `ci(`, `daf`, `vaF`, ... | Text objects ('mini.ai'; `F` is function, `a` argument) |
| `gS` | Split / join arguments over lines |
| `(` / `)` | Swap argument left / right |
| `<M-h/j/k/l>` | Move line or selection |
| `gr{motion}` | Replace with register |
| `gx{motion}` | Exchange (use twice) |
| `gs{motion}` | Sort |
| `ga` / `gA` | Align (with preview) |
| `gy` / `gp` | Copy to / paste from system clipboard |
| `jk` | Leave Insert mode |
| `<Space>ot` | Trim trailing whitespace |

## Toggles (`\`)

| Key | Action |
|---|---|
| `\d` | Diagnostics |
| `\w` | Line wrap |
| `\h` | Search highlight |
| `\r` | Relative numbers |
| `\s` | Spell check |

## Other

| Key | Action |
|---|---|
| `<Space>tt` / `tT` | Terminal: vertical / horizontal split |
| `<Space>oz` | Zoom current window |
| `<Space>sn` / `sr` | Write / read a session |
| `<Space>en` | Notification history |
| `<Space>ek` / `ep` | Edit keymaps / plugins config |
| `:Mason` | Install language servers, formatters, linters, codelldb |
