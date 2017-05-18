#!/usr/bin/make -f

# Use make L=... to build only a subset of the languages.

LANGUAGES := fr
LANG_fr := fr_FR.UTF-8
L = all

ORIGDIR := lfs-en


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
MILESTONE := 8.1

# What this does is that it selects either the development version (if our milestone
# is the same as upstream) or the stable version (if it does not match, meaning
# that the stable version is released).
ifeq ($(MILESTONE), $(shell ((grep milestone $(ORIGDIR)/general.ent || echo $(MILESTONE)) | sed 's|.*"\(.*\)".*|\1|')))
TAG := trunk
else
TAG := $(MILESTONE)
endif

# Depending on what we track, we choose the correct branch from upstream.
ifeq ($(TAG), trunk)
EN_VER := trunk/BOOK
else
EN_VER := tags/$(TAG)
endif

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
else
ifeq ($(REV), systemd)
SYSV=
SYSD=1
else
SYSV=1
SYSD=
endif
endif

FR_REPO:=svn://svn.linuxfromscratch.org/fr-lfs
EN_REPO:=svn://svn.linuxfromscratch.org/LFS

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

init: $(ORIGDIR)

$(ORIGDIR):
	[ -d $@ ] || svn co $(SVN_en) $(ORIGDIR)/

# When updating, check that we still want to follow the checked-out branch.
# If not, remove it and check out the new branch.
svnup: init
	v=$$(svn info $(ORIGDIR) | grep ^URL | cut -c6-) ;\
	if [ "$$v" != "$(SVN_en)" ]; then \
		echo $$v ;\
		rm -rf $(ORIGDIR);\
		svn co $(SVN_en) $(ORIGDIR)/ >/dev/null;\
	else \
		if [ "$$(svn status -u $(ORIGDIR) | wc -l)" != "1" ]; then \
			LANG=en_US.UTF-8 svn update $(ORIGDIR);\
		fi ;\
	fi

clean: clean-gen
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
		echo -e '\t@mkdir -p $$$$(dirname $$@)' >> $@.tmp ;\
		echo -e '\t@rm -f $$@' >> $@.tmp ;\
		echo -e '\tcp $$< $$@' >> $@.tmp ;\
	done
	echo >> $@.tmp
	for lang in $(LANGUAGES); do \
		echo "lfsgen-$$lang/stylesheets/%: stylesheets/%" >> $@.tmp ;\
		echo -e '\t@mkdir -p $$$$(dirname $$@)' >> $@.tmp ;\
		echo -e '\t@rm -f $$@' >> $@.tmp ;\
		echo -e '\tcp $$< $$@' >> $@.tmp ;\
	done
	echo >> $@.tmp
	for lang in $(LANGUAGES); do \
		echo "lfsgen-$$lang/%.xml: $(ORIGDIR)/%.xml $$lang/%.po sed-$$lang" \
			>> $@.tmp ;\
		echo -e '\t@mkdir -p $$$$(dirname $$@)' >> $@.tmp ;\
		echo -e '\tLANG=$$(LANG_'"$$lang"') po4a-translate -k 0 -f docbook' \
			'-m $$< -l $$@.tmp -p $$(word 2,$$^)' >> $@.tmp ;\
		echo -e '\t./$$(word 3,$$^) $$@' >> $@.tmp ;\
		echo -e '\trm $$@.tmp' >> $@.tmp ;\
	done
	echo >> $@.tmp
	for lang in $(LANGUAGES); do \
		echo "$$lang/%.po: $(ORIGDIR)/%.xml" \
			>> $@.tmp ;\
		echo -e '\t@mkdir -p $$$$(dirname $$@)' >> $@.tmp ;\
		echo -e '\tLANG=$$(LANG_'"$$lang"') po4a-updatepo -f docbook' \
			'-m $$< -p $$@' >> $@.tmp ;\
		echo -e '\t@touch $$@' >> $@.tmp ;\
	done
	echo >> $@.tmp
	echo 'clean-gen:' >> $@.tmp
	for lang in $(LANGUAGES); do \
		echo -e "\trm -rf lfsgen-$$lang" >> $@.tmp ;\
	done
	echo >> $@.tmp
	echo .SECONDEXPANSION: >> $@.tmp
	for lang in $(LANGUAGES); do \
		echo '$$(addprefix lfsgen-'"$$lang"'/,$$(filestocopy)):' \
			'INPUT=$$(ORIGDIR)$$(subst lfsgen-'"$$lang"',,$$@)' >> $@.tmp ;\
		echo '$$(addprefix lfsgen-'"$$lang"'/,$$(filestocopy)):' \
			'$$$$(INPUT)' >> $@.tmp ;\
		echo -e '\t@mkdir -p $$$$(dirname $$@)' >> $@.tmp ;\
		echo -e '\tcp -r $$< $$@' >> $@.tmp ;\
	done
	echo >> $@.tmp
	for lang in $(LANGUAGES); do \
		xml='$$(filter lfsgen-'"$$lang"'/%,$$(XML))' ;\
		copy='$$(filter lfsgen-'"$$lang"'/%,$$(COPY))' ;\
		echo 'genhtml-'"$$lang"'-sysv: '"$$copy $$xml"' $$(IMAGES) $$(STYLESHEETS)' >> $@.tmp ;\
		echo -e '\tLANG=$$(LANG_'"$$lang"') make -C lfsgen-'"$$lang"' -j1 REV=sysv BASEDIR=../html-'"$$lang"'-sysv' >> $@.tmp ;\
		echo 'genhtml-'"$$lang"'-systemd: '"$$copy $$xml"' $$(IMAGES) $$(STYLESHEETS)' >> $@.tmp ;\
		echo -e '\tLANG=$$(LANG_'"$$lang"') make -C lfsgen-'"$$lang"' -j1 REV=systemd BASEDIR=../html-'"$$lang"'-systemd' >> $@.tmp ;\
		echo 'genpdf-'"$$lang"'-sysv: '"$$copy $$xml"' $$(IMAGES) $$(STYLESHEETS)' >> $@.tmp ;\
		echo -e '\tLANG=$$(LANG_'"$$lang"') make -C lfsgen-'"$$lang"' -j1 REV=sysv BASEDIR=../pdf-'"$$lang"' pdf' >> $@.tmp ;\
		echo 'genpdf-'"$$lang"'-systemd: '"$$copy $$xml"'$$(IMAGES) $$(STYLESHEETS)' >> $@.tmp ;\
		echo -e '\tLANG=$$(LANG_'"$$lang"') make -C lfsgen-'"$$lang"' -j1 REV=systemd BASEDIR=../pdf-'"$$lang"' pdf' >> $@.tmp ;\
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

