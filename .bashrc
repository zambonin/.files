# ~/.bashrc

shopt -s autocd cdspell checkwinsize cmdhist dirspell histappend
set -o noclobber
stty -ixon

[ -f "$HOME/.aliases" ] && . "$HOME/.aliases"

aur() {
  trap 'cd $OLDDIR' INT
  OLDDIR="$PWD"
  for pkg in "$@" ; do
    cd "$(mktemp -d)" || exit
    curl -Os --fail \
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
  link="$(awk -F'[ $]' '/^S/ {print $3; exit}' /etc/pacman.d/mirrorlist)"
  path="${link}/iso/latest/"
  file="$(curl -s "$path" | grep -oP -m1 '"\Karchl[^"]+')"
  curl -# "${path}${file}" > "$file"
}

ll() {
  LC_COLLATE=C ls -Agho "$@" | less
}

man() {
  env LESS_TERMCAP_mb=$'\E[01;31m'                                          \
    LESS_TERMCAP_md=$'\E[01;38;5;74m'                                       \
    LESS_TERMCAP_me=$'\E[0m'                                                \
    LESS_TERMCAP_se=$'\E[0m'                                                \
    LESS_TERMCAP_so=$'\E[38;5;246m'                                         \
    LESS_TERMCAP_ue=$'\E[0m'                                                \
    LESS_TERMCAP_us=$'\E[04;38;5;146m'                                      \
    man "$@"
}

pacsize() {
  expac -HM "%011m\t%-25n\t%10d"                                              \
    $(comm -23 <(pacman -Qqen | sort) <(pacman -Qqg base base-devel | sort))  \
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
  [[ ! -f "$HOME/vmdisk" ]] && qemu-img create -f raw "$HOME/vmdisk" 8G
  qemu-system-x86_64                                                        \
    -m 2G                                                                   \
    -cpu host                                                               \
    -smp 2                                                                  \
    -machine type=pc,accel=kvm                                              \
    -monitor stdio                                                          \
    -drive file="$HOME/vmdisk",format=raw,if=virtio,cache=none,aio=native   \
    -net user,hostfwd=tcp::10022-:22                                        \
    -net nic,model=virtio                                                   \
    -boot menu=on                                                           \
    -vga std                                                                \
    -display sdl                                                            \
    -usbdevice tablet                                                       \
    "$@"
}

wttr() {
  loc="$(curl -sN "https://ipinfo.geo" | awk -F\" '/loc/ {print $4}')"
  curl -sH "Accept-Language: ${LANG%_*}" "wttr.in/${loc}?0Q"
}

PS1='\[\e[01;34m\]\w \[\e[01;37m\]\\$\[\e[0m\] '

if pacman -Qq | grep -q pkgfile ; then
  . /usr/share/doc/pkgfile/command-not-found.bash
fi

[[ -z "$TMUX" ]] && exec tmux
