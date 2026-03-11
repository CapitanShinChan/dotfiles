#!/usr/bin/env bash
# =============================================================================
# Bootstrap script — installs tools and symlinks dotfiles
# Run this on a fresh WSL Ubuntu installation
# =============================================================================

set -e  # exit immediately if any command fails
set -o pipefail  # catch errors in piped commands

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "========================================"
echo " Dotfiles Bootstrap"
echo "========================================"

# -----------------------------------------------------------------------------
# Helper functions
# -----------------------------------------------------------------------------

# prints a section header to make output readable
section() {
    echo ""
    echo ">>> $1"
    echo "----------------------------------------"
}

# creates a symlink, backing up the target if it already exists
symlink() {
    local src="$1"
    local dest="$2"

    # if the destination already exists and is not a symlink, back it up
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        echo "  Backing up existing $dest to $dest.bak"
        mv "$dest" "$dest.bak"
    fi

    # creates the symlink, -f overwrites existing symlinks, -s creates a symbolic link
    ln -sf "$src" "$dest"
    echo "  Linked $src → $dest"
}

# -----------------------------------------------------------------------------
# System packages
# -----------------------------------------------------------------------------
section "Installing system packages"

# apt update refreshes the package list; apt install -y installs without prompting
sudo apt update && sudo apt install -y \
    build-essential \
    git \
    curl \
    wget \
    ripgrep \
    unzip \
    zsh \
    fzf \
    neovim

# -----------------------------------------------------------------------------
# Zsh as default shell
# -----------------------------------------------------------------------------
section "Setting zsh as default shell"

# chsh -s changes the login shell; which zsh resolves the full path to zsh
chsh -s $(which zsh)

# -----------------------------------------------------------------------------
# Rust
# -----------------------------------------------------------------------------
section "Installing Rust via rustup"

if ! command -v rustc &> /dev/null; then
    # -y skips the confirmation prompt; --no-modify-path prevents rustup editing .bashrc
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    echo "  Rust installed"
else
    echo "  Rust already installed, skipping"
fi

# -----------------------------------------------------------------------------
# Go
# -----------------------------------------------------------------------------
section "Installing Go"

GO_VERSION="1.24.1"

if ! command -v go &> /dev/null; then
    # downloads the Go tarball and extracts it to /usr/local
    wget -q "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
    sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz"
    rm "go${GO_VERSION}.linux-amd64.tar.gz"
    echo "  Go ${GO_VERSION} installed"
else
    echo "  Go already installed, skipping"
fi

# -----------------------------------------------------------------------------
# Python via pyenv
# -----------------------------------------------------------------------------
section "Installing pyenv and Python"

if [ ! -d "$HOME/.pyenv" ]; then
    # runs the official pyenv installer script
    curl https://pyenv.run | bash
    echo "  pyenv installed"
else
    echo "  pyenv already installed, skipping"
fi

# loads pyenv into the current shell session so we can use it immediately
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

PYTHON_VERSION="3.13.2"
if ! pyenv versions | grep -q "$PYTHON_VERSION"; then
    pyenv install "$PYTHON_VERSION"
    pyenv global "$PYTHON_VERSION"
    echo "  Python ${PYTHON_VERSION} set as global"
else
    echo "  Python ${PYTHON_VERSION} already installed, skipping"
fi

# -----------------------------------------------------------------------------
# Starship prompt
# -----------------------------------------------------------------------------
section "Installing Starship"

if ! command -v starship &> /dev/null; then
    # -y skips the confirmation prompt during starship installation
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    echo "  Starship installed"
else
    echo "  Starship already installed, skipping"
fi

# -----------------------------------------------------------------------------
# vivid for LS_COLORS
# -----------------------------------------------------------------------------
section "Installing vivid"

if ! command -v vivid &> /dev/null; then
    # cargo install builds vivid from the latest source on GitHub
    "$HOME/.cargo/bin/cargo" install --git https://github.com/sharkdp/vivid
    echo "  vivid installed"
else
    echo "  vivid already installed, skipping"
fi

# -----------------------------------------------------------------------------
# Claude Code
# -----------------------------------------------------------------------------
section "Installing Claude Code"

if ! command -v claude &> /dev/null; then
    curl -fsSL https://claude.ai/install.sh | bash
    echo "  Claude Code installed"
else
    echo "  Claude Code already installed, skipping"
fi

# -----------------------------------------------------------------------------
# Neovim undo directory
# -----------------------------------------------------------------------------
section "Creating Neovim undo directory"

# -p prevents errors if the directory already exists
mkdir -p ~/.local/share/nvim/undodir

# -----------------------------------------------------------------------------
# Symlink dotfiles
# -----------------------------------------------------------------------------
section "Symlinking dotfiles"

# zsh config
symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

# starship config
mkdir -p "$HOME/.config/starship"
symlink "$DOTFILES_DIR/config/starship/starship.toml" "$HOME/.config/starship.toml"

# neovim config
mkdir -p "$HOME/.config/nvim"
symlink "$DOTFILES_DIR/config/nvim/init.vim" "$HOME/.config/nvim/init.vim"

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------
echo ""
echo "========================================"
echo " Bootstrap complete!"
echo " Please restart your terminal for all"
echo " changes to take effect."
echo "========================================"