genhtml: $(HTMLDEPS)
genpdf: $(PDFDEPS)
gentar: genhtml
	for lang in $(L); do \
		tar cf LFS-$(MILESTONE)-$$lang-HTML.tar html-$$lang-sysv ;\
		tar cf LFS-systemd-$(MILESTONE)-$$lang-HTML.tar html-$$lang-systemd ;\
		bzip2 LFS-$(MILESTONE)-$$lang-HTML.tar ;\
		bzip2 LFS-systemd-$(MILESTONE)-$$lang-HTML.tar ;\
	done

update: $(PO)

USER:=jlepiller
upload:
	for lang in $(L); do \
		cd html-$$lang-systemd;\
		rsync --progress --recursive * $(USER)@www.linuxfromscratch.org:/srv/www/www.$$lang.linuxfromscratch.org/view/lfs-systemd-svn/ ;\
		cd ../html-$$lang-sysv;\
		rsync --progress --recursive * $(USER)@www.linuxfromscratch.org:/srv/www/www.$$lang.linuxfromscratch.org/view/lfs-svn/ ;\
		cd .. ;\
	done

###############################################################################
# These files are not translated using po files. We use sed to modify them    #
# directly.                                                                   #
###############################################################################

##
## French translation of non po files
##

lfsgen-fr/general.ent: $(ORIGDIR)/general.ent
	@mkdir -p lfsgen-fr
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
	@mkdir -p lfsgen-fr
	sed -e "s/KB/Ko/g" -e "s/MB/Mo/g" -e "s/GB/Go/g"\
	    -e "s/less than/moins de/g"\
	    -e "s/typically about/en général environ/g"\
	    -e "s/about/environ/g"\
	    -e "s/with tests/avec les tests/g"\
	    $< > $@

lfsgen-fr/patches.ent: $(ORIGDIR)/patches.ent
	@mkdir -p lfsgen-fr
	sed -e "s/KB/Ko/g" \
	    $< > $@

lfsgen-fr/tidy.conf: $(ORIGDIR)/tidy.conf
	@mkdir -p lfsgen-fr
	sed -e "s/latin1/UTF8/g" \
	    $< > $@

lfsgen-fr/Makefile: $(ORIGDIR)/Makefile
	@mkdir -p lfsgen-fr
	sed '/&copy;/d' $< > $@
