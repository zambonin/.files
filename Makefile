USER_FOLDERS = bash git i3 pacman tmux top vim x11
SYSTEM_FOLDERS = conf

all: install $(shell hostname)-i

clean: uninstall $(shell hostname)-u

build:
	sudo pacman -Syu - < $(shell hostname)/pacman/PACKAGES.list

install:
	stow -d $(shell hostname) --ignore=.list -t ~ $(USER_FOLDERS)
	sudo stow -d $(shell hostname) -t / $(SYSTEM_FOLDERS)
	sudo systemctl enable suspend@$(shell whoami)
	sudo systemctl enable --now getty@tty11 getty@tty12
	systemctl --user enable redshift

galileo-i: ;
kepler-i: ;
hubble-i:
	sudo systemctl enable --now backup.timer

uninstall:
	stow -d $(shell hostname) -Dt ~ $(USER_FOLDERS)
	sudo stow -d $(shell hostname) -Dt / $(SYSTEM_FOLDERS)
	sudo systemctl disable suspend@$(shell whoami)
	sudo systemctl disable --now getty@tty11 getty@tty12
	systemctl --user disable redshift

galileo-u: ;
kepler-u: ;
hubble-u:
	sudo systemctl disable --now backup.timer
