if status is-interactive
    # Commands to run in interactive sessions can go here
end

functions --copy cd standard_cd

function cd
  standard_cd $argv; and ll
end

export LSCOLORS=gxfxcxdxbxegedabagacad

set fish_greeting ""

set -gx TERM xterm-256color

# theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# aliases
alias ls "ls -p -G"
alias la "ls -A"
command -qv lvim && alias vim lvim

if type -q exa
  alias ll "exa -l -g --icons"
  alias lla "ll -a"
end

set -gx EDITOR lvim

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH
set -gx PATH /usr/local/bin $PATH
set -gx PATH /usr/local/cuda/bin $PATH
set -gx PATH /home/kalfazed/package/TensorRT-8.5.1.7/bin $PATH
set -gx LD_LIBRARY_PATH /home/kalfazed/package/TensorRT-8.5.1.7/lib $LD_LIBRARY_PATH
set -gx LD_LIBRARY_PATH /usr/local/cuda/lib64 $LD_LIBRARY_PATH
set -gx LD_LIBRARY_PATH /usr/local/lib $LD_LIBRARY_PATH
set -gx PKG_CONFIG_PATH /usr/local/lib/pkgconfig $PKG_CONFIG_PATH

# NodeJS
#set -gx PATH node_modules/.bin $PATH

# Go
set -g GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH



set LOCAL_CONFIG (dirname (status --current-filename))/config-local.fish
if test -f $LOCAL_CONFIG
  source $LOCAL_CONFIG
end


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/kalfazed/miniconda3/bin/conda
    eval /home/kalfazed/miniconda3/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<

conda activate swin

