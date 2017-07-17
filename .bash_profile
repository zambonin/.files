# ~/.bash_profile

export EDITOR="vim"
export HISTFILE="$HOME/.history"
export HISTFILESIZE=1000000
export HISTSIZE=1000000
export HISTTIMEFORMAT='%F %T '
export PROMPT_COMMAND='history -a'

if ! pstree | grep -q ssh-agent ; then
  eval "$(ssh-agent -s)"
  ssh-add
fi

if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ] ; then
  exec startx /usr/bin/i3
fi

if [ -f ~/.bashrc ] ; then
  source ~/.bashrc
fi
