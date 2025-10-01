# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository for Linux systems. Modular configuration setup using symlinks and machine-specific overrides.

## Installation & Management

Uses GNU Make with symlink-based deployment:

```bash
# Install specific configs
make zsh      # Install zsh config
make vim      # Install vim config
make nvim     # Install neovim config
make git      # Install git config
make tmux     # Install tmux config
```

## Architecture

### ZSH Configuration
- Entry point: `zsh/zshrc` sources all `.zsh` files in `zsh/zshrc.d/` (numbered for load order)
- Machine-specific: `zsh/zshrc.local` (git-ignored)
- Numbered config files control load order (00-99)

### Vim/Neovim
- Shared vimrc: `vim/vimrc`
- Neovim: `init.vim` (thin wrapper)
- Uses vim-plug for plugin management (auto-installs on first run)
- Machine-specific: `~/.vim/vimrc.local` (git-ignored)

### Build System
- Git config and mpv config use `install` instead of symlinks (copied, not linked)
- All other configs symlink to dotfiles directory
- Uses `DOTPATH` variable (defaults to `.dotfiles`)
