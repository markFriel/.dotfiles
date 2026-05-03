#!/usr/bin/env bash
# install-dev.sh — developer tools setup
# Run: bash install-dev.sh

set -euo pipefail

export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"

step() { printf "\n\033[1;34m==>\033[0m %s\n" "$1"; }
ok()   { printf "\033[1;32m  ✓\033[0m %s\n" "$1"; }

# ── Node LTS via mise ─────────────────────────────────────────
step "Node LTS (via mise)"
mise use -g node@lts
ok "Node LTS installed"

# ── Claude Code ───────────────────────────────────────────────
step "Claude Code"
npm install -g @anthropic-ai/claude-code

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
wt config shell install
ok "Worktrunk installed"

# ── Python toolchain ──────────────────────────────────────────
step "uv (Python package manager)"
curl -LsSf https://astral.sh/uv/install.sh | sh

step "ruff (Python linter/formatter)"
uv tool install ruff

step "ty (Python type checker)"
uv tool install ty

step "prek (fast git hooks manager, pre-commit replacement)"
uv tool install prek

printf "\n\033[1;32mDone!\033[0m\n"
printf "OrbStack: open it from Applications to complete setup.\n"
printf "Claude Code: run 'claude' to authenticate.\n"
printf "gh: run 'gh auth login' to authenticate.\n"
printf "aws: run 'aws configure' to set credentials.\n"
printf "az: run 'az login' to authenticate.\n"
