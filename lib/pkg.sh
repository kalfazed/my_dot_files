#!/usr/bin/env bash
#
# Shared helpers for the module install scripts (source this file).
# Skip what is already installed so re-running the installer is fast.
#
#   pkg_install PKG...        install only the missing packages (apt on Linux, brew on macOS)
#   have CMD                  true if CMD is on PATH
#   version_ge A B            true if version A >= B (e.g. version_ge 0.11.6 0.11)
#   skip MSG / step MSG       print a status line
#
# Environment:
#   DOTFILES_FORCE=1          reinstall everything, even if already installed
#   DOTFILES_UPDATE_STAMP     set by the top-level install.sh so `apt-get update` /
#                             `brew update` runs at most once for the whole run

PKG_OS="$(uname -s)"   # Linux / Darwin

have() { command -v "$1" >/dev/null 2>&1; }

skip() { echo "  ✓ $* (already installed, skip)"; }
step() { echo "  → $*"; }

forced() { [ "${DOTFILES_FORCE:-0}" = 1 ]; }

# version_ge A B: A >= B, comparing up to 3 numeric fields ("v0.11.6" and "0.11" are fine)
version_ge() {
    local a="${1#v}" b="${2#v}" i x y
    local IFS=.
    local -a va=($a) vb=($b)
    for i in 0 1 2; do
        x="${va[$i]:-0}"; y="${vb[$i]:-0}"
        x="${x%%[!0-9]*}"; y="${y%%[!0-9]*}"
        x=$((10#${x:-0})); y=$((10#${y:-0}))
        [ "$x" -gt "$y" ] && return 0
        [ "$x" -lt "$y" ] && return 1
    done
    return 0
}

pkg_is_installed() {
    if [ "$PKG_OS" = "Darwin" ]; then
        brew list --versions "$1" >/dev/null 2>&1
    else
        dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "install ok installed"
    fi
}

# run `apt-get update` / `brew update` once (per top-level run, or per module run standalone)
pkg_update_once() {
    [ -n "${_PKG_UPDATED:-}" ] && return 0
    if [ -n "${DOTFILES_UPDATE_STAMP:-}" ] && [ -e "$DOTFILES_UPDATE_STAMP" ]; then
        _PKG_UPDATED=1
        return 0
    fi
    if [ "$PKG_OS" = "Darwin" ]; then
        brew update
    else
        sudo apt-get update
    fi
    _PKG_UPDATED=1
    [ -n "${DOTFILES_UPDATE_STAMP:-}" ] && touch "$DOTFILES_UPDATE_STAMP"
    return 0
}

pkg_install() {
    local p missing=()
    for p in "$@"; do
        if ! forced && pkg_is_installed "$p"; then
            skip "$p"
        else
            missing+=("$p")
        fi
    done
    [ "${#missing[@]}" -eq 0 ] && return 0

    step "installing: ${missing[*]}"
    pkg_update_once
    if [ "$PKG_OS" = "Darwin" ]; then
        # brew already updated above; don't auto-update again on every install
        HOMEBREW_NO_AUTO_UPDATE=1 brew install "${missing[@]}"
    else
        sudo apt-get install -y "${missing[@]}"
    fi
}
