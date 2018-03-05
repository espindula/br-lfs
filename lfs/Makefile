#!/usr/bin/make -f

# Use make L=... to build only a subset of the languages.

LANGUAGES := fr
LANG_fr := fr_FR.UTF-8
L = all

# Use config.mk to configure username and password for download and upload
include config.mk

ORIGDIR := lfs-en

FR_REPO:=svn://svn.linuxfromscratch.org/fr-lfs
EN_REPO:=svn://svn.linuxfromscratch.org/LFS

RENDERTMP=~/tmp


# Note for releasing a new stable version:
# ----------------------------------------
#
# When a new stable version is released upstream, this Makefile will automatically
# track it, so translate it as usual. Once the stable version is translated,
# create a new branch that keeps tracking this release:
#
#   svn cp http://svn.linuxfromscratch.org/fr-lfs/trunk/lfs \
#          http://svn.linuxfromscratch.org/fr-lfs/branches/lfs-$(MILESTONE)
#
# Once this is done, you can publish the new version by running:
#
#   make upload
#
# Then, update the MILESTONE to the next (unreleased) version of LFS in the
# development branch and commit.

# What we follow from upstream.
MILESTONE := 8.3

# Select the current version we are tracking from master
EN_CURR_VER := $(shell svn info $(ORIGDIR) | grep ^URL | sed 's|^[^s]*||')
REVISION := $(shell svn info $(ORIGDIR) | grep ^Revision | sed 's|^.* ||')

# What this does is that it selects either the development version (if our milestone
# is the same as upstream) or the stable version (if it does not match, meaning
# that the stable version is released).
ifeq ($(EN_CURR_VER), $(EN_REPO)/tags/$(MILESTONE))
TAG := $(MILESTONE)
else
TAG := trunk
endif

ifneq ($(MILESTONE), $(shell ((grep milestone $(ORIGDIR)/general.ent || echo $(MILESTONE)) | sed 's|.*"\(.*\)".*|\1|')))
TAG := $(MILESTONE)
endif

# Depending on what we track, we choose the correct branch from upstream.
ifeq ($(TAG), trunk)
EN_VER := trunk/BOOK
else
EN_VER := tags/$(TAG)
endif

# echo is not portable acroos shells. Let's use printf.
ECHO:=printf

# Files that are needed for the build process once translations are generated.
filestocopy := INSTALL README process-scripts.sh obfuscate.sh pdf-fixups.sh \
               bootscripts udev-lfs aux-file-data.sh make-aux-files.sh
# Additional files that may require some changes.
filestoget := $(filestocopy) packages.ent tidy.conf patches.ent general.ent Makefile

# Use REV=sysv or REV=systemd to only build that version.
REV=all

ifeq ($(REV), all)
SYSV=1
SYSD=1
REVS=sysv systemd
else
ifeq ($(REV), systemd)
SYSV=
SYSD=1
REVS=systemd
else
SYSV=1
SYSD=
REVS=sysv
endif
endif

# The complete upstream URI we follow.
SVN_en := "$(EN_REPO)/$(EN_VER)"

.PHONY: svnup

# Don't delete intermediates (.po files).
.SECONDARY:

default:
	@echo 'Hi!'
	@echo 'To build the HTML documentation, please run `make genhtml`. For'
	@echo 'the PDF version, run `make genpdf`. For both run `make all`.'
	@echo 'Restrict to a subset of the available language with L=... and'
	@echo 'to a subset of the versions with REV=<sysv or systemd>.'
	@echo 'Good luck!'

all: genhtml genpdf
	@echo DONE

include include.mk

config.mk:
	@echo 'Hi!'
	@echo 'To use this Makefile, you will need a config.mk file, with your username'
	@echo 'and password in it. That is required for uploading to the lfs website.'
	@echo 'An example config.mk is simply:'
	@echo ''
	@echo 'USER:=my-user'
	@echo 'PRIVKEY:=~/.ssh/id_rsa'
	@echo 'USE_SSH_AGENT:=yes'
	@false

# So, if USE_SSH_AGENT = yes ...
ifeq ($(USE_SSH_AGENT), yes)
SSH_AGENT:=ssh-agent
else
SSH_AGENT:=
endif

init: $(ORIGDIR)

$(ORIGDIR):
	[ -d $@ ] || svn co $(SVN_en) $(ORIGDIR)/

