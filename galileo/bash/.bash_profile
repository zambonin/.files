# ~/.bash_profile

export BROWSER="firefox"
export EDITOR="vim"
export HISTFILE="$HOME/.history"
export HISTFILESIZE=1000000
export HISTSIZE=1000000
export HISTTIMEFORMAT='%F %T '
export LESS=' -fiJMRW '
export PROMPT_COMMAND='history -a'
export XKB_DEFAULT_LAYOUT=us
export XKB_DEFAULT_MODEL=pc105
export XKB_DEFAULT_VARIANT=intl
export XKB_DEFAULT_OPTIONS=compose:rwin,ctrl:nocaps,terminate:ctrl_alt_bksp

if ! pstree | grep -q ssh-agent ; then
  eval "$(ssh-agent -s)"
fi

if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ] ; then
  exec startx /usr/bin/i3 -c "$HOME/.wmconfig"
fi

if [ -f ~/.bashrc ] ; then
  source ~/.bashrc
fi
