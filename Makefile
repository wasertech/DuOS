DESTDIR ?= /
PREFIX  ?= usr/local

install:
	@echo -n "Installing..."
	@chmod 755 ./install.sh
	@bash ./install.sh
	@echo "Done!"

uninstall:
	@echo -n "Uninstalling..."
	@rm -f $(DESTDIR)$(PREFIX)/bin/$(TARGET)
	@echo "Done!"
