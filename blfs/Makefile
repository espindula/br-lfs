#!/usr/bin/make -f

include include.mk

LANG := fr
LANGUAGE := fr_FR.UTF-8

GENDIR := blfsgen-$(LANG)
ORIGDIR := blfs-en
PODIR := $(LANG)
VERSION = tags/7.9
DIFFDIR = diff

LANG_EXPORT := LC_ALL=$(LANGUAGE) LANGUAGE=$(LANGUAGE) LANG=$(LANGUAGE)

filestocopy := INSTALL obfuscate.sh README
filestoget := $(filestocopy) general.ent gnome.ent packages.ent tidy.conf Makefile
COPY:=$(addprefix $(GENDIR)/,$(filestoget))
REV=sysv
VERSION_LINE=1
BASEDIR=../html-sysv

ifeq ($(REV), systemd)
VERSION_LINE=4
BASEDIR=../html-systemd
endif

EN_REPO:=svn://svn.linuxfromscratch.org/BLFS

SVN_en := "$(EN_REPO)/$(VERSION)/"

.PHONY: $(GENDIR)/stylesheets $(GENDIR)/images svnup

#all: genhtml genpdf
all: genhtml
	@echo DONE

include.mk: $(ORIGDIR)
	echo -n 'XML := ' > $@
	find $(ORIGDIR) -type d -name stylesheets -prune -o -name '*.xml' -print | sed 's|$(ORIGDIR)/|$(GENDIR)/|g' | tr '\n' ' ' >> $@
	echo >> $@
	echo -n 'PO := ' >> $@
	find $(ORIGDIR) -type d -name stylesheets -prune -o -name '*.xml' -print | sed 's|$(ORIGDIR)/|$(PODIR)/|g' | sed 's|.xml$$|.po|g' | tr '\n' ' ' >> $@



.SECONDEXPANSION:
$(addprefix $(GENDIR)/,$(filestocopy)): INPUT=$(ORIGDIR)$(subst $(GENDIR),,$@)
$(addprefix $(GENDIR)/,$(filestocopy)): $$(INPUT) $(GENDIR)
	cp -r $< $@
	

genhtml: $(XML) $(GENDIR)/stylesheets $(GENDIR)/images $(COPY)
	$(LANG_EXPORT) $(MAKE) -j1 -C $(GENDIR) REV=$(REV) BASEDIR=$(BASEDIR)

genpdf: $(XML) $(GENDIR)/stylesheets $(GENDIR)/images $(COPY)
	$(LANG_EXPORT) $(MAKE) -j1 -C $(GENDIR) REV=$(REV) BASEDIR=../pdf pdf

TRANSLATE_CMD = $(LANG_EXPORT) po4a-translate -k 0 -f docbook -m $< -l $@ -p $(word 2,$^) -M ascii -L UTF-8

$(GENDIR)/%.xml: $(ORIGDIR)/%.xml $(PODIR)/%.po $(GENDIR)
	$(TRANSLATE_CMD)
	./sed_$(LANG).sh $@
	sed '0,/#-#/s|\([^>]*\) #-# \([^<]*\)|\1|' -i $@
	sed '0,/#-#/s|\([^>]*\) #-# \([^<]*\)|\2|' -i $@
	sed -e 's|encoding="ISO-8859-1"|encoding="UTF-8"|g' -i $@

$(GENDIR)/index.xml: $(ORIGDIR)/index.xml $(PODIR)/index.po $(GENDIR)
	$(TRANSLATE_CMD)
	./sed_$(LANG).sh $@
	sed -i -e 's|<book>|<book lang="fr">|g' \
	       -e 's|encoding="ISO-8859-1"|encoding="UTF-8"|g' -i $@

$(GENDIR)/images: $(GENDIR)
	rm -rf $@
	cp -r images $(GENDIR)

$(GENDIR)/stylesheets: $(GENDIR)
	rm -rf $@
	cp -r stylesheets $@

$(GENDIR)/general.ent: $(ORIGDIR)/general.ent $(GENDIR)
	#cp $< $@
	cat $< | tr '\n' '\r' | \
	sed -e "s|The BLFS Team|L'équipe de BLFS|g" \
	    -e "s|The BLFS Development Team|L'équipe de développement de BLFS|g" \
	    -e "s|Unknown|Inconnu|g" \
	    -e "s|<!ENTITY lfs\([0-9]\)\([0-9]\)_checked [^\r]*\r[^\r]*\">|<!ENTITY lfs\1\2_checked \"<para>Ce paquet est connu pour se construire correctement sur une plateforme LFS-\1.\2.</para>\">|g" \
	    -e "s|<!ENTITY lfs\([0-9]\)\([0-9]\)_built [^\r]*\r[^\r]*\">|<!ENTITY lfs\1\2_built \"<para>Ce paquet est connu pour se construire correctement sur une plateforme LFS-\1.\2 mais n'a pas été testé.</para>\">|g" \
	    -e "s|<!ENTITY lfssvn_checked [^\r]*\r[^\r]*\">|<!ENTITY lfssvn_checked \"Ce paquet est connu pour se construire correctement sur une plateforme LFS-SVN-\">|g" \
	    -e "s|<!ENTITY lfssvn_built [^\r]*\">|<!ENTITY lfssvn_checked \"Ce paquet est connu pour se construire correctement sur une plateforme LFS-SVN-\">|g" \
	    -e "s|<!ENTITY lfssvn_checked2 [^\r]*\">|<!ENTITY lfssvn_checked2 \" .\">|g" \
	    -e "s|<!ENTITY lfssvn_built2 [^\r]*\">|<!ENTITY lfssvn_built2 \" mais n'a pas été testé.\">|g" \
	    -e "s|<!ENTITY as_root *\"[^\"]*\">||g" \
	    -e "s|<!ENTITY not-katamari *\"[^\"]*\">|<!ENTITY not-katamari \"<para>Ce paquet ne fait pas partie de Xorg Katamari et est seulement fourni comme dépendance d'autres paquets ou pour tester l'installation complète de Xorg.</para>\">|g" \
	    -e "s|<!ENTITY parallel_issues *\"[^\"]*\">|<!ENTITY parallel_issues \"<note><para>Ce paquet peut parfois échouer quand il est construit avec plusieurs processeurs. Voir <xref linkend='parallel-builds'/> pour plus d'information.</para></note>\">|g" \
	    | tr '\r' '\n' > $@
		cat general.ent.as_root >> $@

$(GENDIR)/packages.ent: $(ORIGDIR)/packages.ent $(GENDIR)
	cp $< $@

$(GENDIR)/gnome.ent: $(ORIGDIR)/gnome.ent $(GENDIR)
	cp $< $@

$(GENDIR)/tidy.conf: $(ORIGDIR)/tidy.conf $(GENDIR)
	cp $< $@
	sed -e "s/latin1/UTF8/g" \
	    $< > $@

$(GENDIR)/Makefile: $(ORIGDIR)/Makefile $(GENDIR)
	sed '/&copy;/d' $< > $@

blfsgen-%:
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
	

$(PODIR)/%.po: $(ORIGDIR)/%.xml $(PODIR)
	$(LANG_EXPORT) po4a-updatepo -f docbook -m $< -p $@ -M ascii

$(DIFFDIR):
	mkdir $@

gendiff: $(PO) $(DIFFDIR)
	svn diff $(PODIR) | xz  -zec9 > $(DIFFDIR)/lfs-$(VERSION)-`date "+%d%m%y%H%M%S"`.diff.xz