# When updating, check that we still want to follow the checked-out branch.
# If not, remove it and check out the new branch.
svnup: init
	v=$$(svn info $(ORIGDIR) | grep ^URL | sed 's|^[^s]*||') ;\
	if [ "$$v" != "$(SVN_en)" ]; then \
		echo $$v ;\
		rm -rf $(ORIGDIR);\
		svn co $(SVN_en) $(ORIGDIR)/ >/dev/null;\
	else \
		if [ "$$(svn status -u $(ORIGDIR) | wc -l)" != "1" ]; then \
			LANG=en_US.UTF-8 svn update $(ORIGDIR);\
		fi ;\
	fi

clean: clean-gen clean-product
	rm -rf $(ORIGDIR) include.mk

# include.mk contains most of the logic of the Makefile.
# We generate lists of XML files to translated, PO files that contain translations,
# images and stylesheet files, and the list of files to copy from the english repo.
#
# It also contains targets to build different html versions, to refresh the PO
# files and to generate the translated XML files. We need to use this target
# because the language in the name of the target and the file name are both
# wildcards, which cannot be used.
include.mk: $(ORIGDIR) Makefile
	echo -n 'XML := ' > $@.tmp
	for lang in $(LANGUAGES); do \
		find $(ORIGDIR) -name '*.xml' -o -name '*stylesheets*' -prune -a -type f |\
			sed "s|$(ORIGDIR)/|lfsgen-$$lang/|g" | \
			tr '\n' ' ' >> $@.tmp; \
	done
	echo >> $@.tmp
	echo -n 'PO := ' >> $@.tmp
	for lang in $(LANGUAGES); do \
		find $(ORIGDIR) -name '*.xml' -o -name '*stylesheets*' -prune -a -type f |\
			sed "s|$(ORIGDIR)/|$$lang/|g" | \
			sed 's|.xml$$|.po|' | tr '\n' ' ' >> $@.tmp; \
	done
	echo >> $@.tmp
	echo -n 'IMAGES := ' >> $@.tmp
	for lang in $(LANGUAGES); do \
		find images -type f | sed "s|^|lfsgen-$$lang/|g" | tr '\n' ' ' >> $@.tmp; \
	done
	echo >> $@.tmp
	echo -n 'STYLESHEETS := ' >> $@.tmp
	for lang in $(LANGUAGES); do \
		find stylesheets -type f | sed "s|^|lfsgen-$$lang/|g" | tr '\n' ' ' >> $@.tmp;\
	done
	echo >> $@.tmp
	echo -n 'COPY = ' >> $@.tmp
	for lang in $(LANGUAGES); do \
		echo -n ' $$(addprefix lfsgen-'"$$lang"'/,$$(filestoget))' >> $@.tmp ;\
	done
	echo >> $@.tmp
	echo >> $@.tmp
	for lang in $(LANGUAGES); do \
		echo "lfsgen-$$lang/images/%: images/%" >> $@.tmp ;\
		$(ECHO) '\tmkdir -p $$$$(dirname $$@)\n' >> $@.tmp ;\
		$(ECHO) '\t@rm -f $$@\n' >> $@.tmp ;\
		$(ECHO) '\tcp $$< $$@\n' >> $@.tmp ;\
	done
	echo >> $@.tmp
	for lang in $(LANGUAGES); do \
		echo "lfsgen-$$lang/stylesheets/%: stylesheets/%" >> $@.tmp ;\
		$(ECHO) '\tmkdir -p $$$$(dirname $$@)\n' >> $@.tmp ;\
		$(ECHO) '\t@rm -f $$@\n' >> $@.tmp ;\
		$(ECHO) '\tcp $$< $$@\n' >> $@.tmp ;\
	done
	echo >> $@.tmp
	for lang in $(LANGUAGES); do \
		echo "lfsgen-$$lang/%.xml: $(ORIGDIR)/%.xml $$lang/%.po sed-$$lang" \
			>> $@.tmp ;\
		$(ECHO) '\tmkdir -p $$$$(dirname $$@)\n' >> $@.tmp ;\
		$(ECHO) '\tLANG=$$(LANG_'"$$lang"') po4a-translate -k 0 -f docbook ' >> $@.tmp ;\
		$(ECHO) -- '-m $$< -l $$@.tmp -p $$(word 2,$$^)\n' >> $@.tmp ;\
		$(ECHO) '\t./$$(word 3,$$^) $$@\n' >> $@.tmp ;\
		$(ECHO) '\trm $$@.tmp\n' >> $@.tmp ;\
	done
	echo >> $@.tmp
	for lang in $(LANGUAGES); do \
		echo "$$lang/%.po: $(ORIGDIR)/%.xml" \
			>> $@.tmp ;\
		$(ECHO) '\tmkdir -p $$$$(dirname $$@)\n' >> $@.tmp ;\
		$(ECHO) '\tLANG=$$(LANG_'"$$lang"') po4a-updatepo -f docbook ' >> $@.tmp ;\
		$(ECHO) -- '-m $$< -p $$@\n' >> $@.tmp ;\
		$(ECHO) '\t@touch $$@\n' >> $@.tmp ;\
	done
	echo >> $@.tmp
	echo 'clean-gen:' >> $@.tmp
	for lang in $(LANGUAGES); do \
		$(ECHO) "\trm -rf lfsgen-$$lang\n" >> $@.tmp ;\
	done
	echo >> $@.tmp
	echo 'clean-product:' >> $@.tmp
	for lang in $(LANGUAGES); do \
		$(ECHO) "\trm -rf LFS-*-$$lang-HTML.tar.bz2\n" >> $@.tmp ;\
		$(ECHO) "\trm -rf LFS-*-systemd-$$lang-HTML.tar.bz2\n" >> $@.tmp ;\
		$(ECHO) "\trm -rf html-$$lang-systemd\n" >> $@.tmp ;\
		$(ECHO) "\trm -rf html-$$lang-sysv\n" >> $@.tmp ;\
		$(ECHO) "\trm -rf pdf-$$lang\n" >> $@.tmp ;\
	done
	echo >> $@.tmp
	echo .SECONDEXPANSION: >> $@.tmp
	for lang in $(LANGUAGES); do \
		echo '$$(addprefix lfsgen-'"$$lang"'/,$$(filestocopy)):' \
			'INPUT=$$(ORIGDIR)$$(subst lfsgen-'"$$lang"',,$$@)' >> $@.tmp ;\
		echo '$$(addprefix lfsgen-'"$$lang"'/,$$(filestocopy)):' \
			'$$$$(INPUT)' >> $@.tmp ;\
		$(ECHO) '\tmkdir -p $$$$(dirname $$@)\n' >> $@.tmp ;\
		$(ECHO) '\tcp -r $$< $$@\n' >> $@.tmp ;\
	done
	echo >> $@.tmp
	for lang in $(LANGUAGES); do \
		xml='$$(filter lfsgen-'"$$lang"'/%,$$(XML))' ;\
		copy='$$(filter lfsgen-'"$$lang"'/%,$$(COPY))' ;\
		echo 'genhtml-'"$$lang"'-sysv: '"$$copy $$xml"' $$(IMAGES) $$(STYLESHEETS)' >> $@.tmp ;\
		$(ECHO) '\tLANG=$$(LANG_'"$$lang"') make -C lfsgen-'"$$lang"' -j1 REV=sysv BASEDIR=../html-'"$$lang"'-sysv book\n' >> $@.tmp ;\
		echo 'genhtml-'"$$lang"'-systemd: '"$$copy $$xml"' $$(IMAGES) $$(STYLESHEETS)' >> $@.tmp ;\
		$(ECHO) '\tLANG=$$(LANG_'"$$lang"') make -C lfsgen-'"$$lang"' -j1 REV=systemd BASEDIR=../html-'"$$lang"'-systemd book\n' >> $@.tmp ;\
		echo 'genpdf-'"$$lang"'-sysv: '"$$copy $$xml"' $$(IMAGES) $$(STYLESHEETS)' >> $@.tmp ;\
		$(ECHO) '\tLANG=$$(LANG_'"$$lang"') make -C lfsgen-'"$$lang"' -j1 REV=sysv BASEDIR=../pdf-'"$$lang"' pdf\n' >> $@.tmp ;\
		$(ECHO) '\tmv pdf-'"$$lang"'/LFS-BOOK.pdf pdf-'"$$lang"'/LFS-$(MILESTONE)-'"$$lang"'.pdf\n' >> $@.tmp ;\
		echo 'genpdf-'"$$lang"'-systemd: '"$$copy $$xml"' $$(IMAGES) $$(STYLESHEETS)' >> $@.tmp ;\
		$(ECHO) '\tLANG=$$(LANG_'"$$lang"') make -C lfsgen-'"$$lang"' -j1 REV=systemd BASEDIR=../pdf-'"$$lang"' pdf\n' >> $@.tmp ;\
		$(ECHO) '\tmv pdf-'"$$lang"'/LFS-SYSD-BOOK.pdf pdf-'"$$lang"'/LFS-$(MILESTONE)-'"$$lang"'-systemd.pdf\n' >> $@.tmp ;\
		echo 'genepub-'"$$lang"'-sysv: '"$$copy $$xml"' $$(IMAGES) $$(STYLESHEETS)' >> $@.tmp ;\
		$(ECHO) '\tLANG=$$(LANG_'"$$lang"') make -C lfsgen-'"$$lang"' -j1 EPUB_OUTPUT=lfs-$(MILESTONE)-'"$$lang"'.epub REV=sysv BASEDIR=../epub-'"$$lang"'-sysv epub\n' >> $@.tmp ;\
		echo 'genepub-'"$$lang"'-systemd: '"$$copy $$xml"' $$(IMAGES) $$(STYLESHEETS)' >> $@.tmp ;\
		$(ECHO) '\tLANG=$$(LANG_'"$$lang"') make -C lfsgen-'"$$lang"' -j1 EPUB_OUTPUT=lfs-$(MILESTONE)-systemd-'"$$lang"'.epub REV=systemd BASEDIR=../epub-'"$$lang"'-systemd epub\n' >> $@.tmp ;\
	done
	echo >> $@.tmp
	mv $@.tmp $@

