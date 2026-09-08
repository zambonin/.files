# ~/.bashrc

[[ $- != *i* ]] && return

shopt -s autocd cdspell dirspell globstar histappend
set -o noclobber
[ -t 0 ] && stty -ixon

if [ -f "$HOME/.aliases" ] ; then
  . "$HOME/.aliases"
fi

if [ -f /usr/share/doc/pkgfile/command-not-found.bash ] ; then
  . /usr/share/doc/pkgfile/command-not-found.bash
fi

aur() {
  OLDDIR="$PWD"
  trap 'cd "$OLDDIR" ; trap - INT' INT
  for pkg in "$@" ; do
    OLDVER="$(curl -s                                                         \
      "https://aur.archlinux.org/rpc.php?arg[]=${pkg}&type=info&v=5"          \
      | awk -F\" '{print $26}')"
    NEWVER="$(pacman -Q "${pkg}" 2>/dev/null | cut -d\  -f2)"
    [ "$OLDVER" != "$NEWVER" ] || continue
    cd "$(mktemp -d)" || break
    if curl -Os --fail                                                        \
      "https://aur.archlinux.org/cgit/aur.git/snapshot/${pkg}.tar.gz" ; then
      tar zxvf "${pkg}.tar.gz"
      cd "$pkg" || break
      makepkg
    fi
  done
  cd "$OLDDIR"
  trap - INT
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

up() {
  dir=""
  limit=${1:-1}
  for _ in $(seq 1 "$limit") ; do
    dir="../${dir}"
  done
  cd "${dir}" || return 1
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
  DISK="$1"
  shift

  CODE_OVMF="/usr/share/ovmf/x64/OVMF_CODE.4m.fd"
  VARS_OVMF="/usr/share/ovmf/x64/OVMF_VARS.4m.fd"
  TARGET_OVMF="/tmp/ovmf_vars.bin"

  if [ ! -f "$TARGET_OVMF" ] ; then
    cp "$VARS_OVMF" "$TARGET_OVMF"
  fi

  vm "$DISK"                                                                   \
    -drive if=pflash,format=raw,readonly=on,file="$CODE_OVMF"                  \
    -drive if=pflash,format=raw,file="$TARGET_OVMF"                            \
    "$@"
}

PS1='\[\e[01;34m\]\w \[\e[01;37m\]\\$\[\e[0m\] '

if [ -f /usr/share/fzf/key-bindings.bash ] ; then
  . /usr/share/fzf/key-bindings.bash
fi

if [ -f /usr/share/fzf/completion.bash ] ; then
  . /usr/share/fzf/completion.bash
fi
