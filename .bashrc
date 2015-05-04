     1	# ~/.bashrc
     2	#
     3	# If not running interactively, don't do anything
     4	[ -z "$PS1" ] && return
     5	
     6	alias back='cd $OLDPWD'
     7	alias cat='cat -ns'
     8	alias chmod='chmod -Rv'
     9	alias cp='cp -dpruv'
    10	alias df='df -hTx tmpfs --total'
    11	alias diff='diff -rsy --suppress-common-lines --suppress-blank-empty $1'
    12	alias du='du -sh $1'
    13	alias find='sudo find / -name $1'
    14	alias free='free -hw'
    15	alias ls='ls --color=auto --group-directories-first -AFgho'
    16	alias makepkg='makepkg -sCcir --noconfirm'
    17	alias mv='mv -v'
    18	alias pacman='pacman --noconfirm'
    19	alias rm='rm -iRv'
    20	alias sudo='sudo '
    21	
    22	function mkdir {
    23		command mkdir -pv "$1" && cd "$1"
    24	}
    25	
    26	ex() {
    27		while [ -n "$1" ]
    28			do
    29				case "$1" in
    30					*.tar.bz2)	tar xjf "$1"	;;
    31					*.tar.gz)	tar xzf "$1"	;;
    32					*.bz2)		bunzip2 "$1"	;;
    33					*.rar)		unrar x "$1"	;;
    34					*.gz)		gunzip "$1"		;;
    35					*.tar)		tar xf "$1"		;;
    36					*.tbz2)		tar xjf "$1"	;;
    37					*.tgz)		tar xzf "$1"	;;
    38					*.zip)		unzip "$1"		;;
    39					*.Z)		uncompress "$1" ;;
    40					*.7z)		7z x "$1"		;;
    41					*)			echo "'$1' cannot be extracted via ex()" ;;
    42				esac
    43				shift
    44			done
    45	}
    46	
    47	man() {
    48		env LESS_TERMCAP_mb=$'\E[01;31m' \
    49		LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    50		LESS_TERMCAP_me=$'\E[0m' \
    51		LESS_TERMCAP_se=$'\E[0m' \
    52		LESS_TERMCAP_so=$'\E[38;5;246m' \
    53		LESS_TERMCAP_ue=$'\E[0m' \
    54		LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    55		man "$@"
    56	}
    57	
    58	up() {
    59		local d=""
    60		limit=$1
    61		for ((i = 1; i <= limit; i++))
    62			do
    63				d=$d/..
    64			done
    65		d=$(echo $d | sed 's/^\///')
    66		if [ -z "$d" ]; then
    67			d=..
    68		fi
    69		cd $d
    70	}
    71	
    72	PS1='\[\e[01;37m\][\A]\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[01;32m\]\u\[\e[0m\]\[\e[01;37m\]@\h \[\e[0m\]\[\e[01;32m\]\w\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[01;37m\]\\$\[\e[0m\] '
    73	source /usr/share/doc/pkgfile/command-not-found.bash
    74	
    75	[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
