#!/usr/bin/env bash
# install-llm.sh — local LLM setup optimised for M5 Pro 48GB
# Run: bash install-llm.sh

set -euo pipefail

step() { printf "\n\033[1;34m==>\033[0m %s\n" "$1"; }
ok()   { printf "\033[1;32m  ✓\033[0m %s\n" "$1"; }

# ── Ollama ────────────────────────────────────────────────────
step "Ollama (local LLM server)"
brew install ollama
ok "Ollama installed"

# ── Msty (chat UI) ────────────────────────────────────────────
step "Msty (chat UI — MLX-native, zero setup)"
brew install --cask msty
ok "Msty installed"

# ── oh-my-pi (terminal coding agent) ─────────────────────────
step "oh-my-pi (AI coding agent)"
npm install -g @mariozechner/pi-coding-agent
ok "pi coding agent installed"

# ── Pull model ────────────────────────────────────────────────
# Qwen3-Coder-Next — best open source coding model for 48GB
# Default tag pulls Q4_K_M (~20GB). For higher quality on 48GB:
#   ollama pull qwen3-coder-next:q6_K   (~28GB, better code output)
#   ollama pull qwen3-coder-next:q8_0   (~38GB, best quality)
step "Pulling Qwen3-Coder-Next (large download — grab a coffee)"
ollama serve &
OLLAMA_PID=$!
sleep 3
ollama pull qwen3-coder-next
kill $OLLAMA_PID 2>/dev/null || true
ok "Qwen3-Coder-Next ready"

printf "\n\033[1;32mDone!\033[0m\n\n"
printf "Start Ollama:     ollama serve\n"
printf "Test the model:   ollama run qwen3-coder-next\n"
printf "Chat UI:          open Msty from Applications\n"
printf "Coding agent:     pi (run from any project directory)\n"
printf "\nMLX acceleration is active via OLLAMA_USE_MLX=1 in ~/.zshrc\n"
printf "For higher quality pulls on 48GB:\n"
printf "  ollama pull qwen3-coder-next:q6_K\n"
printf "  ollama pull qwen3-coder-next:q8_0\n"
