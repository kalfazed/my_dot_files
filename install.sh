#!/usr/bin/env bash
#
# Install dotfiles. Installs every module by default, or only the ones given.
#
#   ./install.sh                      # install all modules
#   ./install.sh bash                 # install bash only
#   ./install.sh bash fish            # install bash and fish
#   ./install.sh -n DESKTOP nvim tmux # set prompt hostname, install nvim and tmux
#   ./install.sh -l                   # list available modules

# all modules, in install order
MODULES=("bash" "fish" "tmux" "peco" "nvim")

cd "$(dirname "$0")" || exit 1

OS="$(uname -s)"   # Linux / Darwin

usage() {
    cat <<EOF
Usage: ./install.sh [-n HOSTNAME] [-l] [-h] [MODULE...]

Install all modules by default, or only the given MODULEs.

Options:
  -n HOSTNAME   name shown in the bash/fish prompt (saved to ~/.hostname.sh)
                default: keep the existing one, or \$(whoami) on first install
  -l            list available modules
  -h            show this help

Modules: ${MODULES[*]}

Examples:
  ./install.sh                  # install everything
  ./install.sh bash             # install bash only
  ./install.sh bash fish        # install bash and fish
  ./install.sh -n DESKTOP nvim  # set prompt hostname, install nvim only
EOF
}

hostname=""
while getopts ":n:lh" opt; do
    case "$opt" in
        n) hostname="$OPTARG" ;;
        l) printf '%s\n' "${MODULES[@]}"; exit 0 ;;
        h) usage; exit 0 ;;
        :) echo "Error: -$OPTARG requires an argument" >&2; usage >&2; exit 1 ;;
        \?) echo "Error: unknown option -$OPTARG" >&2; usage >&2; exit 1 ;;
    esac
done
shift $((OPTIND - 1))

# ---------- resolve which modules to install ----------
if [ "$#" -eq 0 ] || [ "$1" = "all" ]; then
    selected=("${MODULES[@]}")
else
    for arg in "$@"; do
        if [[ ! " ${MODULES[*]} " =~ " ${arg} " ]]; then
            echo "Error: unknown module '$arg'" >&2
            echo "Available modules: ${MODULES[*]}" >&2
            exit 1
        fi
    done
    # keep the canonical install order and drop duplicates
    selected=()
    for m in "${MODULES[@]}"; do
        for arg in "$@"; do
            if [ "$m" = "$arg" ]; then
                selected+=("$m")
                break
            fi
        done
    done
fi

echo "Modules to install: ${selected[*]}"

# ---------- prompt hostname (used by bash / fish) ----------
if [ -n "$hostname" ]; then
    echo "hostname=${hostname}" > ~/.hostname.sh
elif [ ! -f ~/.hostname.sh ]; then
    echo "hostname=$(whoami)" > ~/.hostname.sh
fi
echo "Hello $(sed -n 's/^hostname=//p' ~/.hostname.sh)"

# ---------- package manager ----------
if [ "$OS" = "Darwin" ]; then
    if ! command -v brew >/dev/null 2>&1; then
        echo "Error: Homebrew is required on macOS: https://brew.sh" >&2
        exit 1
    fi
    brew update
else
    # ask for the sudo password once and keep it cached for the whole script
    sudo -v || exit 1
    while true; do sudo -n true; sleep 60; kill -0 "$$" 2>/dev/null || exit; done 2>/dev/null &
    sudo apt-get update
fi

# ---------- install ----------
succeeded=()
failed=()
for dir in "${selected[@]}"; do
    if [ -d "$dir" ] && [ -f "$dir/install.sh" ]; then
        echo
        echo "========== Installing $dir =========="
        if (cd "$dir" && bash install.sh); then
            succeeded+=("$dir")
        else
            failed+=("$dir")
        fi
    else
        echo "Skipping $dir: directory or install.sh not found."
        failed+=("$dir")
    fi
done

echo
echo "========== Summary =========="
[ "${#succeeded[@]}" -gt 0 ] && echo "Succeeded: ${succeeded[*]}"
if [ "${#failed[@]}" -gt 0 ]; then
    echo "Failed:    ${failed[*]}"
    exit 1
fi
