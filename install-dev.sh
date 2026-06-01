#!/usr/bin/env bash
# install-dev.sh — developer tools setup
# Run: bash install-dev.sh

set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"

step() { printf "\n\033[1;34m==>\033[0m %s\n" "$1"; }
ok()   { printf "\033[1;32m  ✓\033[0m %s\n" "$1"; }

# ── Node ──────────────────────────────────────────────────────
step "Node (via Homebrew)"
brew install node
ok "Node installed"

# ── Claude Code ───────────────────────────────────────────────
step "Claude Code"
npm install -g @anthropic-ai/claude-code

# ── Python (via uv) ───────────────────────────────────────────
step "uv (Python package manager)"
curl -LsSf https://astral.sh/uv/install.sh | sh

step "Python 3.13 + 3.14 (via uv)"
uv python install 3.13 3.14
ok "Python 3.13 and 3.14 installed"

# ── Terminal multiplexer ──────────────────────────────────────
step "Zellij"
brew install zellij

# ── OrbStack (Docker) ─────────────────────────────────────────
step "OrbStack"
brew install --cask orbstack

# ── AWS CLI ───────────────────────────────────────────────────
step "AWS CLI"
brew install awscli

# ── Azure CLI ─────────────────────────────────────────────────
step "Azure CLI"
brew install azure-cli

# ── GitHub CLI ────────────────────────────────────────────────
step "GitHub CLI"
brew install gh

# ── Neovim ───────────────────────────────────────────────────
step "Neovim"
brew install neovim

# ── Git worktree management ───────────────────────────────────
step "Worktrunk (git worktree manager)"
brew install worktrunk
ok "Worktrunk installed"

# ── Python toolchain ──────────────────────────────────────────
step "ruff (Python linter/formatter)"
uv tool install ruff

step "ty (Python type checker)"
uv tool install ty

step "prek (fast git hooks manager, pre-commit replacement)"
uv tool install prek

printf "\n\033[1;32mDone!\033[0m\n"
