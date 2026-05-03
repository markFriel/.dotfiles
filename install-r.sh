#!/usr/bin/env bash
# install-r.sh — R development environment (VS Code workflow)
# Run: ./install-r.sh

set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"
if [[ -x "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

step() { printf "\n\033[1;34m==>\033[0m %s\n" "$1"; }
ok()   { printf "\033[1;32m  ✓\033[0m %s\n" "$1"; }

# ── rig (R version manager) ───────────────────────────────────
step "rig (R version manager)"
brew install rig
ok "rig installed"

# ── R (latest release) ────────────────────────────────────────
# sudo -E preserves HOME so rig can find its data directory
step "R (latest release via rig)"
sudo -E rig install release
ok "R installed"

# ── radian (modern R console) ─────────────────────────────────
step "radian (modern R REPL)"
uv tool install radian
ok "radian installed — replaces base R console"

# ── R packages ────────────────────────────────────────────────
step "R packages: languageserver, httpgd, pak, renv"
Rscript -e 'install.packages(c("languageserver", "httpgd", "pak", "renv"), repos = "https://cloud.r-project.org")'
ok "R packages installed"

# ── Global dev library ────────────────────────────────────────
# Packages here are exposed to every renv project via RENV_CONFIG_EXTERNAL_LIBRARIES
# in ~/.Rprofile — dev tools live here so they never need to be in renv.lock
step "Global dev library (~/.R/globallib)"
mkdir -p "$HOME/.R/globallib"
Rscript -e '
  globallib <- path.expand("~/.R/globallib")
  install.packages("pak", lib = globallib, repos = "https://cloud.r-project.org")
  pak::pak(
    c("ManuelHentschel/vscDebugger", "devtools", "usethis", "roxygen2",
      "testthat", "lintr", "styler"),
    lib = globallib
  )
'
ok "Global dev tools installed to ~/.R/globallib"

# ── VS Code R extensions ──────────────────────────────────────
step "VS Code / Cursor R extensions"
for editor in code cursor; do
  if command -v "$editor" &>/dev/null; then
    "$editor" --install-extension REditorSupport.r
    "$editor" --install-extension RDebugger.r-debugger
    ok "$editor extensions installed"
  fi
done

printf "\n\033[1;32mDone!\033[0m\n"
printf "Open a new R session with: radian\n"
printf "In VS Code/Cursor: Cmd+Shift+P → 'R: Create R Terminal'\n"
