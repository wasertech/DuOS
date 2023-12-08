DESTDIR ?= /
PREFIX  ?= usr/local

install:
	@echo -n "Installing..."
	@chmod 755 ./install.sh
	@bash ./install.sh || true
	@echo "Done!"

uninstall:
	@echo -n "Uninstalling..."
	@rm -rf $(DESTDIR)$(PREFIX)/bin/$(TARGET)
	@echo "Done!"
