USER_FOLDERS = bash git i3 pacman tmux top vim x11
SYSTEM_FOLDERS = conf

all: install $(shell hostname)-i

clean: uninstall $(shell hostname)-u

install:
	stow -d $(shell hostname) --ignore=.list -t ~ $(USER_FOLDERS)
	sudo stow -d $(shell hostname) -t / $(SYSTEM_FOLDERS)
	sudo systemctl enable suspend@$(shell whoami)
	systemctl --user enable redshift

galileo-i: ;
kepler-i: ;

uninstall:
	stow -d $(shell hostname) -Dt ~ $(USER_FOLDERS)
	sudo stow -d $(shell hostname) -Dt / $(SYSTEM_FOLDERS)
	sudo systemctl disable suspend@$(shell whoami)
	systemctl --user disable redshift

galileo-u: ;
kepler-u: ;

build:
	sudo pacman -Syu - < $(shell hostname)/pacman/PACKAGES.list
hubble-i:
	sudo systemctl enable --now backup.timer
hubble-u:
	sudo systemctl disable --now backup.timer
