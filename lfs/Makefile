BASEDIR=~/projects/Guides/LFS/HTML
CHUNK_QUIET=0
PDF_OUTPUT=LFS-BOOK.pdf
NOCHUNKS_OUTPUT=LFS-BOOK.html
XSLROOTDIR=/usr/share/xml/docbook/xsl-stylesheets-current

lfs:
	xsltproc --xinclude --nonet -stringparam profile.condition html \
	  --output $(BASEDIR)/lfs-html.xml stylesheets/lfs-profile.xsl index.xml

	xsltproc --nonet -stringparam chunk.quietly $(CHUNK_QUIET) \
	  -stringparam base.dir $(BASEDIR)/ stylesheets/lfs-chunked.xsl \
	  $(BASEDIR)/lfs-html.xml

	if [ ! -e $(BASEDIR)/stylesheets ]; then \
	  mkdir -p $(BASEDIR)/stylesheets; \
	fi;
	cp stylesheets/*.css $(BASEDIR)/stylesheets

	if [ ! -e $(BASEDIR)/images ]; then \
	  mkdir -p $(BASEDIR)/images; \
	fi;
	cp $(XSLROOTDIR)/images/*.png \
	  $(BASEDIR)/images
	cd $(BASEDIR)/; sed -i -e "s@../stylesheets@stylesheets@g" \
	  *.html
	cd $(BASEDIR)/; sed -i -e "s@../images@images@g" \
	  *.html

	rm $(BASEDIR)/lfs-html.xml

	sh goTidy $(BASEDIR)/

	for filename in `find $(BASEDIR) -name "*.html"`; do \
	  sed -i -e "s@text/html@application/xhtml+xml@g" $$filename; \
	done;

#
# Ceci est l'ancienne cible "pdf". L'ancienne cible "print" ci-dessus a été
# renommé en "pdf" et sera utilisée. Cette cible previous_pdf en commentaire
# peut être supprimée. Elle restera un peu ici pour des raisons historiques.
#
#previous_pdf:
#	xsltproc --xinclude --nonet --output $(BASEDIR)/lfs.fo stylesheets/lfs-pdf.xsl \
#	  index.xml
#	sed -i -e "s/inherit/all/" $(BASEDIR)/lfs.fo
#	fop.sh $(BASEDIR)/lfs.fo $(BASEDIR)/$(PDF_OUTPUT)
#	rm lfs.fo

pdf:
	xsltproc --xinclude --nonet --stringparam profile.condition pdf \
		--output $(BASEDIR)/lfs-pdf.xml stylesheets/lfs-profile.xsl index.xml
	xsltproc --nonet --output $(BASEDIR)/lfs-pdf.fo stylesheets/lfs-pdf.xsl \
		$(BASEDIR)/lfs-pdf.xml
	sed -i -e "s/inherit/all/" $(BASEDIR)/lfs-pdf.fo
	fop.sh $(BASEDIR)/lfs-pdf.fo $(BASEDIR)/$(PDF_OUTPUT)
	rm $(BASEDIR)/lfs-pdf.xml $(BASEDIR)/lfs-pdf.fo

nochunks:
	xsltproc --xinclude --nonet --output $(BASEDIR)/$(NOCHUNKS_OUTPUT) \
	  stylesheets/lfs-nochunks.xsl index.xml
	tidy -config tidy.conf $(BASEDIR)/$(NOCHUNKS_OUTPUT) || true

validate:
	xmllint --noout --nonet --xinclude --postvalid index.xml

