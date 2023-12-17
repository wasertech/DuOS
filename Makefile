DESTDIR ?= /
PREFIX  ?= usr/local

install:
	@echo -n "Installing..."
	@chmod 755 ./install
	@bash ./install || true
	@echo "Done!"


uninstall:
	@echo -n "Uninstalling..."
	@rm -rf $(DESTDIR)$(PREFIX)/bin/deux.sh
	@rm -rf $(DESTDIR)$(PREFIX)/bin/deux.zsh
	@echo "Done!"
