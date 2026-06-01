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
if ! command -v npm &>/dev/null; then
  printf "npm not found — run install-dev.sh first, then re-run this script.\n"
  exit 1
fi
npm install -g @mariozechner/pi-coding-agent
ok "pi coding agent installed"

# ── Pull model ────────────────────────────────────────────────
# Gemma 4 31B — Google's latest model, Q4 fits comfortably in 48GB
step "Pulling gemma4:31b (large download — grab a coffee)"

# Start Ollama only if it isn't already running
OLLAMA_PID=""
if ! ollama list &>/dev/null 2>&1; then
  ollama serve &
  OLLAMA_PID=$!
  printf "Waiting for Ollama to start..."
  for i in $(seq 1 60); do
    if ollama list &>/dev/null 2>&1; then
      printf " ready\n"
      break
    fi
    if [[ $i -eq 60 ]]; then
      printf "\nOllama did not start in time. Try running manually: ollama serve\n"
      kill "$OLLAMA_PID" 2>/dev/null || true
      exit 1
    fi
    sleep 1
  done
fi

ollama pull gemma4:31b
[[ -n "$OLLAMA_PID" ]] && kill "$OLLAMA_PID" 2>/dev/null || true
ok "gemma4:31b ready"

printf "\n\033[1;32mDone!\033[0m\n\n"
printf "Start Ollama:     ollama serve\n"
printf "Test the model:   ollama run gemma4:31b\n"
printf "Chat UI:          open Msty from Applications\n"
printf "Coding agent:     pi (run from any project directory)\n"
printf "\nMLX acceleration is active via OLLAMA_USE_MLX=1 in ~/.zshrc\n"
