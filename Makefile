BASEDIR=~/lfs-book
CHUNK_QUIET=0
PDF_OUTPUT=LFS-BOOK.pdf
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

#
# This is the old "pdf" target. The old "print" target below has been
# renamed to "pdf" and will be used. This commented out previous_pdf
# target can be removed eventually. It'll remain here for a bit for
# historical reasons
#
#previous_pdf:
#	xsltproc --xinclude --nonet --output $(BASEDIR)/lfs.fo stylesheets/lfs-pdf.xsl \
#	  index.xml
#	sed -i -e "s/inherit/all/" $(BASEDIR)/lfs.fo
#	fop.sh $(BASEDIR)/lfs.fo $(BASEDIR)/$(PDF_OUTPUT)
#	rm lfs.fo

pdf:
	xsltproc --xinclude --nonet --stringparam profile.condition print \
		--output $(BASEDIR)/lfs-pdf.xml stylesheets/lfs-profile.xsl index-pdf.xml
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

