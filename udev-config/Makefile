# Makefile to install udev rules and documentation

PREFIX = /usr
RULES_DIR = /etc/udev/rules.d
INSTALL = install
INSTALL_DATA = $(INSTALL) -m644
RULES_FILES = \
	55-lfs.rules \
	61-cdrom.rules
DOC_FILES = $(RULES_FILES:.rules=.txt)

EXTRA_DOC_FILES = \
	05-udev-early.txt \
	60-persistent-input.txt \
	60-persistent-storage.txt \
	80-drivers.txt \
	95-udev-late.txt

# Location to install the docs
DOC_DIR = $(PREFIX)/share/doc/udev-config

all:

install: install-rules

install-rules:
	$(INSTALL) -d $(DESTDIR)$(RULES_DIR)
	for rule in $(RULES_FILES); do \
		$(INSTALL_DATA) $$rule $(DESTDIR)$(RULES_DIR) || exit 1; \
	done;

install-doc:
	$(INSTALL) -d $(DESTDIR)$(DOC_DIR)
	for doc in $(DOC_FILES); do \
		$(INSTALL_DATA) doc/$$doc $(DESTDIR)$(DOC_DIR) || exit 1; \
	done

install-extra-doc:
	$(INSTALL) -d $(DESTDIR)$(DOC_DIR)
	for doc in $(EXTRA_DOC_FILES); do \
		$(INSTALL_DATA) doc/$$doc $(DESTDIR)$(DOC_DIR) || exit 1; \
	done
