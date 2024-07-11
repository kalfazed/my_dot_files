function hub_remote_repository
  set rep (ghq list | peco --layout=bottom-up | cut -d "/" -f 2,3)
  hub browse $rep
end
