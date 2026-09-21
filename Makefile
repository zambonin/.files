USER_FOLDERS = alacritty bash fuzzel git mako niri pacman swayidle \
			   swaylock-effects tmux top vim zathura
NOFOLD_FOLDERS = systemd
SYSTEM_FOLDERS = conf
SYSTEM_FILES = \
	etc/pacman.d/hooks/fwupd.hook \
	etc/pacman.d/hooks/orphans.hook \
	etc/pacman.d/hooks/paccache.hook \
	etc/sysctl.d/99-sysrq.conf \
	etc/systemd/journald.conf.d/10-journald-custom.conf \
	etc/vconsole.conf
SYSTEM_TARGETS = $(addprefix /,$(SYSTEM_FILES))
SYSTEMD_DIR = $(HOME)/.config/systemd
HOSTNAME ?= $(shell uname -n)
$(if $(filter $(HOSTNAME),galileo hypatia kepler),,\
	$(error unsupported host '$(HOSTNAME)', expected galileo, hypatia or kepler))

.PHONY: all clean install uninstall install-user uninstall-user \
	install-system uninstall-system force \
	galileo-i galileo-u hypatia-i hypatia-u kepler-i kepler-u

all: install $(HOSTNAME)-i

clean: uninstall $(HOSTNAME)-u

install: install-user install-system

uninstall: uninstall-user uninstall-system

install-user: | $(SYSTEMD_DIR)
	stow -d $(HOSTNAME) -t $(HOME) $(USER_FOLDERS)
	stow --no-folding -d $(HOSTNAME) -t $(HOME) $(NOFOLD_FOLDERS)

uninstall-user: | $(SYSTEMD_DIR)
	stow -d $(HOSTNAME) -Dt $(HOME) $(USER_FOLDERS)
	stow --no-folding -d $(HOSTNAME) -Dt $(HOME) $(NOFOLD_FOLDERS)
	find $(SYSTEMD_DIR) -mindepth 1 -depth -type d -empty -delete

install-system: $(SYSTEM_TARGETS)
	sudo sysctl --system >/dev/null
	sudo systemctl enable --now fstrim.timer

uninstall-system:
	sudo rm -f $(SYSTEM_TARGETS)
	sudo systemctl disable --now fstrim.timer

$(SYSTEM_TARGETS): /%: $(HOSTNAME)/$(SYSTEM_FOLDERS)/% force
	sudo install -D -o root -g root -m 644 $< $@

$(SYSTEMD_DIR):
	mkdir -p $@

force:

galileo-i: ;
hypatia-i: ;
kepler-i:
	systemctl --user enable --now poweralertd

galileo-u: ;
hypatia-u: ;
kepler-u:
	systemctl --user disable --now poweralertd
