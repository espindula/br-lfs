# Makefile to install udev rules and documentation

PREFIX = /usr
RULES_DIR = /etc/udev/rules.d
INSTALL = install
INSTALL_DATA = $(INSTALL) -m644
INSTALL_EXEC = $(INSTALL) -m755
RULES_FILES = \
	55-lfs.rules
DOC_FILES = $(RULES_FILES:.rules=.txt)

# Location to install the docs
DOC_DIR = $(PREFIX)/share/doc/udev-config

# for files shipped with udev up to version 182
SYS_LIB = /lib/udev
SYS_RULES_DIR = $(SYS_LIB)/rules.d
SYS_RULES = 75-cd-aliases-generator.rules \
            75-persistent-net-generator.rules
SYS_FUNCTIONS = rule_generator.functions
SYS_SCRIPTS = write_cd_rules write_net_rules

all:

install: install-rules

install-rules:
	$(INSTALL) -d $(DESTDIR)$(RULES_DIR)
	for rule in $(RULES_FILES); do \
		$(INSTALL_DATA) $$rule $(DESTDIR)$(RULES_DIR) || exit 1; \
	done;
	$(INSTALL) -d $(DESTDIR)$(SYS_LIB)
	for function in $(SYS_FUNCTIONS); do \
		$(INSTALL_DATA) rule_generator/$$function $(DESTDIR)$(SYS_LIB) || exit 1; \
	done;
	for script in $(SYS_SCRIPTS); do \
		$(INSTALL_EXEC) rule_generator/$$script $(DESTDIR)$(SYS_LIB) || exit 1; \
	done;
	$(INSTALL) -d $(DESTDIR)$(SYS_RULES_DIR)
	for rule in $(SYS_RULES); do \
		$(INSTALL_DATA) rule_generator/$$rule $(DESTDIR)$(SYS_RULES_DIR) || exit 1; \
	done;

install-doc:
	$(INSTALL) -d $(DESTDIR)$(DOC_DIR)
	for doc in $(DOC_FILES); do \
		$(INSTALL_DATA) doc/$$doc $(DESTDIR)$(DOC_DIR) || exit 1; \
	done
