USER_FOLDERS = bash git i3 pacman term tmux top vim
SYSTEM_FOLDERS = conf
HOSTNAME ?= $(shell cat /etc/hostname)

all: install $(HOSTNAME)-i

clean: uninstall $(HOSTNAME)-u

install:
	stow -d $(HOSTNAME) -t ~ $(USER_FOLDERS)
	sudo stow -d $(HOSTNAME) -t / $(SYSTEM_FOLDERS)
	sudo systemctl enable --now fstrim.timer

galileo-i: ;
kepler-i: ;

uninstall:
	stow -d $(HOSTNAME) -Dt ~ $(USER_FOLDERS)
	sudo stow -d $(HOSTNAME) -Dt / $(SYSTEM_FOLDERS)
	sudo systemctl disable --now fstrim.timer

galileo-u: ;
kepler-u: ;
