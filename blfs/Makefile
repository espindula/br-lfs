#!/usr/bin/make -f

include include.mk

LANGUAGE := fr

GENDIR := blfsgen-$(LANGUAGE)
ORIGDIR := blfs-en
PODIR := $(LANGUAGE)
#VERSION = tags/8.3
VERSION = trunk/BOOK
DIFFDIR = diff

filestocopy := INSTALL obfuscate.sh README
filestoget := $(filestocopy) general.ent gnome.ent packages.ent tidy.conf Makefile
COPY:=$(addprefix $(GENDIR)/,$(filestoget))
REV=sysv
VERSION_LINE=1

ifeq ($(REV), systemd)
VERSION_LINE=4
endif

EN_REPO:=svn://svn.linuxfromscratch.org/BLFS

SVN_en := "$(EN_REPO)/$(VERSION)/"

.PHONY: svnup

#all: genhtml genpdf
all: genhtml
	@echo DONE

include.mk: $(ORIGDIR)
	echo -n 'XML := ' > $@
	find $(ORIGDIR) -type d -name stylesheets -prune -o -name archive -prune -o -name '*.xml' -a -type f -print | sed 's|$(ORIGDIR)/|$(GENDIR)/|g' | tr '\n' ' ' >> $@
	echo >> $@
	echo -n 'PO := ' >> $@
	find $(ORIGDIR) -type d -name stylesheets -prune -o -name archive -prune -o -name '*.xml' -a -type f -print | sed 's|$(ORIGDIR)/|$(PODIR)/|g' | sed 's|.xml$$|.po|g' | tr '\n' ' ' >> $@
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
	

genhtml: $(XML) $(STYLESHEETS) $(IMAGES) $(COPY)
	$(MAKE) -j1 -C $(GENDIR) REV=$(REV) BASEDIR=../html-$(REV)-$(LANGUAGE)

genpdf: $(XML) $(STYLESHEETS) $(IMAGES) $(COPY)
	$(MAKE) -j1 -C $(GENDIR) REV=$(REV) BASEDIR=../pdf-$(REV)-$(LANGUAGE) pdf

TRANSLATE_CMD = po4a-translate -k 0 -f docbook -m $< -l $@ -p $(word 2,$^) -M ascii -L UTF-8

$(GENDIR)/%.xml: $(ORIGDIR)/%.xml $(PODIR)/%.po
	$(TRANSLATE_CMD)
	./sed_$(LANGUAGE).sh $@
	sed '0,/#-#/s|\([^>]*\) #-# \([^<]*\)|\1|' -i $@
	sed '0,/#-#/s|\([^>]*\) #-# \([^<]*\)|\2|' -i $@
	sed -e 's|encoding="ISO-8859-1"|encoding="UTF-8"|g' -i $@
	touch $(word 2,$^)
	touch $@

$(GENDIR)/index.xml: $(ORIGDIR)/index.xml $(PODIR)/index.po
	$(TRANSLATE_CMD)
	./sed_$(LANGUAGE).sh $@
	sed -i -e 's|<book>|<book lang="fr">|g' \
	       -e 's|encoding="ISO-8859-1"|encoding="UTF-8"|g' -i $@

$(GENDIR)/images/%: images/%
	mkdir -p $$(dirname $@)
	rm -rf $@
	cp $< $@

$(GENDIR)/stylesheets/%: stylesheets/%
	mkdir -p $$(dirname $@)
	rm -rf $@
	cp $< $@

