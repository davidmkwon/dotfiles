#!/usr/bin/env bash
# LINUX ONLY. Intended for Datadog workspaces (Debian/Ubuntu).
# Runs on workspace creation after this directory is copied into the workspace.
# Installs developer tooling and symlinks dotfiles into $HOME.
# Do not run this on macOS — use Homebrew separately to bootstrap a new Mac.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() { printf '[install.sh] %s\n' "$*"; }

# ---------------------------------------------------------------------------
# Base packages via apt (build deps + tools brew doesn't need to manage)
# ---------------------------------------------------------------------------
if command -v apt-get >/dev/null 2>&1; then
    log "Installing base apt packages"
    sudo apt-get update -y
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        tmux \
        zsh \
        git \
        curl \
        jq \
        build-essential \
        procps \
        file
else
    log "apt-get not found; skipping apt installation"
fi

# ---------------------------------------------------------------------------
# Homebrew (linuxbrew) for up-to-date neovim / fzf / ripgrep
# (Apt versions on Debian/Ubuntu lag well behind upstream.)
# ---------------------------------------------------------------------------
BREW_PREFIX="/home/linuxbrew/.linuxbrew"
if [ ! -x "$BREW_PREFIX/bin/brew" ]; then
    log "Installing Homebrew (linuxbrew)"
    NONINTERACTIVE=1 /bin/bash -c \
        "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$("$BREW_PREFIX/bin/brew" shellenv)"

log "Installing brew packages"
brew install neovim fzf ripgrep

# ---------------------------------------------------------------------------
# Symlink dotfiles
# ---------------------------------------------------------------------------
link() {
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        mv "$dst" "${dst}.bak.$(date +%s)"
    fi
    ln -sfn "$src" "$dst"
    log "linked $dst -> $src"
}

link "$DOTFILES_DIR/.zshrc"          "$HOME/.zshrc"
link "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
link "$DOTFILES_DIR/nvim"            "$HOME/.config/nvim"

# ---------------------------------------------------------------------------
# vim-plug (used by nvim/init.vim)
# ---------------------------------------------------------------------------
PLUG_VIM="$HOME/.local/share/nvim/site/autoload/plug.vim"
if [ ! -f "$PLUG_VIM" ]; then
    log "Installing vim-plug"
    curl -fLo "$PLUG_VIM" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if command -v nvim >/dev/null 2>&1; then
    log "Running :PlugInstall"
    nvim --headless +PlugInstall +qall || log "PlugInstall reported errors (non-fatal)"
fi

# ---------------------------------------------------------------------------
# tmux plugin manager (referenced by .tmux.conf)
# ---------------------------------------------------------------------------
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
    log "Installing tmux plugin manager"
    git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

log "Done."
