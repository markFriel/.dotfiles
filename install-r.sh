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

# ── R build tools (required for source package compilation) ───
step "R build tools (llvm, libomp, gettext)"
brew install llvm libomp gettext
ok "R build tools installed"

# ── R 4.5.0 from CRAN ────────────────────────────────────────
# Pinned to 4.5.0 — vscDebugger does not yet compile against R 4.6.0
step "R 4.5.0"
curl -fsSL "https://cran.r-project.org/bin/macosx/big-sur-arm64/base/R-4.5.0-arm64.pkg" \
  -o /tmp/R-4.5.0.pkg
sudo installer -pkg /tmp/R-4.5.0.pkg -target /
rm -f /tmp/R-4.5.0.pkg
ok "R 4.5.0 installed"

# ── radian (modern R console) ─────────────────────────────────
step "radian (modern R REPL)"
uv tool install radian
ok "radian installed — replaces base R console"

# ── R packages (base) ─────────────────────────────────────────
step "R packages (base)"
Rscript -e 'install.packages(c("pak", "renv", "languageserversetup"), repos = "https://cloud.r-project.org")'
ok "Base R packages installed"

# ── languageserver isolated install ───────────────────────────
# languageserversetup creates an isolated library that is visible in all
# renv projects — r.libPaths in settings.json is a known broken setting
step "languageserver isolated install"
Rscript -e 'languageserversetup::languageserver_install()'
ok "languageserver installed to isolated library"

# ── Global dev library ────────────────────────────────────────
step "Global dev library (~/.R/globallib)"
mkdir -p "$HOME/.R/globallib"
Rscript -e '
  globallib <- path.expand("~/.R/globallib")
  install.packages("pak", lib = globallib, repos = "https://cloud.r-project.org")
  pkgs <- c(
    "languageserver", "httpgd", "jsonlite", "rlang",
    "ManuelHentschel/vscDebugger", "devtools", "usethis",
    "roxygen2", "testthat", "lintr", "styler"
  )
  for (pkg in pkgs) {
    tryCatch(
      pak::pak(pkg, lib = globallib),
      error = function(e) message("Skipping ", pkg, ": ", conditionMessage(e))
    )
  }
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
