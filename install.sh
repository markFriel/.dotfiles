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
fi
if [[ -x "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
ok "Homebrew ready"

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

step "bat, btop, lazygit, jq"
brew install bat btop lazygit jq

# ── Symlinks — home/ → ~/  ────────────────────────────────────
step "Symlinking home files"
for src in "$DOTFILES_DIR/home"/.[^.]*; do
  filename="$(basename "$src")"
  dest="$HOME/$filename"
  if [[ -f "$dest" && ! -L "$dest" ]]; then
    mv "$dest" "$dest.backup.$(date +%Y%m%d_%H%M%S)"
  fi
  ln -sf "$src" "$dest"
  ok "Linked ~/$filename → $src"
done

# ── Symlinks — config/ → ~/.config/  ─────────────────────────
step "Symlinking config files"
mkdir -p "$HOME/.config"

# starship.toml sits directly in config/
ln -sf "$DOTFILES_DIR/config/starship.toml" "$HOME/.config/starship.toml"
ok "Linked ~/.config/starship.toml → $DOTFILES_DIR/config/starship.toml"

# tool subdirectories
for src in "$DOTFILES_DIR/config"/*/; do
  dir_name="$(basename "$src")"
  mkdir -p "$HOME/.config/$dir_name"
  for file in "$src"*; do
    filename="$(basename "$file")"
    ln -sf "$file" "$HOME/.config/$dir_name/$filename"
    ok "Linked ~/.config/$dir_name/$filename → $file"
  done
done

printf "\n\033[1;32mDone!\033[0m Restart your terminal or run: source ~/.zshrc\n"
