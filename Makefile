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
HOSTNAME ?= $(shell uname -n)
ifeq ($(HOSTNAME),hypatia)
USER_FOLDERS := $(filter-out swayidle swaylock-effects,$(USER_FOLDERS))
USER_FOLDERS += autostart guacamole
SYSTEM_FILES += \
	etc/niri/headless-display.sh \
	etc/systemd/system/hypatia-headless-display.service \
	etc/systemd/system/getty@tty1.service.d/autologin.conf \
	usr/lib/firmware/edid/hypatia-1080p.bin
endif
SYSTEM_TARGETS = $(addprefix /,$(SYSTEM_FILES))
SYSTEMD_DIR = $(HOME)/.config/systemd
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
hypatia-i:
	docker compose --project-directory $(HOME)/guacamole build wayvnc
	docker compose --project-directory $(HOME)/guacamole up -d guacd guacamole
	systemctl --user enable guacamole-desktop.service
	sudo systemctl daemon-reload
	sudo systemctl set-default multi-user.target
	sudo systemctl enable --now hypatia-headless-display.service getty@tty1.service
kepler-i:
	systemctl --user enable --now poweralertd

galileo-u: ;
hypatia-u: ;
kepler-u:
	systemctl --user disable --now poweralertd
