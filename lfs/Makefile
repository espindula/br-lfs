BASEDIR=~/lfs-book
DUMPDIR=~/lfs-commands
CHUNK_QUIET=0
PDF_OUTPUT=LFS-BOOK.pdf
NOCHUNKS_OUTPUT=LFS-BOOK.html
XSLROOTDIR=/usr/share/xml/docbook/xsl-stylesheets-current

lfs:
	xsltproc --xinclude --nonet -stringparam profile.condition html \
	-stringparam chunk.quietly $(CHUNK_QUIET)  -stringparam base.dir $(BASEDIR)/ \
	stylesheets/lfs-chunked.xsl index.xml

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

	for filename in `find $(BASEDIR) -name "*.html"`; do \
	  tidy -config tidy.conf $$filename; \
	  true; \
	  sh obfuscate.sh $$filename; \
	  sed -i -e "s@text/html@application/xhtml+xml@g" $$filename; \
	done;

# Uncomment this for testing and stable versions
pdf:
	xsltproc --xinclude --nonet --stringparam profile.condition pdf \
		--output $(BASEDIR)/lfs-pdf.xml stylesheets/lfs-profile.xsl index.xml
	xsltproc --nonet --output $(BASEDIR)/lfs-pdf.fo stylesheets/lfs-pdf.xsl \
		$(BASEDIR)/lfs-pdf.xml
	sed -i -e "s/inherit/all/" $(BASEDIR)/lfs-pdf.fo
	fop.sh $(BASEDIR)/lfs-pdf.fo $(BASEDIR)/$(PDF_OUTPUT)
	rm $(BASEDIR)/lfs-pdf.xml $(BASEDIR)/lfs-pdf.fo

nochunks:
	xsltproc --xinclude --nonet -stringparam profile.condition html \
	--output $(BASEDIR)/$(NOCHUNKS_OUTPUT) \
	  stylesheets/lfs-nochunks.xsl index.xml

	tidy -config tidy.conf $(BASEDIR)/$(NOCHUNKS_OUTPUT) || true

	sh obfuscate.sh $(BASEDIR)/$(NOCHUNKS_OUTPUT)

	sed -i -e "s@text/html@application/xhtml+xml@g"  \
	  $(BASEDIR)/$(NOCHUNKS_OUTPUT)

dump-commands:
	xsltproc --xinclude --nonet --output $(DUMPDIR)/ \
	   stylesheets/dump-commands.xsl index.xml

validate:
	xmllint --noout --nonet --xinclude --postvalid index.xml

