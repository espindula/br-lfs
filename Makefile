BASEDIR=~/lfs-book
CHUNK_QUIET=0
PDF_OUTPUT=LFS-BOOK.pdf
PRINT_OUTPUT=LFS-BOOK-PRINTABLE.pdf
NOCHUNKS_OUTPUT=LFS-BOOK.html
XSLROOTDIR=/usr/share/xml/docbook/xsl-stylesheets-current

lfs:
	xsltproc --xinclude --nonet -stringparam chunk.quietly $(CHUNK_QUIET) \
	  -stringparam base.dir $(BASEDIR)/ stylesheets/lfs-chunked.xsl \
	  index.xml

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
	  index.html part1.html part2.html part3.html longindex.html
	cd $(BASEDIR)/; sed -i -e "s@../images@images@g" \
	  index.html part1.html part2.html part3.html longindex.html

	sh goTidy $(BASEDIR)/

pdf:
	xsltproc --xinclude --nonet --output lfs.fo stylesheets/lfs-pdf.xsl \
	  index.xml
	sed -i -e "s/inherit/all/" lfs.fo
	fop.sh lfs.fo $(PDF_OUTPUT)

print:
	xsltproc --xinclude --nonet --stringparam profile.condition print --output lfs-print.xml \
	  stylesheets/lfs-profile.xsl index.xml
	xsltproc --nonet --output lfs-print.fo stylesheets/lfs-print.xsl lfs-print.xml
	sed -i -e "s/inherit/all/" lfs-print.fo
	fop.sh lfs-print.fo $(PRINT_OUTPUT)

nochunks:
	xsltproc --xinclude --nonet --output $(NOCHUNKS_OUTPUT) \
	  stylesheets/lfs-nochunks.xsl index.xml
	tidy -config tidy.conf $(NOCHUNKS_OUTPUT) || true

validate:
	xmllint --noout --nonet --xinclude --postvalid index.xml
