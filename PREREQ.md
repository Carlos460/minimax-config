# Prerequisites

Install these before following [INSTALL.md](INSTALL.md).

Pick the commands for your system: **Ubuntu/Debian**, **Arch** or **macOS**.

## 1. Basic tools

git, a C compiler, curl, unzip and tar.

```bash
# Ubuntu / Debian
sudo apt update
sudo apt install git build-essential curl unzip tar

# Arch
sudo pacman -S git base-devel curl unzip tar

# macOS (installs git and the compiler)
xcode-select --install
```

## 2. Neovim 0.13 (nightly)

This config needs the **nightly** version. The normal release is too old.

**Ubuntu / Debian** (also works on any Linux):

```bash
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.bashrc
source ~/.bashrc
```

On an ARM computer, replace `x86_64` with `arm64`. To update later, run the
same commands again.

**Arch** (from the AUR, using `yay`):

```bash
yay -S neovim-nightly-bin
```

**macOS**:

```bash
brew install --HEAD neovim
```

Check it:

```bash
nvim --version   # first line should say v0.13.0-dev...
```

## 3. Node.js and npm

Some language servers and the tree-sitter tool need these. Use version 18 or newer.

```bash
# Ubuntu / Debian
sudo apt install nodejs npm

# Arch
sudo pacman -S nodejs npm

# macOS
brew install node
```

Check it:

```bash
node --version   # v18 or newer
```

## 4. tree-sitter CLI

Builds the parsers that give you syntax colors and code navigation.

```bash
# Ubuntu / Debian (apt version is too old, use npm)
sudo npm install -g tree-sitter-cli

# Arch
sudo pacman -S tree-sitter-cli

# macOS
brew install tree-sitter-cli
```

Check it:

```bash
tree-sitter --version
```

## 5. ripgrep

Powers file search (`<Space>ff`) and text search (`<Space>fg`).

```bash
# Ubuntu / Debian
sudo apt install ripgrep

# Arch
sudo pacman -S ripgrep

# macOS
brew install ripgrep
```

## 6. lazygit (optional)

Opens a Git window with `<Space>gg`.

```bash
# Ubuntu 25.04 or newer / Debian 13 or newer
sudo apt install lazygit

# Arch
sudo pacman -S lazygit

# macOS
brew install lazygit
```

On older Ubuntu, download it from the
[lazygit releases page](https://github.com/jesseduffield/lazygit/releases).

## 7. Nerd Font (optional)

Makes icons show up correctly. Without one, you'll see boxes or question marks.

```bash
# Arch
sudo pacman -S ttf-jetbrains-mono-nerd

# macOS
brew install --cask font-jetbrains-mono-nerd-font
```

On Ubuntu, download a font from [nerdfonts.com](https://www.nerdfonts.com/font-downloads),
unzip it into `~/.local/share/fonts`, then run `fc-cache -f`.

**After installing, set your terminal to use the font.**

## Check everything at once

```bash
for cmd in nvim git cc curl unzip tar node npm tree-sitter rg lazygit; do
  command -v "$cmd" >/dev/null && echo "ok       $cmd" || echo "MISSING  $cmd"
done
```

Everything should say `ok` (except `lazygit` if you skipped it).
Next, go to [INSTALL.md](INSTALL.md).
