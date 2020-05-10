# ~/.bashrc

shopt -s autocd cdspell checkwinsize cmdhist dirspell histappend
set -o noclobber
stty -ixon

if [ -f "$HOME/.aliases" ] ; then
  . "$HOME/.aliases"
fi

if [ -f /usr/share/doc/pkgfile/command-not-found.bash ] ; then
  . /usr/share/doc/pkgfile/command-not-found.bash
fi

aur() {
  trap 'cd $OLDDIR' INT
  OLDDIR="$PWD"
  for pkg in "$@" ; do
    OLDVER="$(curl -s                                                         \
      "https://aur.archlinux.org/rpc.php?arg[]=${pkg}&type=info&v=5"          \
      | awk -F\" '{print $26}')"
    NEWVER="$(pacman -Q "${pkg}" 2>/dev/null | cut -d\  -f2)"
    [ "$OLDVER" != "$NEWVER" ] || continue
    cd "$(mktemp -d)" || exit
    curl -Os --fail                                                           \
      "https://aur.archlinux.org/cgit/aur.git/snapshot/${pkg}.tar.gz"
    if [ "$?" -ne 22 ] ; then
      tar zxvf "${pkg}.tar.gz"
      cd "$pkg" || exit
      makepkg
    fi
  done
  cd "$OLDDIR" || exit
}

backup() {
  for file in "$@" ; do
    cp "$file" "${file}-$(date +%Y-%m-%d-%H%M%S)".backup
  done
}

calc() {
  bc -l <<< "$@"
}

cd() {
  builtin cd "$@"
  if [ -f bin/activate ] ; then
    . bin/activate
  elif [ -f requirements.txt ] ; then
    python -m venv "$PWD"
    . bin/activate
    pip install -r requirements.txt
  elif [[ "$VIRTUAL_ENV" == "$PWD"* ]] ; then
    deactivate
  fi
}

downiso() {
  curl -#O "$(awk -F'[ $]' '/^S/ {
    print $3 "iso/latest/archlinux-" strftime("%Y.%m.01") "-x86_64.iso" ; exit
  }' /etc/pacman.d/mirrorlist)"
}

pacsize() {
  expac -HM "%011m\t%-25n\t%10d"                                              \
    $(comm -23 <(pacman -Qqen | sort)                                         \
      <((pacman -Qqg base-devel ; pactree -l -d1 base) | sort -u))            \
    | sort -nr | less
}

transfer() {
  curl -sH "Max-Downloads: 1" -T "$1" "https://transfer.sh/$(basename "$1")"
  echo
}

up() {
  dir=""
  limit=${1:-1}
  for _ in $(seq 1 "$limit") ; do
    dir="../${dir}"
  done
  cd "${dir}" || exit
}

vm() {
  disk="$1"
  shift
  qemu-system-x86_64                                                          \
    -m 4G                                                                     \
    -cpu host                                                                 \
    -smp 2                                                                    \
    -machine type=pc,accel=kvm                                                \
    -monitor stdio                                                            \
    -drive file="$disk",format=raw,if=virtio,cache=none,aio=native            \
    -net user,smb="$HOME"                                                     \
    -net nic                                                                  \
    -display sdl                                                              \
    -usb                                                                      \
    -device usb-tablet                                                        \
    "$@"
}

vmu() {
  disk="$1"
  shift

  if [ ! -f /tmp/ovmf_vars.bin ] ; then
    cp /usr/share/ovmf/x64/OVMF_VARS.fd /tmp/ovmf_vars.bin
  fi

  vm "$disk"                                                                   \
    -drive if=pflash,format=raw,readonly,file=/usr/share/ovmf/x64/OVMF_CODE.fd \
    -drive if=pflash,format=raw,file=/tmp/ovmf_vars.bin                        \
    "$@"
}

PS1='\[\e[01;34m\]\w \[\e[01;37m\]\\$\[\e[0m\] '

if [ -f /usr/share/fzf/key-bindings.bash ] ; then
  . /usr/share/fzf/key-bindings.bash
fi

if [ -f /usr/share/fzf/completion.bash ] ; then
  . /usr/share/fzf/completion.bash
fi

if [ -z "$TMUX" ] ; then
  if ! tmux has-session -t "session_tty${XDG_VTNR}" 2>/dev/null ; then
    exec tmux new-session -A -s "session_tty${XDG_VTNR}"
  else
    exec tmux attach-session
  fi
fi
