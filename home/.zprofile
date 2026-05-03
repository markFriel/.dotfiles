# Homebrew (Apple Silicon)
if [[ -x "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# R global dev library — exposed to all renv projects
export RENV_CONFIG_EXTERNAL_LIBRARIES="$HOME/.R/globallib"
