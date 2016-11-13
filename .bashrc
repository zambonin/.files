# ~/.bashrc

shopt -s autocd cdspell checkwinsize cmdhist dirspell histappend
set -o noclobber

EDITOR="vim"
HISTFILE="$HOME/.history"
HISTFILESIZE=1000000
HISTSIZE=1000000
HISTTIMEFORMAT='%F %T '
PROMPT_COMMAND='history -a'

[ -f "$HOME/.aliases" ] && . "$HOME/.aliases"

aur() {
    pkg="$1.tar.gz"
    curl --fail -O "https://aur.archlinux.org/cgit/aur.git/snapshot/$pkg"
    [ "$?" -ne 0 ] && rm -f "$pkg"
    ex "$pkg"
    IFS='.' read -r filename _ <<< "$pkg"
    cd "${filename}" || exit
    makepkg
    cd ..
    rm -f "${filename}" "$pkg"
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
    link="$(\grep -m1 -o "http.*" /etc/pacman.d/mirrorlist | cut -d\$ -f1)"
    path="$link/iso/latest/"
    file="$(curl -s "$path" | \grep -m1 "\.iso" | cut -d\" -f2)"
    curl -s "$path$file" > "$file" &
}

ll() {
    LC_COLLATE=C ls -Agho "$@" | less
}

lt() {
    ARG="$1"
    FILE="${ARG%.*}"
    texfot pdflatex "$FILE"
    bibtex "$FILE"
    texfot pdflatex "$FILE"
    texfot pdflatex "$FILE"
}

man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
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
    expac -HM "%011m\t%-25n\t%10d" $(comm -23 <(pacman -Qqen | sort) \
        <(pacman -Qqg base base-devel | sort)) | sort -nr | less
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

vm() {
    [[ ! -f "$HOME/vmdisk" ]] && qemu-img create -f raw "$HOME/vmdisk" 8G
    qemu-system-x86_64 \
        -m 1G \
        -cpu host \
        -smp 2 \
        -machine type=pc,accel=kvm \
        -monitor stdio \
        -drive file="$HOME/vmdisk",format=raw,if=virtio,cache=none,aio=native \
        -net user,hostfwd=tcp::10022-:22 \
        -net nic,model=virtio \
        -boot menu=on \
        "$@"
}

PS1='\[\e[01;37m\][\A]\[\e[0m\]\[\e[00;37m\] '              # [HH:MM]
PS1+='\[\e[0m\]\[\e[01;34m\]\w\[\e[0m\]\[\e[00;37m\] '      # absolute path
PS1+='\[\e[0m\]\[\e[01;37m\]\\$\[\e[0m\] '                  # $

if pkgfile 2>/dev/null ; then
    . /usr/share/doc/pkgfile/command-not-found.bash
fi

if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent -s`
    ssh-add
fi

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && startx

[[ -f "$HOME/.Xresources" ]] && xrdb -merge "$HOME/.Xresources"
