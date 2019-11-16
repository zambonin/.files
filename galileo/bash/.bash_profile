# ~/.bash_profile

export BROWSER="firefox"
export EDITOR="vim"
export FZF_DEFAULT_OPTS="--cycle --inline-info --prompt='$ ' --reverse"
export HISTFILE="$HOME/.history"
export HISTFILESIZE="INFINITY"
export HISTSIZE="INFINITY"
export HISTTIMEFORMAT='%F %T '
export KITTY_CONFIG_DIRECTORY="$HOME/.files/$HOSTNAME/conf"
export LESS=' -fiJMRW '
export PROMPT_COMMAND='history -a'

if ! pstree | grep -q ssh-agent ; then
  eval "$(ssh-agent -s)"
fi

if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ] ; then
  exec startx /usr/bin/i3 -c "$HOME/.wmconfig"
fi

sh /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

if [ -f ~/.bashrc ] ; then
  source ~/.bashrc
fi