$(GENDIR)/general.ent: $(ORIGDIR)/general.ent
	cat $< | tr '\n' '\r' | \
	sed -e "s|The BLFS Team|L'équipe de BLFS|g" \
	    -e "s|The BLFS Development Team|L'équipe de développement de BLFS|g" \
	    -e "s|Unknown|Inconnu|g" \
	    -e "s|<!ENTITY lfs\([0-9]\)\([0-9]\)_checked [^\r]*\r[^\r]*\">|<!ENTITY lfs\1\2_checked \"<para>Ce paquet est connu pour se construire correctement sur une plateforme LFS-\1.\2.</para>\">|g" \
	    -e "s|<!ENTITY lfs\([0-9]\)\([0-9]\)_built [^\r]*\r[^\r]*\">|<!ENTITY lfs\1\2_built \"<para>Ce paquet est connu pour se construire correctement sur une plateforme LFS-\1.\2 mais n'a pas été testé.</para>\">|g" \
            -e "s|<!ENTITY gcc7_checked [^\r]*\r[^\r]*\">|<!ENTITY gcc7_checked \"<para>Ce paquet est connu pour se construire correctement avec gcc-7.1.</para>\">|g" \
	    -e "s|<!ENTITY lfssvn_checked [^\r]*\r[^\r]*\">|<!ENTITY lfssvn_checked \"Ce paquet est connu pour se construire correctement sur une plateforme LFS-SVN-\">|g" \
	    -e "s|<!ENTITY lfssvn_built [^\r]*\">|<!ENTITY lfssvn_checked \"Ce paquet est connu pour se construire correctement sur une plateforme LFS-SVN-\">|g" \
	    -e "s|<!ENTITY lfssvn_checked2 [^\r]*\">|<!ENTITY lfssvn_checked2 \" .\">|g" \
	    -e "s|<!ENTITY lfssvn_built2 [^\r]*\">|<!ENTITY lfssvn_built2 \" mais n'a pas été testé.\">|g" \
	    -e "s|<!ENTITY as_root *\"[^\"]*\">||g" \
	    -e "s|<!ENTITY not-katamari *\"[^\"]*\">|<!ENTITY not-katamari \"<para>Ce paquet ne fait pas partie de Xorg Katamari et est seulement fourni comme dépendance d'autres paquets ou pour tester l'installation complète de Xorg.</para>\">|g" \
	    -e "s|<!ENTITY parallel_issues *\"[^\"]*\">|<!ENTITY parallel_issues \"<note><para>Ce paquet peut parfois échouer quand il est construit avec plusieurs processeurs. Voir <xref linkend='parallel-builds'/> pour plus d'information.</para></note>\">|g" \
	    | tr '\r' '\n' > $@
		cat general.ent.as_root >> $@

$(GENDIR)/packages.ent: $(ORIGDIR)/packages.ent
	cp $< $@

$(GENDIR)/gnome.ent: $(ORIGDIR)/gnome.ent
	cp $< $@

$(GENDIR)/tidy.conf: $(ORIGDIR)/tidy.conf
	cp $< $@
	sed -e "s/latin1/UTF8/g" \
	    $< > $@

$(GENDIR)/Makefile: $(ORIGDIR)/Makefile
	sed '/&copy;/d' $< > $@

init: $(ORIGDIR)

$(ORIGDIR):
	[ -d $@ ] || svn co $(SVN_en) $(ORIGDIR)/ 

pootle:
	pootle sync_stores --project=blfs
	$(MAKE) svnup
	$(MAKE) update
	python3 changelogtranslator.py fr/introduction/welcome/changelog.po
	python3 templatetranslator.py `find $(LANGUAGE) -name '*.po'`
	pootle update_stores --project=blfs

svnup: init
	if [ "$$(svn status -u $(ORIGDIR) | wc -l)" != "1" ]; then \
	svn update $(ORIGDIR);\
	fi

clean:
	rm -rf $(DIFFDIR) $(GENDIR) $(ORIGDIR) include.mk html-sysv html-systemd pdf

$(ORIGDIR)/%.xml: init
	

$(PODIR)/%.po: $(ORIGDIR)/%.xml $(PODIR)
	po4a-updatepo -f docbook -m $< -p $@ -M ascii
	touch $<
	touch $@

update: $(PO)

upload:
	(cd html-systemd-$(LANGUAGE); rsync --progress --recursive * jlepiller@www.linuxfromscratch.org:/srv/www/www.fr.linuxfromscratch.org/view/blfs-systemd-svn/)
	(cd html-sysv-$(LANGUAGE); rsync --progress --recursive * jlepiller@www.linuxfromscratch.org:/srv/www/www.fr.linuxfromscratch.org/view/blfs-svn/)
