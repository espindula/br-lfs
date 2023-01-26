# vim:ts=3
# Makefile for BLFS Book generation.
# By Tushar Teredesai <tushar@linuxfromscratch.org>
# 2004-01-31

# Adjust these to suit your installation
RENDERTMP   ?= $(HOME)/tmp
CHUNK_QUIET  = 1
ROOT_ID      =
SHELL        = /bin/bash

#PYHOSTED = general/prog/python-dependencies/pythonhosted.xml
#ALLXML := $(filter-out $(RENDERTMP)/%, \
#	$(filter-out $(PYHOSTED), \
#	$(wildcard *.xml */*.xml */*/*.xml */*/*/*.xml */*/*/*/*.xml)))
ALLXML := $(filter-out $(RENDERTMP)/%, \
            $(wildcard *.xml */*.xml */*/*.xml */*/*/*.xml */*/*/*/*.xml))
ALLXSL := $(filter-out $(RENDERTMP)/%, \
            $(wildcard *.xsl */*.xsl */*/*.xsl */*/*/*.xsl */*/*/*/*.xsl))

ifdef V
  Q =
else
  Q = @
endif

ifndef REV
  REV = sysv
endif

ifneq ($(REV), sysv)
  ifneq ($(REV), systemd)
    $(error REV must be 'sysv' (default) or 'systemd'.)
  endif
endif

# Let's get the previous REV: it'll be used to see if we should
# rebuild version.ent
PREVREV != if [ -f conditional.ent ]; then \
              gawk '/INCLUDE/{ print $$3 }' conditional.ent; \
           fi

ifeq ($(REV), sysv)
  BASEDIR         ?= $(HOME)/public_html/blfs-book
  NOCHUNKS_OUTPUT ?= blfs-book.html
  DUMPDIR         ?= ~/blfs-commands
  BLFSHTML        ?= blfs-html.xml
  BLFSHTML2       ?= blfs-html2.xml
  BLFSFULL        ?= blfs-full.xml
else
  BASEDIR         ?= $(HOME)/public_html/blfs-systemd
  NOCHUNKS_OUTPUT ?= blfs-sysd-book.html
  DUMPDIR         ?= ~/blfs-sysd-commands
  BLFSHTML        ?= blfs-systemd-html.xml
  BLFSHTML2       ?= blfs-systemd-html2.xml
  BLFSFULL        ?= blfs-systemd-full.xml

endif

blfs: html wget-list

help:
	@echo ""
	@echo "make <parameters> <targets>"
	@echo ""
	@echo "Parameters:"
	@echo "  REV=<rev>            Build variation of book"
	@echo "                       Valid values for REV are:"
	@echo "                       * sysv    - Build book for SysV"
	@echo "                       * systemd - Build book for systemd"
	@echo "                       Defaults to 'sysv'"
	@echo ""
	@echo "  BASEDIR=<dir>        Put the output in directory <dir>."
	@echo "                       Defaults to"
	@echo "                       'HOME/public_html/blfs-book' if REV=sysv (or unset)"
	@echo "                       or to"
	@echo "                       'HOME/public_html/blfs-book-systemd' if REV=systemd"
	@echo ""
	@echo "  V=<val>              If <val> is a non-empty value, all"
	@echo "                       steps to produce the output is shown."
	@echo "                       Default is unset."
	@echo ""
	@echo "Targets:"
	@echo "  help                 Show this help text."
	@echo ""
	@echo "  blfs                 Builds targets 'html' and 'wget-list'."
	@echo ""
	@echo "  html                 Builds the HTML pages of the book."
	@echo ""
	@echo "  wget-list            Produces a list of all packages to download."
	@echo "                       Output is BASEDIR/wget-list"
	@echo ""
	@echo "  nochunks             Builds the book as a one-pager. The output"
	@echo "                       is a large single HTML page containing the"
	@echo "                       whole book."
	@echo ""
	@echo "                       Parameter NOCHUNKS_OUTPUT=<filename> controls"
	@echo "                       the name of the HTML file."
	@echo ""
	@echo "  validate             Runs validation checks on the XML files."
	@echo ""
	@echo "  test-links           Runs validation checks on URLs in the book."
	@echo "                       Produces a file named BASEDIR/bad_urls containing"
	@echo "                       URLS which are invalid and a BASEDIR/good_urls"
	@echo "                       containing all valid URLs."
	@echo ""

all: blfs nochunks
world: all blfs-patch-list dump-commands test-links

