# ~/.bashrc

shopt -s autocd cdspell checkwinsize cmdhist dirspell histappend
set -o noclobber
stty -ixon

[ -f "$HOME/.aliases" ] && . "$HOME/.aliases"

aur() {
  trap 'cd $OLDDIR' INT
  OLDDIR="$PWD"
  for pkg in "$@" ; do
    OLDVER="$(curl -s "https://aur.archlinux.org/packages/${pkg}"             \
      | awk -v p=": ${pkg}" -F"[ <]" '$0 ~ p {print $5}')"
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
  builtin cd "$@" || exit
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
  curl -#O "$(awk -F'[ $]' '/^S/ { print $3 "iso/latest/archlinux-"           \
    strftime("%Y.%m.01") "-x86_64.iso" ; exit }' /etc/pacman.d/mirrorlist)"
}

gss() {
  parallel -j"$(nproc)" '
    s="$(git -C {} status -s)"
    if [ -n "$s" ] ; then
      echo {}
      echo "$s"
    fi
  ' :::: <(find "${1:-.}" -type d -name .git -printf "%h\n")
}

ll() {
  LC_COLLATE=C ls -Agho "$@" | less
}

man() {
  env LESS_TERMCAP_mb=$'\E[01;31m'                                            \
    LESS_TERMCAP_md=$'\E[01;38;5;74m'                                         \
    LESS_TERMCAP_me=$'\E[0m'                                                  \
    LESS_TERMCAP_se=$'\E[0m'                                                  \
    LESS_TERMCAP_so=$'\E[38;5;246m'                                           \
    LESS_TERMCAP_ue=$'\E[0m'                                                  \
    LESS_TERMCAP_us=$'\E[04;38;5;146m'                                        \
    man "$@"
}

pacsize() {
  expac -HM "%011m\t%-25n\t%10d"                                              \
    $(comm -23 <(pacman -Qqen | sort) <(pacman -Qqg base base-devel | sort))  \
    | sort -nr | less
}

tarball() {
  name="$1"
  shift
  tar cvf "${name}.tar.bz2" --use-compress-program=pbzip2 "$@"
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
    -m 3G                                                                     \
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

vmd() {
  vm "$HOME/debian-vm" "$@"
}

vmw() {
  vm "$HOME/windows-vm" "$@"
}

wttr() {
  loc="$(curl -sN "https://ipinfo.geo" | awk -F\" '/loc/ {print $4}')"
  curl -sH "Accept-Language: ${LANG%_*}" "wttr.in/${loc}?0Q"
}

PS1='\[\e[01;34m\]\w \[\e[01;37m\]\\$\[\e[0m\] '

if command -v pkgfile > /dev/null ; then
  . /usr/share/doc/pkgfile/command-not-found.bash
fi

if [[ -z "$TMUX" ]] ; then
  exec tmux
fi
