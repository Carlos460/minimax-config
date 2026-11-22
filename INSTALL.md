# Install

How to set up this Neovim config on a new machine.

## Before you start

You need these installed first:

- **Neovim 0.13 (nightly)**: the stable release will not work
- **git**
- **C compiler** (`gcc` or `clang`)
- **tree-sitter CLI**: builds the syntax parsers
- **ripgrep** (`rg`): file and text search
- **Node.js + npm**: needed for some language servers
- **curl**, **unzip**, **tar**: used by Mason to download tools
- **lazygit** (optional): Git window on `<Space>gg`
- **Nerd Font** (optional): makes icons look right

Full install steps for each one are in [PREREQ.md](PREREQ.md).

Check Neovim's version:

```bash
nvim --version   # first line should say v0.13.0-dev...
```

## Steps

### 1. Back up your old config

Skip this if you have no old config.

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

### 2. Download the config

```bash
git clone https://github.com/Carlos460/minimax-config.git ~/.config/nvim
cd ~/.config/nvim
git checkout custom-config
```

### 3. Open Neovim

```bash
nvim
```

Plugins install by themselves the first time. Wait for it to finish, then
close and reopen Neovim.

### 4. Install language tools

Inside Neovim, run:

```vim
:MasonInstall lua-language-server stylua clangd clang-format codelldb
```

Add the web tools if you need them:

```vim
:MasonInstall html-lsp css-lsp typescript-language-server eslint-lsp emmet-language-server intelephense
```

To see or install other tools, run `:Mason`.

### 5. Check that it works

```vim
:checkhealth
```

Fix anything marked **ERROR**. **WARNING** items are usually fine.

## Updating

| What | How |
|---|---|
| Config | `git pull` inside `~/.config/nvim` |
| Plugins | `:packupdate`, then `:write` to confirm |
| Language tools | `:Mason`, then press `U` |

## Next

Read [USAGE.md](USAGE.md) for the main keys. Press `<Space>` and wait to see
all available shortcuts.
