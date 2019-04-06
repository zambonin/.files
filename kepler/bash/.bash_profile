# ~/.bash_profile

export BROWSER="firefox"
export EDITOR="vim"
export FZF_DEFAULT_OPTS="--cycle --inline-info --prompt='$ ' --reverse"
export HISTFILE="$HOME/.history"
export HISTFILESIZE=1000000
export HISTSIZE=1000000
export HISTTIMEFORMAT='%F %T '
export KITTY_CONFIG_DIRECTORY="$HOME/.files/$HOSTNAME/conf"
export KITTY_ENABLE_WAYLAND=1
export LESS=' -fiJMRW '
export LIBVA_DRIVER_NAME=iHD
export MOZ_ENABLE_WAYLAND=1
export PROMPT_COMMAND='history -a'
export SWAYSOCK="/run/user/$(id -u)/sway-ipc.$(id -u).$(pgrep -x sway).sock"

if ! pstree | grep -q ssh-agent ; then
  eval "$(ssh-agent -s)"
fi

if [ -z "$DISPLAY" ] && [ "$(tty)" = /dev/tty1 ] ; then
  exec sway -c "$HOME/.wmconfig"
fi

if [ -f ~/.bashrc ] ; then
  source ~/.bashrc
fi
