# Makefile pour la génération du livre BLFS.
# Par Tushar Teredesai <tushar@linuxfromscratch.org>
# 31/01/2004
# $LastChangedBy: randy $
# $Date: 2005-06-15 05:46:50 $
# Ajustez ceci pour correspondre avec votre installation
OUTPUTDIR = $(HOME)/public_html/blfs-book
INSTALL = install
JADE = openjade
DOCBOOK = /usr/share/sgml/docbook/stylesheet/xsl/nwalsh
BASEDIR= $(HOME)/public_html/blfs/
TEXBASEDIR= $(HOME)/public_html/blfs-book-tex/
NOCHUNKS_OUTPUT=BLFS-BOOK.html
SRCDIR = $(PWD)

all: blfs

blfs:
	@if [ -z $(BASEDIR) ]; then \
		echo "Envar BASEDIR is not set!" ; \
		exit 1 ; \
		fi
	@echo "Génération de la version XHTML du livre BLFS avec xsltproc..."
	@echo "  BASEDIR = $(BASEDIR)"
	@$(INSTALL) -d $(BASEDIR)
	xsltproc --xinclude --nonet -stringparam base.dir $(BASEDIR) \
	  stylesheets/blfs-chunked.xsl index.xml
	if [ ! -e $(BASEDIR)stylesheets ]; then \
	  mkdir -p $(BASEDIR)stylesheets; \
	fi;
	cp stylesheets/*.css $(BASEDIR)stylesheets
	if [ ! -e $(BASEDIR)images ]; then \
	  mkdir -p $(BASEDIR)images; \
	fi;
	cp images/*.png $(BASEDIR)/images
	cd $(BASEDIR); sed -i -e "s@../stylesheets@stylesheets@g" *.html
	cd $(BASEDIR); sed -i -e "s@../images@images@g" *.html
	sh goTidy $(BASEDIR)/  

nochunks:
	@echo "Génération de la version nochunks de BLFS..."
	xsltproc --xinclude --nonet -stringparam profile.condition html \
        --output $(BASEDIR)/$(NOCHUNKS_OUTPUT) \
          stylesheets/blfs-nochunks.xsl index.xml
 
	tidy -config tidy.conf $(BASEDIR)/$(NOCHUNKS_OUTPUT) || true
 
	sed -i -e "s@text/html@application/xhtml+xml@g"  \
          $(BASEDIR)/$(NOCHUNKS_OUTPUT)

pdf:
	xsltproc --xinclude --nonet --output blfs.fo \
	stylesheets/blfs-pdf.xsl \
	  index.xml
	sed -i -e "s/inherit/all/" blfs.fo
	fop.sh blfs.fo blfs.pdf
	$(INSTALL) -d $(BASEDIR)pdf
	rm blfs.fo
	mv blfs.pdf $(BASEDIR)pdf

print:
	xsltproc --xinclude --nonet --output blfs-print.fo \
	stylesheets/blfs-print.xsl index.xml
	sed -i -e "s/inherit/all/" blfs-print.fo
	fop.sh blfs-print.fo blfs-print.pdf
	$(INSTALL) -d $(BASEDIR)print
	rm blfs-print.fo
	mv blfs-print.pdf $(BASEDIR)print

tex:
	@if [ -z $(TEXBASEDIR) ]; then \
                echo "La variable d'environnement TEXBASEDIR n'est pas initialisée!" ; \
                exit 1 ; \
                fi
	@echo "Generating TeX Version of BLFS Book with xsltproc..."
	@echo "  TEXBASEDIR = $(TEXBASEDIR)"
	@$(INSTALL) -d $(TEXBASEDIR)
# Utilisation de profiles dans les sources du livre pour exclure des parties du livre à TeX
# c'est-à-dire le journal des modifications
	xsltproc --nonet --output $(TEXBASEDIR)index.xml \
	--stringparam "profile.role" "book" \
	http://docbook.sourceforge.net/release/xsl/current/profiling/profile.xsl \
	index.xml
	@cd $(TEXBASEDIR) && xsltproc --nonet -o blfs-book.tex \
	$(SRCDIR)/stylesheets/blfs-tex.xsl index.xml

validate:
	xmllint --noout --nonet --xinclude --postvalid index.xml

blfs-patch-list: 
	@echo "Generating blfs-patch-list..."
	xsltproc --xinclude --nonet \
             --output blfs-patch-list stylesheets/patcheslist.xsl index.xml
	sed -e "s|^.*/||" blfs-patch-list > blfs-patches
	sort blfs-patches > blfs-patch-list
	rm blfs-patches

.PHONY : blfs-patch-list
