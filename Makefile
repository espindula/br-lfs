BASEDIR=~/lfs-book/

lfs:
	xsltproc --xinclude --nonet -stringparam base.dir $(BASEDIR) \
	  stylesheets/lfs-chunked.xsl index.xml

	if [ ! -e $(BASEDIR)stylesheets ]; then \
	  mkdir -p $(BASEDIR)stylesheets; \
	fi;
	cp stylesheets/lfs.css $(BASEDIR)stylesheets

	if [ ! -e $(BASEDIR)images ]; then \
	  mkdir -p $(BASEDIR)images; \
	fi;
	cp /usr/share/xml/docbook/xsl-stylesheets-1.65.1/images/*.png \
	  $(BASEDIR)images
	cd $(BASEDIR); sed -i -e "s@../stylesheets@stylesheets@" \
	  index.html part1.html part2.html part3.html longindex.html
	cd $(BASEDIR); sed -i -e "s@../images@images@g" \
	  index.html part1.html part2.html part3.html longindex.html

pdf:
	xsltproc --xinclude --nonet --output lfs.fo stylesheets/lfs-pdf.xsl \
	  index.xml
	sed -i -e "s/inherit/all/" lfs.fo
	fop.sh lfs.fo lfs.pdf

validate:
	xmllint --noout --nonet --xinclude --postvalid index.xml
