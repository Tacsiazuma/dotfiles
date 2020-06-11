
function powerline_precmd() {
    PS1="$(powerline-shell --shell zsh $?)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" ]; then
    install_powerline_precmd
fi
neofetch

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/krisztianpapp/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/krisztianpapp/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/krisztianpapp/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/krisztianpapp/google-cloud-sdk/completion.zsh.inc'; fi
