#!/usr/bin/env bash
# install.sh — fresh macOS shell setup
# Run: bash install.sh

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

step() { printf "\n\033[1;34m==>\033[0m %s\n" "$1"; }
ok()   { printf "\033[1;32m  ✓\033[0m %s\n" "$1"; }

# ── Homebrew ─────────────────────────────────────────────────
step "Homebrew"
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  ok "Already installed"
fi

# ── Fonts ────────────────────────────────────────────────────
step "Fonts"
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-monaspice-nerd-font
ok "JetBrains Mono Nerd Font + Monaspace Nerd Font installed"

# ── Tools ────────────────────────────────────────────────────
step "antidote (plugin manager)"
brew install antidote

step "eza (modern ls)"
brew install eza

step "starship (prompt)"
brew install starship

step "fzf (fuzzy finder)"
brew install fzf

step "zoxide (smart cd)"
brew install zoxide

step "yazi (file manager) + preview dependencies"
brew install yazi fd ripgrep imagemagick poppler

step "bat, btop, lazygit, jq, mise"
brew install bat btop lazygit jq mise

# ── Git config ───────────────────────────────────────────────
step "Git config"
if [[ -f "$HOME/.gitconfig" && ! -L "$HOME/.gitconfig" ]]; then
  mv "$HOME/.gitconfig" "$HOME/.gitconfig.backup.$(date +%Y%m%d_%H%M%S)"
fi
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
ok "Linked ~/.gitconfig → $DOTFILES_DIR/.gitconfig"
ln -sf "$DOTFILES_DIR/.gitignore_global" "$HOME/.gitignore_global"
ok "Linked ~/.gitignore_global → $DOTFILES_DIR/.gitignore_global"

# ── .zshrc symlink ───────────────────────────────────────────
step ".zshrc"
if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
  mv "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
fi
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ok "Linked ~/.zshrc → $DOTFILES_DIR/.zshrc"
ln -sf "$DOTFILES_DIR/.zsh_plugins.txt" "$HOME/.zsh_plugins.txt"
ok "Linked ~/.zsh_plugins.txt → $DOTFILES_DIR/.zsh_plugins.txt"
mkdir -p "$HOME/.config/yazi"
ln -sf "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"
ok "Linked ~/.config/starship.toml → $DOTFILES_DIR/starship.toml"
ln -sf "$DOTFILES_DIR/yazi/yazi.toml" "$HOME/.config/yazi/yazi.toml"
ok "Linked ~/.config/yazi/yazi.toml → $DOTFILES_DIR/yazi/yazi.toml"
mkdir -p "$HOME/.config/ghostty"
ln -sf "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"
ok "Linked ~/.config/ghostty/config → $DOTFILES_DIR/ghostty/config"

printf "\n\033[1;32mDone!\033[0m Restart your terminal or run: source ~/.zshrc\n"
