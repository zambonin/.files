# ~/.bash_profile

export BROWSER="firefox"
export EDITOR="vim"
export HISTFILE="$HOME/.history"
export HISTFILESIZE=1000000
export HISTSIZE=1000000
export HISTTIMEFORMAT='%F %T '
export LIBVA_DRIVER_NAME=iHD
export PROMPT_COMMAND='history -a'

if ! pstree | grep -q ssh-agent ; then
  eval "$(ssh-agent -s)"
fi

if [ -z "$DISPLAY" ] && [ "$(tty)" = /dev/tty1 ] ; then
  exec sway -c "$HOME/.wmconfig"
fi

if [ -f ~/.bashrc ] ; then
  source ~/.bashrc
fi
