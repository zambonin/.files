USER_FOLDERS = bash git i3 pacman tmux top vim
SYSTEM_FOLDERS = conf

all: install $(shell hostname)-i

clean: uninstall $(shell hostname)-u

install:
	stow -d $(shell hostname) --ignore=.list -t ~ $(USER_FOLDERS)
	sudo stow -d $(shell hostname) -t / $(SYSTEM_FOLDERS)
	sudo systemctl enable suspend@$(shell whoami)
	sudo systemctl enable --now fstrim.timer
	systemctl --user enable redshift

galileo-i: ;
kepler-i: ;
hubble-i: ;

uninstall:
	stow -d $(shell hostname) -Dt ~ $(USER_FOLDERS)
	sudo stow -d $(shell hostname) -Dt / $(SYSTEM_FOLDERS)
	sudo systemctl disable suspend@$(shell whoami)
	sudo systemctl disable --now fstrim.timer
	systemctl --user disable redshift

galileo-u: ;
kepler-u: ;
hubble-u: ;
