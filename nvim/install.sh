#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"
source ../lib/pkg.sh

# Node.js major version (needed by Copilot and pyright; nvim itself works without it).
# Pin the major version, not the exact patch: security fixes still arrive via apt / brew.
# Bump this when the version reaches end-of-life: https://nodejs.org/en/about/previous-releases
NODE_MAJOR=24

# Minimum Neovim version required by this config (vim.lsp.config / vim.lsp.enable)
NVIM_MIN_VERSION=0.11.0

node_major() { node --version 2>/dev/null | sed -E 's/^v([0-9]+).*/\1/'; }

deploy_config() {
    mkdir -p ~/.config/nvim
    cp -r * ~/.config/nvim/
}

install_macos() {
    if ! have brew; then
        echo "Homebrew is required on macOS: https://brew.sh" >&2
        exit 1
    fi
    # C compiler for building treesitter parsers (clang from Xcode Command Line Tools)
    if ! xcode-select -p >/dev/null 2>&1; then
        echo "Xcode Command Line Tools are required. Run: xcode-select --install" >&2
        exit 1
    fi

    # neovim, python tools
    pkg_install neovim codespell flake8 black isort

    # Node.js (pinned major version; node@N is keg-only, so link it onto PATH)
    if [ "$(node_major)" = "$NODE_MAJOR" ] && ! forced; then
        skip "node $(node --version)"
    else
        pkg_install "node@${NODE_MAJOR}"
        brew link --overwrite --force "node@${NODE_MAJOR}"
    fi

    deploy_config

    # tree-sitter CLI (needed by nvim-treesitter to build parsers)
    if have tree-sitter && ! forced; then
        skip "tree-sitter $(tree-sitter --version | awk '{print $2}')"
    else
        pkg_install tree-sitter-cli || pkg_install tree-sitter || echo "tree-sitter-cli install failed"
    fi
}

install_linux() {
    # ask for the sudo password upfront and keep it cached for the whole script
    sudo -v
    while true; do sudo -n true; sleep 60; kill -0 "$$" 2>/dev/null || exit; done >/dev/null 2>&1 &
    local keepalive_pid=$!
    trap "kill $keepalive_pid 2>/dev/null" EXIT

    # Node.js from NodeSource, installed system-wide to /usr/bin/node so nvim finds
    # the same version no matter which shell / environment it is started from.
    # Ubuntu's own nodejs package is far too old (e.g. v12 on 22.04) and is replaced.
    if [ "$(/usr/bin/node --version 2>/dev/null | sed -E 's/^v([0-9]+).*/\1/')" = "$NODE_MAJOR" ] && ! forced; then
        skip "node $(/usr/bin/node --version)"
    else
        # remove Ubuntu's node packages first; they conflict with NodeSource's nodejs
        old_pkgs=$(dpkg-query -W -f='${binary:Package} ${Status}\n' nodejs npm libnode-dev 'libnode[0-9]*' 2>/dev/null \
            | awk '/install ok installed/ {print $1}')
        [ -n "$old_pkgs" ] && sudo apt-get remove -y $old_pkgs
        curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR}.x" | sudo -E bash -
        sudo apt-get install -y nodejs
        echo "Node.js: $(/usr/bin/node --version)"
    fi

    # cargo and rustc (only used to build tree-sitter-cli below)
    if { have cargo || [ -x "$HOME/.cargo/bin/cargo" ]; } && ! forced; then
        skip "rust/cargo"
    else
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    fi
    [ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

    # dependencies
    pkg_install build-essential codespell flake8 black isort unzip clang libclang-dev llvm-dev

    # neovim (official release tarball in /opt; skipped if the installed one is new enough)
    local nvim_bin=/opt/nvim-linux-x86_64/bin/nvim
    local nvim_ver
    nvim_ver=$("$nvim_bin" --version 2>/dev/null | head -1 | awk '{print $2}')
    if [ -n "$nvim_ver" ] && version_ge "$nvim_ver" "$NVIM_MIN_VERSION" && ! forced; then
        skip "neovim $nvim_ver"
    else
        step "installing neovim (latest release)"
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
        sudo rm -rf /opt/nvim-linux-x86_64
        sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
        rm nvim-linux-x86_64.tar.gz
    fi

    # deploy nvim config first, so a flaky tree-sitter-cli build below can never
    # prevent the editor config from being installed
    deploy_config

    # tree-sitter CLI (needed by nvim-treesitter to build parsers)
    if have tree-sitter && ! forced; then
        skip "tree-sitter $(tree-sitter --version | awk '{print $2}')"
        return 0
    fi

    # Dynamic configure C_INCLUDE_PATH 和 LIBCLANG_PATH
    DYNAMIC_C_INCLUDE=$(gcc -print-file-name=include)
    DYNAMIC_LIBCLANG=$(find /usr/lib -name "libclang.so" -printf "%h\n" -quit 2>/dev/null)

    echo "Detected C_INCLUDE_PATH: $DYNAMIC_C_INCLUDE"
    echo "Detected LIBCLANG_PATH: $DYNAMIC_LIBCLANG"

    # install treesitter (retry a few times; transient build/network failures
    # here should not abort the whole installation)
    for i in 1 2 3; do
        if C_INCLUDE_PATH="$DYNAMIC_C_INCLUDE" LIBCLANG_PATH="$DYNAMIC_LIBCLANG" cargo install --locked tree-sitter-cli; then
            break
        fi
        echo "tree-sitter-cli install failed (attempt $i/3)"
    done
}

if [ "$PKG_OS" = "Darwin" ]; then
    install_macos
else
    install_linux
fi

echo "Installation done. For additional install, please refer to README"
