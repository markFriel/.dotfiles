# dotfiles

Shell environment and developer tools setup for macOS (Apple Silicon).

## Quick Start

### On a fresh machine (no git required)

**Step 1 — Install Xcode Command Line Tools**

This is required by Homebrew and must be done first. A dialog will appear —
click Install and wait for it to complete before continuing.

```bash
xcode-select --install
```

**Step 2 — Download and run setup**

```bash
mkdir -p ~/Documents/dotfiles && \
  curl -fsSL https://github.com/markFriel/.dotfiles/archive/refs/heads/master.tar.gz \
  | tar -xz --strip-components=1 -C ~/Documents/dotfiles && \
  ~/Documents/dotfiles/setup.sh
```

This uses only `curl` — no git, no SSH keys, no GitHub account needed on the
new machine. Homebrew (and git) are installed as part of `setup.sh`.

### On a machine with git already

```bash
./setup.sh
```

Or run scripts individually in order:
```bash
./install.sh       # shell environment — fonts, CLI tools, config symlinks
./install-dev.sh   # developer tools — Node, Docker, CLIs, Python toolchain
./install-apps.sh  # applications — editors, browser, productivity apps
./install-llm.sh   # local LLM — Ollama, Qwen3-Coder-Next, oh-my-pi, Msty
```

Then open a new terminal and run:
```bash
./post-install.sh  # interactive — CLI auth and shell integration
```

---

## What Gets Installed

### install.sh — Shell Environment

| Tool | Purpose |
|------|---------|
| JetBrains Mono Nerd Font | Terminal font option |
| Monaspace Nerd Font | Terminal font (5 variants — Neon is the default) |
| antidote | Zsh plugin manager |
| zsh-autosuggestions | Fish-style command suggestions from history |
| zsh-syntax-highlighting | Command syntax highlighting |
| zsh-completions | Additional zsh completions |
| eza | Modern `ls` replacement with icons, colours, grid layout |
| starship | Cross-shell prompt |
| fzf | Fuzzy finder — powers Ctrl+R, Ctrl+T, Alt+C |
| zoxide | Smart `cd` that learns your most visited directories |
| yazi | Terminal file manager with file/image/PDF previews |
| fd | Fast `find` replacement |
| ripgrep | Fast `grep` replacement |
| bat | `cat` with syntax highlighting |
| btop | System monitor |
| lazygit | Terminal UI for git |
| jq | JSON processor |

### install-dev.sh — Developer Tools

| Tool | Purpose |
|------|---------|
| Node (via Homebrew) | JavaScript runtime |
| Python 3.13 + 3.14 (via uv) | Python runtimes — `python3` defaults to 3.14 |
| Claude Code | Anthropic AI CLI |
| Zellij | Terminal multiplexer — persistent sessions and layouts |
| OrbStack | Docker runtime — faster than Docker Desktop on Apple Silicon |
| AWS CLI | Amazon Web Services CLI |
| Azure CLI | Microsoft Azure CLI |
| GitHub CLI | GitHub CLI |
| Neovim | Terminal text editor |
| uv | Fast Python package and project manager |
| ruff | Fast Python linter and formatter (replaces flake8, isort, black) |
| ty | Python type checker (Astral) |
| prek | Fast git hooks manager — Rust-based pre-commit replacement |
| Worktrunk | Git worktree manager — create, switch, and delete worktrees with `wt` |

### install-llm.sh — Local LLM (optional, M5 Pro optimised)

| Tool | Purpose |
|------|---------|
| Ollama | Local LLM server with MLX backend (Apple Silicon optimised) |
| Qwen3-Coder-Next | Best open source coding model — 58.7% SWE-bench |
| oh-my-pi | Terminal coding agent with LSP, subagents, browser control |
| Msty | Native Mac chat UI, MLX-native, zero setup |

> Model pulls Q4_K_M by default (~20GB). On 48GB RAM upgrade to `q6_K` or `q8_0` for better code quality. MLX acceleration enabled via `OLLAMA_USE_MLX=1` in `.zshrc`.

### install-apps.sh — Applications

