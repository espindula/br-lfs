BASEDIR=~/lfs-book
DUMPDIR=~/lfs-commands
CHUNK_QUIET=1
ROOT_ID=""
PDF_OUTPUT=LFS-BOOK.pdf
NOCHUNKS_OUTPUT=LFS-BOOK.html

ifdef V
  Q =
else
  Q = @
endif

lfs: validxml profile-html
	@echo "Generating chunked XHTML files..."
	$(Q)xsltproc --nonet -stringparam chunk.quietly $(CHUNK_QUIET) \
	  -stringparam rootid $(ROOT_ID) -stringparam base.dir $(BASEDIR)/ \
	  stylesheets/lfs-chunked.xsl /tmp/lfs-html.xml

	@echo "Copying CSS code and images..."
	$(Q)if [ ! -e $(BASEDIR)/stylesheets ]; then \
	  mkdir -p $(BASEDIR)/stylesheets; \
	fi;
	$(Q)cp stylesheets/lfs-xsl/*.css $(BASEDIR)/stylesheets
	$(Q)if [ ! -e $(BASEDIR)/images ]; then \
	  mkdir -p $(BASEDIR)/images; \
	fi;
	$(Q)cp images/*.png $(BASEDIR)/images
	$(Q)cd $(BASEDIR)/; sed -i -e "s@../stylesheets@stylesheets@g" *.html
	$(Q)cd $(BASEDIR)/; sed -i -e "s@../images@images@g" *.html

	@echo "Running Tidy and obfuscate.sh..."
	$(Q)for filename in `find $(BASEDIR) -name "*.html"`; do \
	  tidy -config tidy.conf $$filename; \
	  true; \
	  sh obfuscate.sh $$filename; \
	  sed -i -e "s@text/html@application/xhtml+xml@g" $$filename; \
	done;

	$(Q)$(MAKE) wget-list

pdf: validxml
	@echo "Generating profiled XML for PDF..."
	$(Q)xsltproc --nonet --stringparam profile.condition pdf \
	  --output /tmp/lfs-pdf.xml stylesheets/lfs-xsl/profile.xsl \
	  /tmp/lfs-full.xml

	@echo "Generating FO file..."
	$(Q)xsltproc --nonet -stringparam rootid $(ROOT_ID) \
	  --output /tmp//lfs-pdf.fo stylesheets/lfs-pdf.xsl /tmp/lfs-pdf.xml
	$(Q)sed -i -e 's/span="inherit"/span="all"/' /tmp/lfs-pdf.fo

	@echo "Generating PDF file..."
	$(Q)fop /tmp/lfs-pdf.fo $(BASEDIR)/$(PDF_OUTPUT)

nochunks: validxml profile-html
	@echo "Generating non chunked XHTML file..."
	$(Q)xsltproc --nonet -stringparam profile.condition html \
	  -stringparam rootid $(ROOT_ID) --output $(BASEDIR)/$(NOCHUNKS_OUTPUT) \
	  stylesheets/lfs-nochunks.xsl /tmp/lfs-html.xml

	@echo "Running Tidy..."
	$(Q)tidy -config tidy.conf $(BASEDIR)/$(NOCHUNKS_OUTPUT) || true
	@echo "Running obfuscate.sh..."
	$(Q)sh obfuscate.sh $(BASEDIR)/$(NOCHUNKS_OUTPUT)
	$(Q)sed -i -e "s@text/html@application/xhtml+xml@g"  \
	  $(BASEDIR)/$(NOCHUNKS_OUTPUT)

validxml:
	@echo "Validating the book..."
	$(Q)xmllint --nonet --noent --xinclude --postvalid \
	  -o /tmp/lfs-full.xml index.xml

profile-html: validxml
	@echo "Generating profiled XML for XHTML..."
	$(Q)xsltproc --nonet --stringparam profile.condition html \
	  --output /tmp/lfs-html.xml stylesheets/lfs-xsl/profile.xsl \
	  /tmp/lfs-full.xml

wget-list:
	@echo "Generating wget list..."
	$(Q)mkdir -p $(BASEDIR)
	$(Q)xsltproc --xinclude --nonet --output $(BASEDIR)/wget-list \
	  stylesheets/wget-list.xsl chapter03/chapter03.xml

dump-commands: validxml
	@echo "Dumping book commands..."
	$(Q)xsltproc --output $(DUMPDIR)/ \
	   stylesheets/dump-commands.xsl /tmp/lfs-full.xml

validate:
	@echo "Validating the book..."
	$(Q)xmllint --noout --nonet --xinclude --postvalid index.xml

all: lfs nochunks pdf dump-commands

.PHONY : all dump-commands lfs nochunks pdf profile-html validate validxml wget-list
