# ~/.bashrc

shopt -s autocd cdspell checkwinsize cmdhist dirspell histappend
set -o noclobber
stty -ixon

[ -f "$HOME/.aliases" ] && . "$HOME/.aliases"

aur() {
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

downiso() {
  link="$(awk -F'[ $]' '/^S/ {print $3; exit}' /etc/pacman.d/mirrorlist)"
  path="${link}/iso/latest/"
  file="$(curl -s "$path" | awk -F\" '/[.]iso/ {print $2; exit}')"
  curl -s "${path}${file}" > "$file" &
}

ll() {
  LC_COLLATE=C ls -Agho "$@" | less
}

lt() {
  ARG="$1"
  FILE="${ARG%.*}"
  texfot pdflatex "$FILE"
  if [ -s "${ARG/tex/bib}" ] ; then
    texfot bibtex "$FILE"
    texfot pdflatex "$FILE"
  fi
  texfot pdflatex "$FILE"
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

mgit() {
  for d in */ ; do
    if [[ ! -z "$(git -C "$d" status -s 2>/dev/null)" ]] ; then
      paste <(echo "$d") <(git -C "$d" ss) | expand -t 18
    fi
  done
}

pacsize() {
  expac -HM "%011m\t%-25n\t%10d"                                              \
    $(comm -23 <(pacman -Qqen | sort) <(pacman -Qqg base base-devel | sort))  \
    | sort -nr | less
}

transfer() {
  curl -sH "Max-Downloads: 1" -T "$1" "transfer.sh/$(basename "$1")"
}

up() {
  local d=""
  limit=$1
  for ((i = 1; i <= limit; i++)); do
    d=$d/..
  done
  d=$(echo $d | sed 's/^\///')
  if [ -z "$d" ]; then
    d=..
  fi
  cd $d || exit
}

v_env() {
  if [ -n "$1" ] ; then
    python -m venv "$1"
    source "${1}bin/activate"
    pip install -r "${1}requirements.txt"
    deactivate
  fi
}

vm() {
  [[ ! -f "$HOME/vmdisk" ]] && qemu-img create -f raw "$HOME/vmdisk" 8G
  qemu-system-x86_64                                                        \
    -m 1G                                                                   \
    -cpu host                                                               \
    -smp 2                                                                  \
    -machine type=pc,accel=kvm                                              \
    -monitor stdio                                                          \
    -drive file="$HOME/vmdisk",format=raw,if=virtio,cache=none,aio=native   \
    -net user,hostfwd=tcp::10022-:22                                        \
    -net nic,model=virtio                                                   \
    -boot menu=on                                                           \
    "$@"
}

wttr() {
  curl -sH "Accept-Language: ${LANG%_*}" "wttr.in/$1" | sed -n 2,7p ; echo
}

PS1='\[\e[0m\]\[\e[01;34m\]\w\[\e[0m\]\[\e[00;37m\] '       # absolute path
PS1+='\[\e[0m\]\[\e[01;37m\]\\$\[\e[0m\] '                  # $

if pacman -Qq | grep -q pkgfile ; then
  source /usr/share/doc/pkgfile/command-not-found.bash
fi

[[ -z "$TMUX" ]] && exec tmux
