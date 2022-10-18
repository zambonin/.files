# ~/.bash_profile

export BROWSER="firefox"
export EDITOR="vim"
export TMPDIR="/tmp"

export HISTFILE="$HOME/.history"
export HISTFILESIZE="INFINITY"
export HISTSIZE="INFINITY"
export HISTTIMEFORMAT='%F %T '
export PROMPT_COMMAND='history -a'

export MANPAGER="vim --not-a-term -M +MANPAGER -c 'set noma' -"
export MANWIDTH=80

export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
export DOT_SAGE="${XDG_CONFIG_HOME}/sage"
export FZF_ALT_C_COMMAND="find ."
export FZF_ALT_C_OPTS="--preview 'tree -a --dirsfirst -C {} | head -200'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:wrap"
export FZF_CTRL_T_COMMAND="$FZF_ALT_C_COMMAND"
export FZF_CTRL_T_OPTS="--preview '(cat {} || tree -a --dirsfirst -C {}) \
  2> /dev/null | head -200'"
export FZF_DEFAULT_OPTS="--cycle --inline-info --prompt='$ ' --reverse"
export LESS=' -fiJMRW '
export LESSHISTFILE="${XDG_CACHE_HOME}/less/history"
export PARALLEL_HOME="${XDG_CONFIG_HOME}/parallel"
export XAUTHORITY="${XDG_RUNTIME_DIR}/Xauthority"

if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ] ; then
  exec startx /usr/bin/i3 -c "$HOME/.wmconfig"
fi

sh /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

if [ -f ~/.bashrc ] ; then
  source ~/.bashrc
fi
