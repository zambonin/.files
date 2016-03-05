# ~/.bashrc

shopt -s autocd cdspell checkwinsize cmdhist dirspell histappend

EDITOR="vim"
HISTFILE="$HOME/.history"
HISTFILESIZE=1000000
HISTSIZE=1000000
HISTTIMEFORMAT='%F %T '
PROMPT_COMMAND='history -a'

aur() {
    pkg="$1.tar.gz"
    curl "https://aur.archlinux.org/cgit/aur.git/snapshot/$pkg" > "$pkg"
    ex "$pkg"
    IFS='.' read -r filename _ <<< "$pkg"
    cd "${filename}" || exit
    makepkg
    cd ..
    rm -rf "${filename}" "$pkg"
}

backup() {
    for file in "$@"; do
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

ex() {
    for file in "$@"; do
        if [ -f "$file" ] ; then
            case "$file" in
                *.tar.bz2|*.tbz2|*.tar.xz) tar xvjf "$file"   ;;
                *.tar.gz|*.tgz)            tar xvzf "$file"   ;;
                *.7z|*.001)                7z x "$file"       ;;
                *.bz2)                     bunzip2 "$file"    ;;
                *.gz)                      gunzip "$file"     ;;
                *.lzma)                    unlzma "$file"     ;;
                *.rar)                     unrar x "$file"    ;;
                *.tar)                     tar xf "$file"     ;;
                *.xz)                      unxz "$file"       ;;
                *.Z)                       uncompress "$file" ;;
                *.zip)                     unzip "$file"      ;;
                *) echo "'$file' cannot be extracted by ex()" ;;
            esac
        else
            echo "'$file' does not exist!"
        fi
    done
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
        if [ -d "$d/.git" ] ; then
            output=$(git -C "$d" "$1")
            grep -q nothing <<< "$(sed '3q;d' <<< "$output")"
            if [[ "$1" = "status" && ! $? -eq 0 ]] || \
               [[ "$1" = "diff" && "$output" ]] ; then
                echo -e "\033[1m$d\033[0m"
                echo "$output"
            fi
        fi
    done
}

pacsize() {
    pkg=$(comm -23 <(pacman -Qqe | sort) <(pacman -Qqg base base-devel | sort))
    expac -HM "%011m\t%-25n\t%10d" <<< "$pkg" | sort -nr | less
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
        -machine type=pc,accel=kvm \
        -monitor stdio \
        -drive file="$HOME/vmdisk",index=0,media=disk,format=raw \
        "$@"
}

PS1='\[\e[01;37m\][\A]\[\e[0m\]\[\e[00;37m\] '              # [HH:MM]
PS1+='\[\e[0m\]\[\e[01;34m\]\u\[\e[0m\]\[\e[01;37m\]@\h '   # user@host
PS1+='\[\e[0m\]\[\e[01;34m\]\w\[\e[0m\]\[\e[00;37m\] '      # absolute path
PS1+='\[\e[0m\]\[\e[01;37m\]\\$\[\e[0m\] '                  # $

[ -f "$HOME/.aliases" ] && . "$HOME/.aliases"

if pkgfile 2>/dev/null ; then
    . /usr/share/doc/pkgfile/command-not-found.bash
fi

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
