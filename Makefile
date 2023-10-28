# Configuration
DESTDIR = /usr
REPO_PATH = $(shell pwd)
BUILD_FOLDER = $(REPO_PATH)/build
FIREJAIL_CONFIG_FOLDER = $(HOME)/.config/firejail

# Tar to extract
VERSION = $(shell cat ./source/version)
RELEASE = $(shell cat ./source/release)
TAR = source/librewolf-$(VERSION)-$(RELEASE).*.tar.bz2

all: extract

build-folder:
	@echo "Generating build folder"
	mkdir -p $(BUILD_FOLDER)

clean:
	@echo "Removing build folder"
	rm -rf $(BUILD_FOLDER)
	@echo "Reset .desktop file..."
	sed -i -e "s|Icon=.*|Icon=icon.svg|g" librewolf.desktop

extract: clean build-folder
	@echo "Extracting tar: $(TAR)"
	tar -xf $(TAR) -C $(BUILD_FOLDER)
	@echo "Extracting completed"

install: build-folder
	@echo "Changing to superuser to create the symlink..."
	su -c "ln -sf $(BUILD_FOLDER)/librewolf/librewolf /usr/bin/librewolf"
	
desktop:
	@echo "Updating and installing .desktop file..."
	sed -i -e "s|Icon=.*|Icon=$(REPO_PATH)/icon.svg|g" librewolf.desktop
	mkdir -p $(HOME)/.local/share/applications
	cp librewolf.desktop $(HOME)/.local/share/applications

firejail:
	@echo "Creating firejail config"
	mkdir -p $(FIREJAIL_CONFIG_FOLDER)
	cp librewolf.local $(FIREJAIL_CONFIG_FOLDER)
	@echo "Changing to superuser to create the firejail symlink"
	su -c "ln -sf /usr/bin/firejail /usr/local/bin/librewolf"

uninstall: clean
	@echo "Changing to superuser to remove the symlinks from the system..."
	su -c "rm -f $(DESTDIR)$(PREFIX)/bin/librewolf $(DESTDIR)$(PREFIX)/local/bin/librewolf"
	@echo "Removing firejail config"
	rm $(FIREJAIL_CONFIG_FOLDER)/librewolf.local
	@echo "Removing desktop entry"
	rm $(HOME)/.local/share/applications/librewolf.desktop

.PHONY: all build-folder clean extract install desktop firejail uninstall
