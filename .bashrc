#!/bin/bash
# ~/.bashrc

shopt -s autocd cdspell dirspell checkwinsize

export EDITOR=nano
export VISUAL=subl3

alias back='cd -'
alias cat='cat -ns'
alias chmod='chmod -Rv'
alias compress='tar cvzf'
alias cp='cp -dpruv'
alias df='df -hTx tmpfs --total'
alias diff='diff -rsy --suppress-common-lines --suppress-blank-empty'
alias du='du -chs .[!.]* * | sort -h'
alias find='sudo find / -iname'
alias free='free -h | head -2'
alias grep='grep -i --color=always'
alias less='less -R'
alias ls='ls --color=always --group-directories-first -AFgho'
alias makepkg='makepkg -sCcir --needed --noconfirm'
alias mkdir='mkdir -p'
alias mv='mv -v'
alias pacman='pacman --noconfirm'
alias rm='rm -iRv'
alias rml='rm -f *.{aux,fdb_latexmk,log,out,synctex.gz,txt}'
alias sudo='sudo '

aur() {
    ex "$1"
    IFS='.' read -r filename _ <<< "$1"
    cd "${filename}" || exit
    makepkg
    cd ..
    rm -rf "${filename}" "$1"
}

backup() {
    cp "$1" "${1}-$(date +%Y-%m-%d-%H%M%S)".backup
}

calc() {
    bc -l <<< "$@"
}

ex() {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2|*.tbz2|*.tar.xz) tar xvjf "$1"   ;;
            *.tar.gz|*.tgz)            tar xvzf "$1"   ;;
            *.7z|*.001)                7z x "$1"       ;;
            *.bz2)                     bunzip2 "$1"    ;;
            *.gz)                      gunzip "$1"     ;;
            *.lzma)                    unlzma "$1"     ;;
            *.rar)                     unrar x "$1"    ;;
            *.tar)                     tar xf "$1"     ;;
            *.xz)                      unxz "$1"       ;;
            *.Z)                       uncompress "$1" ;;
            *.zip)                     unzip "$1"      ;;
            *) echo "'$1' cannot be extracted by ex()" ;;
        esac
    fi
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
    expac -HM "%011m\t%-20n\t%10d" <<< "$pkg" | sort -nr | less
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

usd() {
    curl -s dolarhoje.net.br | grep "<br />" | sed '2q;d' | \
    awk '{print $6}' | sed 's/<br//'
}

vm() {
    if [[ ! -f "$HOME/image_file" ]] ; then
        qemu-img create -f raw "$HOME/image_file" 8G
    fi
    qemu-system-x86_64 -m 1G -cpu host -machine type=pc,accel=kvm \
    -drive file="$HOME/image_file",index=0,media=disk,format=raw -cdrom "$1"
}

PS1='\[\e[01;37m\][\A]\[\e[0m\]\[\e[00;37m\] '              # [HH:MM]
PS1+='\[\e[0m\]\[\e[01;34m\]\u\[\e[0m\]\[\e[01;37m\]@\h '   # user@host
PS1+='\[\e[0m\]\[\e[01;34m\]\w\[\e[0m\]\[\e[00;37m\] '      # absolute path
PS1+='\[\e[0m\]\[\e[01;37m\]\\$\[\e[0m\] '                  # $

if pkgfile 2>/dev/null ; then
    source /usr/share/doc/pkgfile/command-not-found.bash
fi

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
