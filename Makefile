DESTDIR ?= /
PREFIX  ?= usr/local

install:
	@echo -n "Installing..."
	@chmod 755 ./install.sh
	@bash ./install.sh || true
	@echo "Done!"

install-gui:
	@echo -n "Installing..."
	@chmod 755 ./install.sh
	@bash ./install-gui.sh || true
	@echo "Done!"

uninstall:
	@echo -n "Uninstalling..."
	@rm -rf $(DESTDIR)$(PREFIX)/bin/deux.sh
	@rm -rf $(DESTDIR)$(PREFIX)/bin/deux.zsh
	@echo "Done!"
