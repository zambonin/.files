USER_FOLDERS = bash git i3 pacman term tmux top vim
SYSTEM_FOLDERS = conf
HOSTNAME ?= $(shell cat /etc/hostname)

SYSRQ_FILE = /etc/sysctl.d/99-sysrq.conf

all: install $(HOSTNAME)-i

clean: uninstall $(HOSTNAME)-u

install:
	stow -d $(HOSTNAME) -t ~ $(USER_FOLDERS)
	sudo stow -d $(HOSTNAME) -t / $(SYSTEM_FOLDERS)
	sudo systemctl enable --now fstrim.timer
	echo "kernel.sysrq = 1" | sudo tee $(SYSRQ_FILE) >/dev/null

galileo-i: ;
kepler-i: ;

uninstall:
	stow -d $(HOSTNAME) -Dt ~ $(USER_FOLDERS)
	sudo stow -d $(HOSTNAME) -Dt / $(SYSTEM_FOLDERS)
	sudo systemctl disable --now fstrim.timer
	sudo $(RM) $(SYSRQ_FILE)

galileo-u: ;
kepler-u: ;
