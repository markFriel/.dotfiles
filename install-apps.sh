#!/usr/bin/env bash
# install-apps.sh — developer applications
# Run: bash install-apps.sh

set -euo pipefail

step() { printf "\n\033[1;34m==>\033[0m %s\n" "$1"; }
ok()   { printf "\033[1;32m  ✓\033[0m %s\n" "$1"; }

# ── Terminal ──────────────────────────────────────────────────
step "Ghostty"
brew install --cask ghostty

# ── Editors ───────────────────────────────────────────────────
step "VS Code"
brew install --cask visual-studio-code

step "Cursor (AI editor)"
brew install --cask cursor

step "PyCharm"
brew install --cask pycharm

step "Zed"
brew install --cask zed

step "Obsidian"
brew install --cask obsidian

# ── API / Database ────────────────────────────────────────────
step "Postman"
brew install --cask postman

step "TablePlus"
brew install --cask tableplus

# ── Productivity ──────────────────────────────────────────────
step "1Password"
brew install --cask 1password

step "Rectangle (window management)"
brew install --cask rectangle

step "HyperKey"
brew install --cask hyperkey

# ── Browser ───────────────────────────────────────────────────
step "Zen Browser"
brew install --cask zen-browser

printf "\n\033[1;32mDone!\033[0m\n"
printf "1Password: sign in to your account to sync passwords.\n"
printf "TablePlus: add your database connections.\n"
printf "HyperKey: enable it in System Settings → Privacy & Security → Accessibility.\n"
printf "Rectangle: grant accessibility permissions when prompted.\n"
