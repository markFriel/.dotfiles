#!/usr/bin/env bash
# setup.sh — full machine setup in one command
# Run: bash setup.sh

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

header() { printf "\n\033[1;35m══════════════════════════════════════════\033[0m\n\033[1;35m  %s\033[0m\n\033[1;35m══════════════════════════════════════════\033[0m\n" "$1"; }
ok()     { printf "\033[1;32m  ✓\033[0m %s\n" "$1"; }

# ── Ask upfront before anything runs ─────────────────────────
printf "\n\033[1;37mThis will install:\033[0m\n"
printf "  [1] Shell environment  — fonts, CLI tools, config symlinks\n"
printf "  [2] Developer tools    — Node, Docker, CLIs, Python toolchain\n"
printf "  [3] Applications       — editors, browser, productivity apps\n"
printf "  [4] Local LLM          — Ollama, Qwen3-Coder-Next, oh-my-pi, Msty (~20GB)\n\n"

read -r -p "Include local LLM setup? [y/N] " llm_response
printf "\n"

# ── Preflight: Xcode Command Line Tools ──────────────────────
header "Preflight"
if ! xcode-select -p &>/dev/null; then
  printf "Xcode Command Line Tools are not installed.\n"
  printf "Run the following command, wait for the install to complete,\n"
  printf "then re-run this script:\n\n"
  printf "  xcode-select --install\n\n"
  exit 1
fi
ok "Xcode Command Line Tools present"

# ── Shell environment ─────────────────────────────────────────
header "Shell Environment"
bash "$DOTFILES_DIR/install.sh"

# Ensure Homebrew is in PATH for this session (required on Apple Silicon)
if [[ -x "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ── Developer tools ───────────────────────────────────────────
header "Developer Tools"
bash "$DOTFILES_DIR/install-dev.sh"

# ── Applications ──────────────────────────────────────────────
header "Applications"
bash "$DOTFILES_DIR/install-apps.sh"

# ── Local LLM (optional) ──────────────────────────────────────
if [[ "$llm_response" =~ ^[Yy]$ ]]; then
  header "Local LLM"
  bash "$DOTFILES_DIR/install-llm.sh"
else
  header "Local LLM — Skipped"
  printf "Run 'bash install-llm.sh' any time to set this up.\n"
fi

# ── Done ──────────────────────────────────────────────────────
header "All done!"
printf "\nNext steps:\n"
printf "  1. Open Ghostty from Applications\n"
printf "  2. Open OrbStack from Applications to complete Docker setup\n"
printf "  3. Grant accessibility permissions to Rectangle and HyperKey\n"
printf "     System Settings → Privacy & Security → Accessibility\n"
printf "  4. Authenticate CLIs:\n"
printf "       gh auth login\n"
printf "       aws configure\n"
printf "       az login\n"
printf "       claude\n"
printf "  5. Sign in to 1Password\n"
