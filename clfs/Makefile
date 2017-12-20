#!/usr/bin/make -f

# Use make L=... to build only a subset of the languages.

LANGUAGES := fr
LANG_fr := fr_FR.UTF-8
L = all

ORIGDIR := clfs-en/BOOK


TAG := trunk

# Depending on what we track, we choose the correct branch from upstream.
ifeq ($(TAG), trunk)
EN_VER := trunk/BOOK
else
EN_VER := tags/$(TAG)
endif

# Some version of echo (for instance the one shipped in dash) doesn't understand -e
# but acts as if it was passed by default.
ifeq ($(shell echo -n -e),-e)
ECHO:=echo
else
ECHO:=echo -e
endif

# Files that are needed for the build process once translations are generated.
filestocopy := INSTALL README filesize.sh obfuscate.sh tidy.sh Makefile \
	users_groups.ent
# Additional files that may require some changes.
filestoget := $(filestocopy) packages.ent tidy.conf patches.ent general.ent

FR_REPO:=svn://svn.linuxfromscratch.org/fr-lfs
EN_REPO:=git://git.clfs.org/cross-lfs.git

.PHONY: svnup

# Don't delete intermediates (.po files).
.SECONDARY:

all: genhtml genpdf
	@echo DONE

include include.mk

init: $(ORIGDIR)

$(ORIGDIR):
	[ -d $@ ] || git clone $(EN_REPO) $(shell dirname $(ORIGDIR))/

# When updating, check that we still want to follow the checked-out branch.
# If not, remove it and check out the new branch.
svnup: init
	cd $(ORIGDIR); git pull

clean: clean-gen
	rm -rf $(ORIGDIR) include.mk

# include.mk contains most of the logic of the Makefile.
# We generate lists of XML files to be translated, PO files that contain translations,
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
			sed "s|$(ORIGDIR)/|clfsgen-$$lang/|g" | \
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
	echo -n 'SCHEMAS := ' >> $@.tmp
	for lang in $(LANGUAGES); do \
		(cd $(ORIGDIR); find schema -type f) \
			| sed "s|^|clfsgen-$$lang/|g" | tr '\n' ' ' >> $@.tmp; \
	done
	echo >> $@.tmp
	echo -n 'IMAGES := ' >> $@.tmp
	for lang in $(LANGUAGES); do \
		find images -type f | sed "s|^|clfsgen-$$lang/|g" | tr '\n' ' ' >> $@.tmp; \
	done
	echo >> $@.tmp
	echo -n 'STYLESHEETS := ' >> $@.tmp
	for lang in $(LANGUAGES); do \
		find stylesheets -type f | sed "s|^|clfsgen-$$lang/|g" | tr '\n' ' ' >> $@.tmp;\
	done
	echo >> $@.tmp
	echo -n 'COPY = ' >> $@.tmp
	for lang in $(LANGUAGES); do \
		echo -n ' $$(addprefix clfsgen-'"$$lang"'/,$$(filestoget))' >> $@.tmp ;\
	done
	echo >> $@.tmp
	echo >> $@.tmp
	for lang in $(LANGUAGES); do \
		echo "clfsgen-$$lang/images/%: images/%" >> $@.tmp ;\
		$(ECHO) '\t@mkdir -p $$$$(dirname $$@)' >> $@.tmp ;\
		$(ECHO) '\t@rm -f $$@' >> $@.tmp ;\
		$(ECHO) '\tcp $$< $$@' >> $@.tmp ;\
	done
	echo >> $@.tmp
	for lang in $(LANGUAGES); do \
		echo "clfsgen-$$lang/stylesheets/%: stylesheets/%" >> $@.tmp ;\
		$(ECHO) '\t@mkdir -p $$$$(dirname $$@)' >> $@.tmp ;\
		$(ECHO) '\t@rm -f $$@' >> $@.tmp ;\
		$(ECHO) '\tcp $$< $$@' >> $@.tmp ;\
	done
	echo >> $@.tmp
	for lang in $(LANGUAGES); do \
		echo "clfsgen-$$lang/schema/%: $(ORIGDIR)/schema/%" >> $@.tmp ;\
		$(ECHO) '\t@mkdir -p $$$$(dirname $$@)' >> $@.tmp ;\
		$(ECHO) '\t@rm -f $$@' >> $@.tmp ;\
		$(ECHO) '\tcp $$< $$@' >> $@.tmp ;\
	done
	echo >> $@.tmp
	for lang in $(LANGUAGES); do \
		echo "clfsgen-$$lang/%.xml: $(ORIGDIR)/%.xml $$lang/%.po sed-$$lang" \
			>> $@.tmp ;\
		$(ECHO) '\t@mkdir -p $$$$(dirname $$@)' >> $@.tmp ;\
		$(ECHO) '\tLANG=$$(LANG_'"$$lang"') po4a-translate -k 0 -f docbook' \
			'-m $$< -l $$@.tmp -p $$(word 2,$$^)' >> $@.tmp ;\
		$(ECHO) '\t./$$(word 3,$$^) $$@' >> $@.tmp ;\
		$(ECHO) '\trm $$@.tmp' >> $@.tmp ;\
	done
	echo >> $@.tmp
	for lang in $(LANGUAGES); do \
		echo "$$lang/%.po: $(ORIGDIR)/%.xml" \
			>> $@.tmp ;\
		$(ECHO) '\t@mkdir -p $$$$(dirname $$@)' >> $@.tmp ;\
		$(ECHO) '\tLANG=$$(LANG_'"$$lang"') po4a-updatepo -f docbook' \
			'-m $$< -p $$@' >> $@.tmp ;\
		$(ECHO) '\t@touch $$@' >> $@.tmp ;\
	done
	echo >> $@.tmp
	echo 'clean-gen:' >> $@.tmp
	for lang in $(LANGUAGES); do \
		$(ECHO) "\trm -rf clfsgen-$$lang" >> $@.tmp ;\
	done
	echo >> $@.tmp
	echo .SECONDEXPANSION: >> $@.tmp
	for lang in $(LANGUAGES); do \
		echo '$$(addprefix clfsgen-'"$$lang"'/,$$(filestocopy)):' \
			'INPUT=$$(ORIGDIR)$$(subst clfsgen-'"$$lang"',,$$@)' >> $@.tmp ;\
		echo '$$(addprefix clfsgen-'"$$lang"'/,$$(filestocopy)):' \
			'$$$$(INPUT)' >> $@.tmp ;\
		$(ECHO) '\t@mkdir -p $$$$(dirname $$@)' >> $@.tmp ;\
		$(ECHO) '\tcp -r $$< $$@' >> $@.tmp ;\
	done
	echo >> $@.tmp
	for lang in $(LANGUAGES); do \
		xml='$$(filter clfsgen-'"$$lang"'/%,$$(XML))' ;\
		copy='$$(filter clfsgen-'"$$lang"'/%,$$(COPY))' ;\
		echo 'genhtml-'"$$lang"': '"$$copy $$xml"' $$(IMAGES) $$(STYLESHEETS) $$(SCHEMAS)' >> $@.tmp ;\
		$(ECHO) '\tLANG=$$(LANG_'"$$lang"') make -C clfsgen-'"$$lang"' -j1 REV=sysv RENDERDIR=../html-'"$$lang" >> $@.tmp ;\
		echo 'genpdf-'"$$lang"': '"$$copy $$xml"' $$(IMAGES) $$(STYLESHEETS) $$(SCHEMAS)' >> $@.tmp ;\
		$(ECHO) '\tLANG=$$(LANG_'"$$lang"') make -C clfsgen-'"$$lang"' -j1 REV=sysv BASEDIR=../pdf-'"$$lang"' pdf' >> $@.tmp ;\
	done
	echo >> $@.tmp
	mv $@.tmp $@

