BASEDIR=/home/macana/LFS/test-book-LFS/

lfs:
	xsltproc --xinclude --nonet -stringparam base.dir $(BASEDIR) \
	  stylesheets/lfs-chunked.xsl index.xml

	mkdir -p $(BASEDIR)stylesheets && \
	cp stylesheets/*.css $(BASEDIR)stylesheets

	mkdir -p $(BASEDIR)images && \
	cp /usr/share/xml/docbook/xsl-stylesheets-1.65.1/images/*.png \
  	$(BASEDIR)images

	cd $(BASEDIR); sed -i -e "s@../stylesheets@stylesheets@g" \
	  index.html part1.html part2.html part3.html longindex.html
	cd $(BASEDIR); sed -i -e "s@../images@images@g" \
	  index.html part1.html part2.html part3.html longindex.html

	goTidy

pdf:
	xsltproc --xinclude --nonet --output $(BASEDIR)lfs.fo stylesheets/lfs-pdf.xsl \
	  index.xml
	cd $(BASEDIR)
	sed -i -e "s@inherit@all@" lfs.fo
	JAVA_HOME=/opt/java/jre1.3.1_02 FOP_HOME=/home/macana/tmp/fop \
  /home/macana/tmp/fop/fop.sh lfs.fo lfs.pdf

print:
	xsltproc --xinclude --nonet --output $(BASEDIR)lfs-print.fo stylesheets/lfs-print.xsl \
	  index.xml
	cd $(BASEDIR)
	sed -i -e "s@inherit@all@" lfs-print.fo
	JAVA_HOME=/opt/java/jre1.3.1_02 FOP_HOME=/home/macana/tmp/fop \
  /home/macana/tmp/fop/fop.sh lfs-print.fo lfs-print.pdf

nochunks:
	xsltproc --xinclude --nonet --output $(BASEDIR)lfs-nochunk.html \
	  stylesheets/lfs-nochunks.xsl index.xml
	tidy -config tidy.conf $(BASEDIR)lfs-nochunk.html || true

validate:
	xmllint --noout --nonet --xinclude --postvalid index.xml
 