| App | Purpose |
|-----|---------|
| Ghostty | Terminal — native macOS, Kitty graphics protocol, Catppuccin Mocha theme |
| VS Code | Editor |
| Cursor | AI-powered editor (VS Code fork) |
| PyCharm | Python IDE |
| Zed | Fast Rust-based code editor |
| Obsidian | Markdown note-taking and knowledge base |
| Postman | API client |
| TablePlus | Database GUI — Postgres, MySQL, SQLite, Redis and more |
| 1Password | Password manager |
| Rectangle | Window snapping and management |
| HyperKey | Remaps Caps Lock to Hyper key (Cmd+Ctrl+Option+Shift) |
| Zen Browser | Firefox-based privacy browser |

---

## Step by Step Install

### 1. Place the dotfiles folder

Use the bootstrap command above, or clone manually. The install scripts use
absolute symlinks so the folder location matters — do not move it after
running the scripts.

### 2. Shell environment

```bash
./install.sh
```

Installs all shell tools and creates the following symlinks:

| Symlink | Source |
|---------|--------|
| `~/.zshrc` | `dotfiles/home/.zshrc` |
| `~/.zsh_plugins.txt` | `dotfiles/home/.zsh_plugins.txt` |
| `~/.gitconfig` | `dotfiles/home/.gitconfig` |
| `~/.gitignore_global` | `dotfiles/home/.gitignore_global` |
| `~/.config/starship.toml` | `dotfiles/config/starship.toml` |
| `~/.config/yazi/yazi.toml` | `dotfiles/config/yazi/yazi.toml` |
| `~/.config/ghostty/config` | `dotfiles/config/ghostty/config` |

### 3. Developer tools

```bash
./install-dev.sh
```

### 4. Applications

```bash
./install-apps.sh
```

### 5. Open OrbStack

Open OrbStack from Applications to complete its initial setup. The `docker`
command becomes available after first launch.

### 6. Grant accessibility permissions

Both Rectangle and HyperKey require accessibility access:

**System Settings → Privacy & Security → Accessibility**

Enable both apps when prompted, or add them manually.

### 7. Post-install (auth + shell integration)

Open a new terminal, then run:

```bash
./post-install.sh
```

This handles: Worktrunk shell integration, `gh auth login`, `aws configure`,
`az login`, and Claude Code authentication — in order.

### 8. Open a new terminal

Open Ghostty. Icons and grid layout in `ls` require the Nerd Font — the
Ghostty config already sets **MonaspiceNeNerdFont** (Monaspace Neon).

---

## Managing the Setup

### Adding a zsh plugin

Add a line to `dotfiles/home/.zsh_plugins.txt`:

```
zsh-users/zsh-autosuggestions
zsh-users/zsh-syntax-highlighting
zsh-users/zsh-completions
your-org/new-plugin
```

Open a new terminal or run `antidote load` to activate.

### Configuring the prompt

Edit `dotfiles/config/starship.toml`. The package version module is disabled by default.

```bash
starship preset --list    # browse built-in presets
starship explain          # see what each segment in your prompt does
```

### Configuring Ghostty

Edit `dotfiles/config/ghostty/config`. Changes take effect on next window open.

### Configuring yazi

Edit `dotfiles/config/yazi/yazi.toml`. Additional config files go in the same folder:
- `keymap.toml` — custom keybindings
- `theme.toml` — colours

### Python workflow (uv)

```bash
uv init my-project        # create a new project
uv add requests           # add a dependency
uv run script.py          # run a script in the project environment
uv tool install <pkg>     # install a global CLI tool
```

---

## Key Bindings

| Binding | Action |
|---------|--------|
| `Ctrl+R` | Fuzzy search command history (fzf) |
| `Ctrl+T` | Fuzzy find a file and paste the path (fzf) |
| `Alt+C` | Fuzzy find a directory and cd into it (fzf) |
| `cdi` | Interactive zoxide directory picker |
| `y` | Open yazi file manager (terminal CWD follows on exit) |
| `q` | Quit yazi |

---

## Aliases

### eza — ls replacement

| Alias | Command |
|-------|---------|
| `ls` | Grid view with icons, directories first |
| `ll` | Long format with icons |
| `la` | Long format including hidden files |
| `lt` | Tree view |

### General

| Alias | Command |
|-------|---------|
| `cat` | `bat` — syntax highlighted output |
| `lg` | `lazygit` |