ifeq ($(L),all)
L=$(LANGUAGES)
endif

HTMLDEPS=
ifeq ($(SYSV),1)
HTMLDEPS+=$(addsuffix -sysv,$(addprefix genhtml-,$(L)))
endif
ifeq ($(SYSD),1)
HTMLDEPS+=$(addsuffix -systemd,$(addprefix genhtml-,$(L)))
endif

PDFDEPS=
ifeq ($(SYSV),1)
PDFDEPS+=$(addsuffix -sysv,$(addprefix genpdf-,$(L)))
endif
ifeq ($(SYSD),1)
PDFDEPS+=$(addsuffix -systemd,$(addprefix genpdf-,$(L)))
endif

EPUBDEPS=
ifeq ($(SYSV),1)
EPUBDEPS+=$(addsuffix -sysv,$(addprefix genepub-,$(L)))
endif
ifeq ($(SYSD),1)
EPUBDEPS+=$(addsuffix -systemd,$(addprefix genepub-,$(L)))
endif

genhtml: $(HTMLDEPS)
genpdf: $(PDFDEPS)
genepub: $(EPUBDEPS)
gentar: genhtml
	for lang in $(L); do \
		tar cf LFS-$(MILESTONE)-$$lang-HTML.tar html-$$lang-sysv ;\
		tar cf LFS-$(MILESTONE)-systemd-$$lang-HTML.tar html-$$lang-systemd ;\
		rm -f LFS-$(MILESTONE)-$$lang-HTML.tar.bz2 ;\
		rm -f LFS-$(MILESTONE)-systemd-$$lang-HTML.tar.bz2 ;\
		bzip2 LFS-$(MILESTONE)-$$lang-HTML.tar ;\
		bzip2 LFS-$(MILESTONE)-systemd-$$lang-HTML.tar ;\
	done