include epub.mk
include pdf.mk
html: $(BASEDIR)/index.html
$(BASEDIR)/index.html: $(RENDERTMP)/$(BLFSHTML)
	@echo "Generating chunked XHTML files..."
	$(Q)xsltproc --nonet                                    \
                --stringparam chunk.quietly $(CHUNK_QUIET) \
                --stringparam rootid "$(ROOT_ID)"          \
                --stringparam base.dir $(BASEDIR)/         \
                stylesheets/blfs-chunked.xsl               \
                $(RENDERTMP)/$(BLFSHTML)

	@echo "Copying CSS code and images..."
	$(Q)if [ ! -e $(BASEDIR)/stylesheets ]; then \
      mkdir -p $(BASEDIR)/stylesheets;          \
   fi;

	$(Q)cp stylesheets/lfs-xsl/*.css $(BASEDIR)/stylesheets
	$(Q)sed -i 's|../stylesheet|stylesheet|' $(BASEDIR)/index.html

	$(Q)if [ ! -e $(BASEDIR)/images ]; then \
      mkdir -p $(BASEDIR)/images;          \
   fi;
	$(Q)cp images/*.png $(BASEDIR)/images

	$(Q)cd $(BASEDIR)/; sed -e "s@../images@images@g"           \
                           -i *.html

	@echo "Running Tidy and obfuscate.sh on chunked XHTML..."
	$(Q)for filename in `find $(BASEDIR) -name "*.html"`; do       \
      tidy -config tidy.conf $$filename;                          \
      true;                                                       \
      bash obfuscate.sh $$filename;                               \
      sed -i -e "1,20s@text/html@application/xhtml+xml@g" $$filename; \
   done;

nochunks: $(BASEDIR)/$(NOCHUNKS_OUTPUT)
$(BASEDIR)/$(NOCHUNKS_OUTPUT): $(RENDERTMP)/$(BLFSHTML)
	@echo "Generating non-chunked XHTML file..."
	$(Q)xsltproc --nonet                                \
                --stringparam rootid "$(ROOT_ID)"      \
                --output $(BASEDIR)/$(NOCHUNKS_OUTPUT) \
                stylesheets/blfs-nochunks.xsl          \
                $(RENDERTMP)/$(BLFSHTML)

	@echo "Running Tidy and obfuscate.sh on non-chunked XHTML..."
	$(Q)tidy -config tidy.conf $(BASEDIR)/$(NOCHUNKS_OUTPUT) || true
	$(Q)bash obfuscate.sh $(BASEDIR)/$(NOCHUNKS_OUTPUT)
	$(Q)sed -i -e "1,20s@text/html@application/xhtml+xml@g" $(BASEDIR)/$(NOCHUNKS_OUTPUT)

tmpdir: $(RENDERTMP)
$(RENDERTMP):
	@echo "Creating $(RENDERTMP)"
	$(Q)[ -d $(RENDERTMP) ] || mkdir -p $(RENDERTMP)

clean:
	@echo "Cleaning $(RENDERTMP)"
	$(Q)rm -f $(RENDERTMP)/blfs*

validate: $(RENDERTMP)/$(BLFSFULL)
#$(RENDERTMP)/$(BLFSFULL): $(PYHOSTED) version.ent
$(RENDERTMP)/$(BLFSFULL): version.ent
	$(Q)[ -d $(RENDERTMP) ] || mkdir -p $(RENDERTMP)

	@echo "Adjusting for revision $(REV)..."
	$(Q)xsltproc --nonet                               \
                --xinclude                            \
                --output $(RENDERTMP)/$(BLFSHTML2)    \
                --stringparam profile.revision $(REV) \
                stylesheets/lfs-xsl/profile.xsl       \
                index.xml

	@echo "Validating the book..."
	$(Q)xmllint --nonet                             \
               --noent                             \
               --postvalid                         \
               --output $(RENDERTMP)/$(BLFSFULL)   \
               $(RENDERTMP)/$(BLFSHTML2)

profile-html: $(RENDERTMP)/$(BLFSHTML)
$(RENDERTMP)/$(BLFSHTML): $(RENDERTMP)/$(BLFSFULL)
	@echo "Generating profiled XML for XHTML..."
	$(Q)xsltproc --nonet                              \
                --stringparam profile.condition html \
                --output $(RENDERTMP)/$(BLFSHTML)    \
                stylesheets/lfs-xsl/profile.xsl      \
                $(RENDERTMP)/$(BLFSFULL)

blfs-patch-list: blfs-patches.sh
	@echo "Generating blfs patch list..."
	$(Q)awk '{if ($$1 == "copy") {sub(/.*\//, "", $$2); print $$2}}' \
	  blfs-patches.sh > blfs-patch-list

blfs-patches.sh: $(RENDERTMP)/$(BLFSFULL)
	@echo "Generating blfs patch script..."
	$(Q)xsltproc --nonet                     \
                --output blfs-patches.sh    \
                stylesheets/patcheslist.xsl \
                $(RENDERTMP)/$(BLFSFULL)

wget-list: $(BASEDIR)/wget-list
$(BASEDIR)/wget-list: $(RENDERTMP)/$(BLFSFULL)
	@echo "Generating wget list for $(REV) at $(BASEDIR)/wget-list ..."
	$(Q)mkdir -p $(BASEDIR)
	$(Q)xsltproc --nonet                       \
                --output $(BASEDIR)/wget-list \
                stylesheets/wget-list.xsl     \
                $(RENDERTMP)/$(BLFSFULL)

test-links: $(BASEDIR)/test-links
$(BASEDIR)/test-links: $(RENDERTMP)/$(BLFSFULL)
	@echo "Generating test-links file..."
	$(Q)mkdir -p $(BASEDIR)
	$(Q)xsltproc --nonet                        \
                --stringparam list_mode full   \
                --output $(BASEDIR)/test-links \
                stylesheets/wget-list.xsl      \
                $(RENDERTMP)/$(BLFSFULL)

	@echo "Checking URLs, first pass..."
	$(Q)rm -f $(BASEDIR)/{good,bad,true_bad}_urls
	$(Q)for URL in `cat $(BASEDIR)/test-links`; do                     \
         wget --spider --tries=2 --timeout=60 $$URL >>/dev/null 2>&1; \
         if test $$? -ne 0 ; then                                     \
            echo $$URL >> $(BASEDIR)/bad_urls ;                       \
         else                                                         \
            echo $$URL >> $(BASEDIR)/good_urls 2>&1;                  \
         fi;                                                          \
   done

	@echo "Checking URLs, second pass..."
	$(Q)for URL2 in `cat $(BASEDIR)/bad_urls`; do                       \
         wget --spider --tries=2 --timeout=60 $$URL2 >>/dev/null 2>&1; \
         if test $$? -ne 0 ; then                                      \
           echo $$URL2 >> $(BASEDIR)/true_bad_urls ;                   \
         else                                                          \
           echo $$URL2 >> $(BASEDIR)/good_urls 2>&1;                   \
         fi; \
   done

bootscripts:
	@VERSION=`grep "bootscripts-version " general.ent | cut -d\" -f2`; \
   BOOTSCRIPTS="blfs-bootscripts-$$VERSION";                          \
   if [ ! -e $$BOOTSCRIPTS.tar.xz ]; then                             \
     rm -rf $(RENDERTMP)/$$BOOTSCRIPTS;                               \
     mkdir $(RENDERTMP)/$$BOOTSCRIPTS;                                \
     cp -a ../bootscripts/* $(RENDERTMP)/$$BOOTSCRIPTS;               \
     rm -rf ../bootscripts/archive;                                   \
     tar  -cJhf $$BOOTSCRIPTS.tar.xz -C $(RENDERTMP) $$BOOTSCRIPTS;   \
   fi

systemd-units:
	@VERSION=`grep "systemd-units-version " general.ent | cut -d\" -f2`; \
   UNITS="blfs-systemd-units-$$VERSION";                                \
   if [ ! -e $$UNITS.tar.xz ]; then                                     \
     rm -rf $(RENDERTMP)/$$UNITS;                                       \
     mkdir $(RENDERTMP)/$$UNITS;                                        \
     cp -a ../systemd-units/* $(RENDERTMP)/$$UNITS;                     \
     tar -cJhf $$UNITS.tar.xz -C $(RENDERTMP) $$UNITS;                  \
   fi

dump-commands: $(DUMPDIR)
$(DUMPDIR): $(RENDERTMP)/$(BLFSFULL)
	@echo "Dumping book commands..."
	$(Q)xsltproc --output $(DUMPDIR)/          \
                stylesheets/dump-commands.xsl \
                $(RENDERTMP)/$(BLFSFULL)
	$(Q)touch $(DUMPDIR)

.PHONY: blfs all world html nochunks tmpdir clean  \
   validate profile-html blfs-patch-list wget-list \
	test-links dump-commands  bootscripts systemd-units

# make version.ent unconditionally if we have changed REV
ifneq ($(REV), $(PREVREV))
   .PHONY: version.ent
endif

version.ent: git-version.sh general.ent packages.ent gnome.ent $(ALLXML) $(ALLXSL) Makefile
	$(Q)./$< $(REV) $^

#ALL_PYTHON_DEPS := $(filter-out $(PYHOSTED), \
#                   $(wildcard general/prog/python-dependencies/*.xml))
#
#PYTHONHOSTED_MODS := requests sphinx_rtd_theme pytest gi-docgen
#
#PYTHONHOSTED_MOD_PAGES := $(addprefix general/prog/python-modules/,\
#                          $(addsuffix .xml,$(PYTHONHOSTED_MODS)))
#
#$(PYHOSTED): $(ALL_PYTHON_DEPS)           \
#             $(PYTHONHOSTED_MOD_PAGES)    \
#             stylesheets/pyhosted-inc.xsl \
#             stylesheets/pythonhosted.xsl | version.ent
#	@echo Generating pythonhosted.xml; \
#   if [ ! -f $@ ]; then               \
#      cp dummy.xml $(PYHOSTED);       \
#   fi
#	$(Q)xsltproc --xinclude                                    \
#                --output temp.xml                             \
#                --stringparam packages "$(PYTHONHOSTED_MODS)" \
#                stylesheets/pythonhosted.xsl                  \
#                general/prog/python-modules.xml
#	$(Q)mv temp.xml $@
