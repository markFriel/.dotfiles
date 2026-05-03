# ~/.zshrc

# ============================================================
# Environment
# ============================================================
export EDITOR='nvim'
export OLLAMA_USE_MLX=1
export VISUAL='nvim'
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export HOMEBREW_NO_ENV_HINTS=1

# ============================================================
# History
# ============================================================
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# ============================================================
# Plugins — antidote
# ============================================================
source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
antidote load ${ZDOTDIR:-~}/.zsh_plugins.txt

# ============================================================
# Completions
# ============================================================
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# ============================================================
# zsh-autosuggestions
# ============================================================
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# ============================================================
# Aliases
# ============================================================
alias cat='bat'
alias lg='lazygit'

# ============================================================
# eza — modern ls replacement
# ============================================================
alias ls='eza --icons --group-directories-first --grid'
alias ll='eza --icons --group-directories-first -lh'
alias la='eza --icons --group-directories-first -lAh'
alias lt='eza --icons --tree --group-directories-first'

# ============================================================
# mise — runtime version manager
# ============================================================
eval "$(mise activate zsh)"

# ============================================================
# uv — Python package manager
# ============================================================
command -v uv &>/dev/null && eval "$(uv generate-shell-completion zsh)"

# ============================================================
# fzf — fuzzy finder
# ============================================================
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a"
eval "$(fzf --zsh)"

# ============================================================
# yazi — file manager (y to launch, CWD follows on exit)
# ============================================================
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# ============================================================
# zoxide — smart cd
# ============================================================
eval "$(zoxide init zsh --cmd cd)"

# ============================================================
# Prompt — starship
# ============================================================
eval "$(starship init zsh)"
