# ~/.bashrc

[ -z "$PS1" ] && return

shopt -s autocd cdspell dirspell checkwinsize

export EDITOR=nano
export VISUAL=subl3

alias back='cd -'
alias cat='cat -ns'
alias chmod='chmod -Rv'
alias cp='cp -dpruv'
alias df='df -hTx tmpfs --total'
alias diff='diff -rsy --suppress-common-lines --suppress-blank-empty'
alias du='du -sh'
alias find='sudo find / -name'
alias free='free -hw'
alias ls='ls --color=auto --group-directories-first -AFgho'
alias makepkg='makepkg -sCcir --needed --noconfirm'
alias mv='mv -v'
alias pacman='pacman --noconfirm'
alias rm='rm -iRv'
alias sudo='sudo '

function mkdir {
    command mkdir -pv "$1" && cd "$1"
}

aur() {
    ex $1
    IFS='.' read filename extension <<< $1
    cd ${filename}
    makepkg
    cd ..
    rm -rf ${filename} $1
}

backup() {
    cp $1 ${1}-`date +%Y-%m-%d-%H%M%S`.backup
}

ex() {
    if [ -n "$1" ] ; then
        case "$1" in
            *.7z|*.001)                7z x "$1"       ;;
            *.bz2)                     bunzip2 "$1"    ;;
            *.gz)                      gunzip "$1"     ;;
            *.lzma)                    unlzma "$1"     ;;
            *.rar)                     unrar x "$1"    ;;
            *.tar)                     tar xf "$1"     ;;
            *.tar.bz2|*.tbz2|*.tar.xz) tar xvjf "$1"   ;;
            *.tar.gz|*.tgz)            tar xvzf "$1"   ;;
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

pacsize() {
    packages=$(comm -23 <(pacman -Qqe) <(pacman -Qqg base base-devel | sort))
    expac -HM "%011m\t%-20n\t%10d" $packages | sort -n
}

up() {
    local d=""
    limit=$1
    for ((i = 1; i <= limit; i++))
        do
            d=$d/..
        done
    d=$(echo $d | sed 's/^\///')
    if [ -z "$d" ]; then
        d=..
    fi
    cd $d
}

PS1='\[\e[01;37m\][\A]\[\e[0m\]\[\e[00;37m\] '              # [HH:MM]
PS1+='\[\e[0m\]\[\e[01;34m\]\u\[\e[0m\]\[\e[01;37m\]@\h '   # user@host
PS1+='\[\e[0m\]\[\e[01;34m\]\w\[\e[0m\]\[\e[00;37m\] '      # absolute path
PS1+='\[\e[0m\]\[\e[01;37m\]\\$\[\e[0m\] '                  # $

source /usr/share/doc/pkgfile/command-not-found.bash

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
