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

# ── VS Code R extension ───────────────────────────────────────
step "VS Code / Cursor R extension"
if command -v code &>/dev/null; then
  code --install-extension REditorSupport.r
  ok "VS Code R extension installed"
fi
if command -v cursor &>/dev/null; then
  cursor --install-extension REditorSupport.r
  ok "Cursor R extension installed"
fi

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
