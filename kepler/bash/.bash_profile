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
export GRIM_DEFAULT_DIR="$TMPDIR"
export LESS=' -fiJMRW '
export LESSHISTFILE="${XDG_CACHE_HOME}/less/history"
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland-egl
export PARALLEL_HOME="${XDG_CONFIG_HOME}/parallel"
export SWAYSOCK="/run/user/$(id -u)/sway-ipc.$(id -u).$(pgrep -x sway).sock"
export XAUTHORITY="${XDG_RUNTIME_DIR}/Xauthority"
export _JAVA_AWT_WM_NONREPARENTING=1

if [ -z "$DISPLAY" ] && [ "$(tty)" = /dev/tty1 ] ; then
  exec sway -c "$HOME/.wmconfig"
fi

if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 2 ] ; then
  exec startx /usr/bin/i3 -c "$HOME/.files/galileo/i3/.wmconfig"
fi

if [ -f ~/.bashrc ] ; then
  source ~/.bashrc
fi