update: $(PO)

pootle:
	pootle sync_stores --project=lfs
	$(MAKE) svnup
	$(MAKE) update
	python3 changelogtranslator.py $(L)
	pootle update_stores --project=lfs

ssh-agent:
	(ssh-add -l | grep $(PRIVKEY)) || \
	ssh-add $(PRIVKEY)

upload: $(SSH_AGENT)
	for lang in $(L); do \
		cd html-$$lang-systemd;\
		rsync --progress --recursive * $(USER)@www.linuxfromscratch.org:/srv/www/www.$$lang.linuxfromscratch.org/view/lfs-systemd-svn/ ;\
		cd ../html-$$lang-sysv;\
		rsync --progress --recursive * $(USER)@www.linuxfromscratch.org:/srv/www/www.$$lang.linuxfromscratch.org/view/lfs-svn/ ;\
		cd .. ;\
	done

release: $(SSH_AGENT) genhtml genpdf gentar genepub
	for lang in $(L); do \
		cd html-$$lang-systemd ;\
		rsync --progress --recursive * $(USER)@www.linuxfromscratch.org:/srv/www/www.$$lang.linuxfromscratch.org/view/lfs-$(MILESTONE)-systemd-$$lang/ ;\
		cd ../html-$$lang-sysv ;\
		rsync --progress --recursive * $(USER)@www.linuxfromscratch.org:/srv/www/www.$$lang.linuxfromscratch.org/view/lfs-$(MILESTONE)-$$lang/ ;\
		cd ../pdf-$$lang ;\
		rsync --progress LFS-$(MILESTONE)-$$lang.pdf $(USER)@www.linuxfromscratch.org:/srv/www/www.$$lang.linuxfromscratch.org/archives/LFS-$(MILESTONE)/ ;\
		rsync --progress LFS-$(MILESTONE)-$$lang-systemd.pdf $(USER)@www.linuxfromscratch.org:/srv/www/www.$$lang.linuxfromscratch.org/archives/LFS-$(MILESTONE)-systemd/ ;\
		cd .. ;\
		rsync --progress LFS-$(MILESTONE)-$$lang-HTML.tar.bz2 $(USER)@www.linuxfromscratch.org:/srv/www/www.$$lang.linuxfromscratch.org/archives/LFS-$(MILESTONE)/ ;\
		rsync --progress LFS-$(MILESTONE)-systemd-$$lang-HTML.tar.bz2 $(USER)@www.linuxfromscratch.org:/srv/www/www.$$lang.linuxfromscratch.org/archives/LFS-$(MILESTONE)-systemd/ ;\
		cd epub-$$lang-sysv;\
		rsync --progress lfs-$(MILESTONE)-$$lang.epub $(USER)@www.linuxfromscratch.org:/srv/www/www.$$lang.linuxfromscratch.org/archives/LFS-$(MILESTONE)/ ;\
		cd ../epub-$$lang-systemd ;\
		rsync --progress lfs-$(MILESTONE)-systemd-$$lang.epub $(USER)@www.linuxfromscratch.org:/srv/www/www.$$lang.linuxfromscratch.org/archives/LFS-$(MILESTONE)-systemd/ ;\
	done

