# Makefile pour la génération du livre BLFS.
# Par Tushar Teredesai <tushar@linuxfromscratch.org>
# 31/01/2004
# Ajustez ceci pour correspondre avec votre installation
OUTPUTDIR = $(HOME)/public_html/blfs-book
INSTALL = install
JADE = openjade
DOCBOOK = /usr/share/sgml/docbook/stylesheet/xsl/nwalsh
BASEDIR= $(HOME)/public_html/blfs/
TEXBASEDIR= $(HOME)/public_html/blfs-book-tex/

SRCDIR = $(PWD)

all: blfs

blfs-old: index.xml
	@if [ -z $(OUTPUTDIR) ]; then \
		echo "Envar OUTPUTDIR is not set!" ; \
		exit 1 ; \
		fi
	@echo "Génération de la version HTML du livre BLFS avec $(JADE)..."
	@echo "  OUTPUTDIR = $(OUTPUTDIR)"
	@$(INSTALL) -d $(OUTPUTDIR)
	@cd $(OUTPUTDIR) && $(INSTALL) -d introduction postlfs general \
		connect basicnet server content x kde gnome xsoft \
		multimedia pst preface appendices other
	@cd $(OUTPUTDIR) && $(JADE) -t sgml -D $(DOCBOOK)/html \
		-d $(SRCDIR)/blfs.dsl $(DOCBOOK)/dtds/decls/xml.dcl \
		$(SRCDIR)/index.xml

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
	cd $(BASEDIR); sed -i -e "s@../stylesheets@stylesheets@" \
	  index.html 
	cd $(BASEDIR); sed -i -e "s@../images@images@g" \
	  index.html 
	sh goTidy $(BASEDIR)/  

pdf:
	xsltproc --xinclude --nonet --output blfs.fo \
	stylesheets/blfs-pdf.xsl \
	  index.xml
	sed -i -e "s/inherit/all/" blfs.fo
	/opt/fop/fop.sh blfs.fo blfs.pdf
	$(INSTALL) -d $(BASEDIR)pdf
	rm blfs.fo
	mv blfs.pdf $(BASEDIR)pdf

print:
	xsltproc --xinclude --nonet --output blfs-print.fo \
	stylesheets/blfs-print.xsl index.xml
	sed -i -e "s/inherit/all/" blfs-print.fo
	/opt/fop/fop.sh blfs-print.fo blfs-print.pdf
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
	xmllint --noout --valid index.xml
