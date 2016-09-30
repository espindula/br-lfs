#!/usr/bin/make -f

include include.mk

LANG := fr
LANGUAGE := fr_FR.UTF-8

GENDIR := lfsgen-$(LANG)
ORIGDIR := lfs-en
PODIR := $(LANG)
VERSION = trunk
#EN_VER := tags/7.10
EN_VER := trunk/BOOK
DIFFDIR = diff

LANG_EXPORT := LC_ALL=$(LANGUAGE) LANGUAGE=$(LANGUAGE) LANG=$(LANGUAGE)

filestocopy := INSTALL process-scripts.sh obfuscate.sh pdf-fixups.sh README bootscripts udev-lfs aux-file-data.sh make-aux-files.sh
filestoget := $(filestocopy) packages.ent tidy.conf patches.ent general.ent Makefile
COPY:=$(addprefix $(GENDIR)/,$(filestoget))
REV=sysv
VERSION_LINE=1
BASEDIR=../html-sysv

ifeq ($(REV), systemd)
VERSION_LINE=4
BASEDIR=../html-systemd
endif

FR_REPO:=svn://svn.linuxfromscratch.org/fr-lfs
EN_REPO:=svn://svn.linuxfromscratch.org/LFS

STYLE_BRANCH=trunk/lfs

SVN_en := "$(EN_REPO)/$(EN_VER)"



.PHONY: svnup

all: genhtml genpdf
	@echo DONE

include.mk: $(ORIGDIR)
	echo -n 'XML := ' > $@
	ls $(ORIGDIR)/*.xml $(ORIGDIR)/*/*.xml | sed 's|$(ORIGDIR)/|$(GENDIR)/|g' | tr '\n' ' ' >> $@
	echo >> $@
	echo -n 'PO := ' >> $@
	ls $(ORIGDIR)/*.xml $(ORIGDIR)/*/*.xml | sed 's|$(ORIGDIR)/|$(PODIR)/|g' | sed 's|.xml$$|.po|g' | tr '\n' ' ' >> $@
	echo >> $@
	echo -n 'IMAGES := ' >> $@
	find images -type f | sed 's|^|$(GENDIR)/|g' | tr '\n' ' ' >> $@
	echo >> $@
	echo -n 'STYLESHEETS := ' >> $@
	find stylesheets -type f | sed 's|^|$(GENDIR)/|g' | tr '\n' ' ' >> $@



.SECONDEXPANSION:
$(addprefix $(GENDIR)/,$(filestocopy)): INPUT=$(ORIGDIR)$(subst $(GENDIR),,$@)
$(addprefix $(GENDIR)/,$(filestocopy)): $$(INPUT) $(GENDIR)
	cp -r $< $@
	

genhtml: $(XML) $(COPY) $(STYLESHEETS) $(IMAGES)
	$(LANG_EXPORT) $(MAKE) -j1 -C $(GENDIR) REV=$(REV) BASEDIR=$(BASEDIR)

genpdf: $(XML) $(COPY) $(STYLESHEETS) $(IMAGES)
	$(LANG_EXPORT) $(MAKE) -j1 -C $(GENDIR) REV=$(REV) BASEDIR=../pdf pdf


$(GENDIR)/%.xml: $(ORIGDIR)/%.xml $(PODIR)/%.po $(GENDIR)
	$(LANG_EXPORT) po4a-translate -k 0 -f docbook -m $< -l $@ -p $(word 2,$^)
	sed -e 's|encoding="ISO-8859-1"|encoding="UTF-8"|g' \
	    -e 's|xreflabel="Chapter 1 - Mailing Lists|xreflabel="Chapitre 1 - Listes de diffusion|g' \
	    -e 's|xreflabel="Chapter 1 - Mirror sites|xreflabel="Chapitre 1 - Sites miroirs|g' \
	    -e 's|xreflabel="Host System Requirements|xreflabel="Prérequis du système hôte|g' \
	    -e "s|xreflabel='Package build instructions|xreflabel='Instructions de compilation des paquets|g" \
	    -e 's|xreflabel="Creating the /etc/shells File|xreflabel="Créaction du fichier /etc/shells|g' \
	    -e 's|xreflabel="Chapter|xreflabel="Chapitre|g' \
	    -e 's|xreflabel="Appendix|xreflabel="Appendice|g'  -i $@
	touch $(word 2,$^)
	touch $@