commit: pootle
	svn commit -m 'Automatic LFS commit based on r$(REVISION)'

###############################################################################
# These files are not translated using po files. We use sed to modify them    #
# directly.                                                                   #
###############################################################################

##
## French translation of non po files
##

lfsgen-fr/general.ent: $(ORIGDIR)/general.ent
	mkdir -p lfsgen-fr
	sysv_date=$$(grep " version " $< | sed 's/.*"\([^"]\+\)".*/\1/');\
	sysd_date=$$(grep " versiond " $< | sed 's/.*"\([^"]\+\)".*/\1/');\
	date=$$(grep "releasedate" $< | sed 's/.*"\([^"]\+\)".*/\1/');\
	sed -e "s/$$date/$$(LANG=$(LANG_fr) date -d "$${date}" "+%d %B %Y")/g"\
	    -e "s/Approximate build time/Temps de construction approximatif/g"\
	    -e "s/Required disk space/Espace disque requis/g"\
	    -e "s/Installation depends on/L'installation dépend de/g"\
	    -e "s/Test suite depends on/La suite de tests dépend de/g"\
	    -e "s/Must be installed before/Doit être installé avant/g"\
	    -e "s/Optional dependencies/Dépendances facultatives/g"\
	    -e "s|&lfs-root;blfs/|http://fr.linuxfromscratch.org/blfs|g"\
	    -e "s|&blfs-root;view/&short-version;|\&blfs-root;\&short-version;|g"\
	    -e "s|&lfs-root;hints/downloads/files/|http://fr.linuxfromscratch.org/view/astuces/|g"\
	    $< > $@

lfsgen-fr/packages.ent: $(ORIGDIR)/packages.ent
	mkdir -p lfsgen-fr
	sed -e "s/KB/Ko/g" -e "s/MB/Mo/g" -e "s/GB/Go/g"\
	    -e "s/less than/moins de/g"\
	    -e "s/typically about/en général environ/g"\
	    -e "s/about/environ/g"\
	    -e "s/with tests/avec les tests/g"\
	    $< > $@

lfsgen-fr/patches.ent: $(ORIGDIR)/patches.ent
	mkdir -p lfsgen-fr
	sed -e "s/KB/Ko/g" \
	    $< > $@

lfsgen-fr/tidy.conf: $(ORIGDIR)/tidy.conf
	mkdir -p lfsgen-fr
	sed -e "s/latin1/UTF8/g" \
	    $< > $@

lfsgen-fr/Makefile: $(ORIGDIR)/Makefile lfsgen-fr/epub.mk
	mkdir -p lfsgen-fr
	sed -e '/&copy;/d' -e 's|book:|include epub.mk\nbook:|' $< > $@

lfsgen-fr/epub.mk: epub.mk
	mkdir -p lfsgen-fr
	cp $< $@
