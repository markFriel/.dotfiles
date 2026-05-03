#!/usr/bin/env bash
# post-install.sh — interactive steps that require a live shell session
# Run AFTER setup.sh, in a new terminal window

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

step() { printf "\n\033[1;34m==>\033[0m %s\n" "$1"; }
ok()   { printf "\033[1;32m  ✓\033[0m %s\n" "$1"; }

printf "\n\033[1;37mPost-install setup — follow each prompt in order.\033[0m\n"

# ── VS Code / Cursor settings ─────────────────────────────────
step "VS Code / Cursor settings"
for dir in \
  "$HOME/Library/Application Support/Code/User" \
  "$HOME/Library/Application Support/Cursor/User"
do
  if [[ -d "$dir" ]]; then
    settings="$dir/settings.json"
    if [[ -f "$settings" && ! -L "$settings" ]]; then
      mv "$settings" "$settings.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    ln -sf "$DOTFILES_DIR/config/vscode/settings.json" "$settings"
    ok "Linked settings.json → $(basename "$(dirname "$dir")")"
  fi
done

# ── Worktrunk shell integration ───────────────────────────────
step "Worktrunk shell integration"
wt config shell install
ok "Worktrunk shell integration installed"

# ── GitHub CLI ────────────────────────────────────────────────
step "GitHub CLI authentication"
gh auth login

# ── AWS CLI ───────────────────────────────────────────────────
step "AWS CLI credentials"
aws configure

# ── Azure CLI ─────────────────────────────────────────────────
step "Azure CLI authentication"
az login

# ── Claude Code ───────────────────────────────────────────────
step "Claude Code authentication"
claude

printf "\n\033[1;32mAll done!\033[0m\n"
printf "Open a new terminal window to pick up all shell changes.\n"
