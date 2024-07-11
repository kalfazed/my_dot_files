function fish_user_key_bindings
  # peco
  bind \cr peco_select_history # Bind for peco select history to Ctrl+R
  bind \c] peco_change_directory # Bind for peco change directory to Ctrl+F
  bind \co hub_remote_repository # Bind for open remote repository

  # vim-like
  bind \cl forward-char

  # prevent iterm2 from closing when typing Ctrl-D (EOF)
  bind \cd delete-char
end
