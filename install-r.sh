#!/usr/bin/env bash
# install-r.sh — R development environment (VS Code workflow)
# Run: ./install-r.sh

set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"

step() { printf "\n\033[1;34m==>\033[0m %s\n" "$1"; }
ok()   { printf "\033[1;32m  ✓\033[0m %s\n" "$1"; }

# ── rig (R version manager) ───────────────────────────────────
step "rig (R version manager)"
brew install rig
ok "rig installed"

# ── R (latest release) ────────────────────────────────────────
step "R (latest release via rig)"
rig install release
ok "R $(rig default) installed"

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
  pak::pak("ManuelHentschel/vscDebugger", lib = globallib)
'
ok "vscDebugger installed to ~/.R/globallib"

# ── VS Code R extensions ──────────────────────────────────────
step "VS Code / Cursor R extensions"
for editor in code cursor; do
  if command -v "$editor" &>/dev/null; then
    "$editor" --install-extension REditorSupport.r
    "$editor" --install-extension RDebugger.r-debugger
    ok "$editor extensions installed"
  fi
done

# ── VS Code R settings ────────────────────────────────────────
step "VS Code R settings"
radian_path="$HOME/.local/bin/radian"
r_settings=$(cat <<EOF
{
  "r.rterm.mac": "$radian_path",
  "r.bracketedPaste": true,
  "r.sessionWatcher": true,
  "r.plot.useHttpgd": true
}
EOF
)

for settings_file in \
  "$HOME/Library/Application Support/Code/User/settings.json" \
  "$HOME/Library/Application Support/Cursor/User/settings.json"
do
  if [[ -d "$(dirname "$settings_file")" ]]; then
    if [[ -f "$settings_file" ]]; then
      tmp=$(mktemp)
      jq --argjson new "$r_settings" '. + $new' "$settings_file" > "$tmp" && mv "$tmp" "$settings_file"
    else
      echo "$r_settings" | jq '.' > "$settings_file"
    fi
    ok "R settings written to $(basename "$(dirname "$(dirname "$settings_file")")")"
  fi
done

printf "\n\033[1;32mDone!\033[0m\n"
printf "Open a new R session with: radian\n"
printf "In VS Code/Cursor: Cmd+Shift+P → 'R: Create R Terminal'\n"