$(GENDIR)/index.xml: $(ORIGDIR)/index.xml $(PODIR)/index.po $(GENDIR)
	$(LANG_EXPORT) po4a-translate -k 0 -f docbook -m $< -l $@ -p $(word 2,$^)
	sed -e 's|<book>|<book lang="fr">|g' -i $@
	sed -e 's|encoding="ISO-8859-1"|encoding="UTF-8"|g' -i $@
	touch $(word 2,$^)
	touch $@

$(GENDIR)/images/%: images/%
	mkdir -p $$(dirname $@)
	rm -rf $@
	cp $< $@

$(GENDIR)/stylesheets/%: stylesheets/%
	mkdir -p $$(dirname $@)
	rm -rf $@
	cp $< $@

$(GENDIR)/general.ent: $(ORIGDIR)/general.ent $(GENDIR)
	#cp $< $@
	date1=$$(sed -n $(VERSION_LINE)p $< | sed 's/.*"\([^"]\+\)".*/\1/');\
	date2=$$(sed -n 10p $< | sed 's/.*"\([^"]\+\)".*/\1/');\
	sed -e "s/$$date2/$$(LANG=fr_FR.UTF-8 date -d "$${date2}" "+%d %B %Y")/g"\
	    -e "s/Approximate build time/Temps de construction approximatif/g"\
	    -e "s/Required disk space/Espace disque requis/g"\
	    -e "s/Installation depends on/L'installation dépend de/g"\
	    -e "s/Test suite depends on/La suite de tests dépend de/g"\
	    -e "s/Must be installed before/Doit être installé avant/g"\
	    -e "s/Optional dependencies/Dépendances facultatives/g"\
	    -e "s/&lfs-root;blfs\//http:\/\/www.fr.linuxfromscratch.org\/view\/blfs-$(version)/g"\
	    -e "s/&blfs-root;view\/&short-version;/\&blfs-root;\&short-version;/g"\
	    -e "s/&lfs-root;hints\/downloads\/files\//http:\/\/www.fr.linuxfromscratch.org\/view\/astuces\//g"\
	    $< > $@

$(GENDIR)/packages.ent: $(ORIGDIR)/packages.ent $(GENDIR)
	cp $< $@
	sed -e "s/KB/Ko/g" -e "s/MB/Mo/g" -e "s/GB/Go/g"\
	    -e "s/less than/moins de/g"\
	    -e "s/typically about/en général environ/g"\
	    -e "s/about/environ/g"\
	    -e "s/with tests/avec les tests/g"\
	    $< > $@

$(GENDIR)/patches.ent: $(ORIGDIR)/patches.ent $(GENDIR)
	cp $< $@
	sed -e "s/KB/Ko/g" \
	    $< > $@

$(GENDIR)/tidy.conf: $(ORIGDIR)/tidy.conf $(GENDIR)
	cp $< $@
	sed -e "s/latin1/UTF8/g" \
	    $< > $@

$(GENDIR)/Makefile: $(ORIGDIR)/Makefile $(GENDIR)
	sed '/&copy;/d' $< > $@

lfsgen-%:
	mkdir -p $@

init: $(ORIGDIR)

$(ORIGDIR)/%: $(ORIGDIR)
	

$(ORIGDIR):
	[ -d $@ ] || svn co $(SVN_en) $(ORIGDIR)/ 

svnup: init
	if [ "$$(svn status -u $(ORIGDIR) | wc -l)" != "1" ]; then \
	svn update $(ORIGDIR);\
	fi

clean:
	rm -rf $(DIFFDIR) $(GENDIR) $(ORIGDIR) include.mk html-sysv html-systemd pdf

$(ORIGDIR)/%.xml: $(ORIGDIR)
	

$(PODIR)/%.po: $(ORIGDIR)/%.xml
	$(LANG_EXPORT) po4a-updatepo -f docbook -m $< -p $@
	touch $<
	touch $@

$(DIFFDIR):
	mkdir $@

gendiff: $(PO) $(DIFFDIR)
	svn diff $(PODIR) | xz  -zec9 > $(DIFFDIR)/lfs-$(VERSION)-`date "+%d%m%y%H%M%S"`.diff.xz

update: $(PO)

upload:
	(cd html-systemd; rsync --progress --recursive * jlepiller@www.linuxfromscratch.org:/srv/www/www.fr.linuxfromscratch.org/view/lfs-systemd-svn/)
	(cd html-sysv; rsync --progress --recursive * jlepiller@www.linuxfromscratch.org:/srv/www/www.fr.linuxfromscratch.org/view/lfs-svn/)
