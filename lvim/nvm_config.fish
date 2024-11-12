# Set the NVM directory
set -x NVM_DIR $HOME/.nvm

# Load nvm for Fish
if test -s $NVM_DIR/nvm.fish
    source $NVM_DIR/nvm.fish
end

# Optionally, load NVM completion for Fish
if test -s $NVM_DIR/completions/nvm.fish
    source $NVM_DIR/completions/nvm.fish
end