ifeq ($(L),all)
L=$(LANGUAGES)
endif

HTMLDEPS=$(addprefix genhtml-,$(L))
PDFDEPS=$(addprefix genpdf-,$(L))

genhtml: $(HTMLDEPS)
genpdf: $(PDFDEPS)

update: $(PO)

pootle:
	pootle sync_stores --project=clfs
	$(MAKE) svnup
	$(MAKE) update
	pootle update_stores --project=clfs

USER:=jlepiller
upload:
	for lang in $(L); do \
		cd html-$$lang/html;\
		rsync --progress --recursive * $(USER)@www.linuxfromscratch.org:/srv/www/www.$$lang.linuxfromscratch.org/view/clfs-svn/ ;\
		cd .. ;\
	done

###############################################################################
# These files are not translated using po files. We use sed to modify them    #
# directly.                                                                   #
###############################################################################

##
## French translation of non po files
##

clfsgen-fr/general.ent: $(ORIGDIR)/general.ent
	@mkdir -p clfsgen-fr
	month=$$(grep " month_name " $< | sed 's/.*"\([^"]\+\)".*/\1/') ;\
	sed -e "s/$$month/$$(LANG=$(LANG_fr) date -d "01 $${month} 2010" "+%B")/g"\
	    -e "s/Installation depends on/L'installation dépend de/g"\
	    -e "s/Test suite depends on/La suite de tests dépend de/g"\
	    -e "s/Must be installed before/Doit être installé avant/g"\
	    -e "s|&lfs-root;blfs/|http://fr.linuxfromscratch.org/blfs|g"\
	    -e "s/ISO-8859-1/UTF-8/" \
	    $< > $@

clfsgen-fr/packages.ent: $(ORIGDIR)/packages.ent
	@mkdir -p clfsgen-fr
	sed -e "s/KB/Ko/g" -e "s/MB/Mo/g" -e "s/GB/Go/g"\
	    -e "s/ISO-8859-1/UTF-8/" \
	    $< > $@

clfsgen-fr/patches.ent: $(ORIGDIR)/patches.ent
	@mkdir -p clfsgen-fr
	sed -e "s/KB/Ko/g" \
	    -e "s/ISO-8859-1/UTF-8/" \
	    $< > $@

clfsgen-fr/tidy.conf: $(ORIGDIR)/tidy.conf
	@mkdir -p clfsgen-fr
	sed -e "s/latin1/UTF8/g" \
	    $< > $@

clfsgen-fr/stylesheets/top-index.xsl: stylesheets/top-index.xsl
	@mkdir -p clfsgen-fr/stylesheets
	sed -e 's|Select your target architecture:|Choisissez votre architecture cible :|g'\
	    $< > $@
