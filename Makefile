DESTDIR ?= /
PREFIX  ?= usr/local

install:
	@echo -n "Installing..."
	@mkdir -p $(DESTDIR)$(PREFIX)/bin
	@cp -f $(TARGET) $(DESTDIR)$(PREFIX)/bin
	@chmod 755 $(DESTDIR)$(PREFIX)/bin/$(TARGET)
	@echo "Done!"

uninstall:
	@echo -n "Uninstalling..."
	@rm -f $(DESTDIR)$(PREFIX)/bin/$(TARGET)
	@echo "Done!"
