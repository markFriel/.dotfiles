#!/usr/bin/env bash
# macos-defaults.sh — sensible macOS defaults for developers
# Run: ./macos-defaults.sh
# Note: some changes require a logout/restart to fully take effect

set -euo pipefail

step() { printf "\n\033[1;34m==>\033[0m %s\n" "$1"; }
ok()   { printf "\033[1;32m  ✓\033[0m %s\n" "$1"; }

# ── Key Repeat ────────────────────────────────────────────────
step "Key repeat"
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10
ok "Key repeat set to fastest"

# ── Spaces ────────────────────────────────────────────────────
step "Spaces"
defaults write com.apple.dock mru-spaces -bool false
ok "Automatic Space reordering disabled"

# ── Text substitution ─────────────────────────────────────────
step "Text substitution"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
ok "Smart quotes, dashes, autocorrect, and auto-capitalisation disabled"

# ── Finder ────────────────────────────────────────────────────
step "Finder"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
ok "Finder: show extensions, path bar, status bar, search current folder"

# ── Dock ──────────────────────────────────────────────────────
step "Dock"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock show-recents -bool false
ok "Dock: autohide with no delay, no recent apps"

# ── Screenshots ───────────────────────────────────────────────
step "Screenshots"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true
ok "Screenshots: PNG format, no drop shadow"

# ── Apply changes ─────────────────────────────────────────────
step "Applying changes"
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
ok "Dock and Finder restarted"

printf "\n\033[1;32mDone!\033[0m\n"
printf "Key repeat changes take effect for new apps — log out and back in\n"
printf "to apply everywhere.\n"
