# ~/.bashrc
#
# If not running interactively, don't do anything

[[ $- != *i* ]] && return

alias back='cd $OLDPWD'
alias cat='cat -ns'
alias chmod='chmod -Rv'
alias cp='cp -dpruv'
alias df='df -hTx tmpfs --total'
alias down='cd'
alias find='sudo find / -name $1'
alias free='free -hw'
alias ls='ls --color=auto --group-directories-first -AFgho'
alias makepkg='makepkg -sCcir --noconfirm'
alias mv='mv -v'
alias rm='rm -Rv'

function mkdir {
	command mkdir -pv $1 && cd $1
}

ex() {
	if [ -f $1 ] ; then
	case $1 in
		*.tar.bz2)	tar xjf $1	;;
		*.tar.gz)	tar xzf $1	;;
		*.bz2)		bunzip2 $1	;;
		*.rar)		unrar x $1	;;
		*.gz)		gunzip $1	;;
		*.tar)		tar xf $1	;;
		*.tbz2)		tar xjf $1	;;
		*.tgz)		tar xzf $1	;;
		*.zip)		unzip $1	;;
		*.Z)		uncompress $1 ;;
		*.7z)		7z x $1	;;
		*)			echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
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

PS1='\[\e[01;37m\][\A]\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[01;32m\]\u\[\e[0m\]\[\e[01;37m\]@\h \[\e[0m\]\[\e[01;32m\]\w\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[01;37m\]\\$\[\e[0m\] '
