# For new user: here are tips you need to do !!
## 1. modify your environment variables, such as $PATH, $LD_LIBRARY_PATH, $PKG_CONFIG_PATH, $GOPATH, and so on
## 2. set your own alias. I have demonstrated some useful alias I use everyday. Please change them as you wish :)
## 3. set up your conda env. After you install miniconda or anaconda, you should run "conda init fish" firstly.
## 4. Install fisher and z following:
##    https://github.com/jorgebucaran/fisher
##    https://github.com/jethrokuan/z
## 5. You can also change your prompt and keybinding in ./functions
# Have fun!!

if status is-interactive
    # Commands to run in interactive sessions can go here
end

export LSCOLORS=gxfxcxdxbxegedabagacad

set fish_greeting "welcome back!!"

# color setting
set -gx TERM xterm-256color

# Global color variables
set -g RED (set_color red)
set -g REDB (set_color --bold red)
set -g GREEN (set_color green)
set -g GREENB (set_color --bold green)
set -g YELLOW (set_color yellow)
set -g YELLOWB (set_color --bold yellow)
set -g BLUE (set_color blue)
set -g BLUEB (set_color --bold blue)
set -g PURPLE (set_color purple)
set -g PURPLEB (set_color --bold purple)
set -g CYAN (set_color cyan)
set -g CYANB (set_color --bold cyan)
set -g CLEAR (set_color normal) 

# theme
set -g theme_hide_hostname no
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hostname always


# aliases
alias ls     "ls -p -G"
alias la     "ls -A"
alias sleep  "sudo systemctl suspend"
alias ncu    "sudo /usr/local/cuda/bin/ncu"
alias bmake  "bear -- make -j64"
alias make   "make -j64"
alias nsys   "sudo /usr/local/cuda/bin/nsys"
alias obs    "flatpak run com.obsproject.Studio"
alias gt     "git log --graph --pretty=format:'%x09%C(auto) %h %Cgreen %ar %Creset%x09 %C(cyan ul)%an%Creset %x09%C(auto)%s %d'"
alias dsort  "du -sh -- *  | sort -rh"
alias lm     "df -hl -x tmpfs"
alias pip    "python -m pip"
alias wm     "wmctrl -r 'Alacritty' -b toggle,fullscreen"
alias rs     "rsync -azh --info=progress2 --no-i-r" # copy to local
alias rss    "rsync -azh --info=progress2 -e \"ssh -T -c aes128-ctr -o Compression=no -x\" --block-size=128K --inplace " # copy to remote
alias ll     "exa --icons --long --git"
alias lla    "ll -a"

# set customized neovim as default editor
command -qv lvim && alias vim lvim
set -gx EDITOR lvim

# combine cd and ls together
functions --copy cd standard_cd
function cd
  standard_cd $argv; and ll
end


# Please modify your path here
set -gx PATH bin $PATH
set -gx PATH ~/.local/bin $PATH
set -gx PATH /usr/local/bin $PATH
set -gx PATH /usr/local/cuda/bin $PATH
set -gx PATH ~/.cargo/bin $PATH
set -gx LD_LIBRARY_PATH /usr/local/cuda/lib64 $LD_LIBRARY_PATH
set -gx LD_LIBRARY_PATH /usr/local/lib $LD_LIBRARY_PATH
set -gx PKG_CONFIG_PATH /usr/local/lib/pkgconfig $PKG_CONFIG_PATH

# NodeJS
set -gx PATH node_modules/.bin $PATH

# Go
set -g GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH

# Please modify your OpenAI API key here to enable ChatGPT
set -gx OPENAI_API_KEY xxx 

# Please modify your wandb API key here to enable Weights & Biases
set -gx WANDB_API_KEY xxx 

# cuda lazy loading
set -gx CUDA_MODULE_LOADING LAZY 

# change the trackpoint speed
xinput --set-prop "TPPS/2 Elan TrackPoint" "libinput Accel Speed" 1.0 # Max sensitivity
xinput --set-prop "TPPS/2 Elan TrackPoint" "libinput Accel Profile Enabled" 1 0 #Set profile as "adaptive"

set LOCAL_CONFIG (dirname (status --current-filename))/config-local.fish
if test -f $LOCAL_CONFIG
  source $LOCAL_CONFIG
end

# peco + ghq
set -g GHQ_SELECTOR peco
