BASEDIR = ~/lfs-book
DUMPDIR = ~/lfs-commands
RENDERTMP = $(HOME)/tmp
CHUNK_QUIET = 1
ROOT_ID =
PDF_OUTPUT = LFS-BOOK.pdf
NOCHUNKS_OUTPUT = LFS-BOOK.html
SHELL = /bin/bash

ifdef V
  Q =
else
  Q = @
endif

lfs: validate profile-html
	@echo "Generating chunked XHTML files..."
	$(Q)xsltproc --nonet -stringparam chunk.quietly $(CHUNK_QUIET) \
	  -stringparam rootid "$(ROOT_ID)" -stringparam base.dir $(BASEDIR)/ \
	  stylesheets/lfs-chunked.xsl $(RENDERTMP)/lfs-html.xml

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
	  /bin/bash obfuscate.sh $$filename; \
	  sed -i -e "s@text/html@application/xhtml+xml@g" $$filename; \
	done;

	$(Q)$(MAKE) wget-list

pdf: validate
	@echo "Generating profiled XML for PDF..."
	$(Q)xsltproc --nonet --stringparam profile.condition pdf \
	  --output $(RENDERTMP)/lfs-pdf.xml stylesheets/lfs-xsl/profile.xsl \
	  $(RENDERTMP)/lfs-full.xml

	@echo "Generating FO file..."
	$(Q)xsltproc --nonet -stringparam rootid "$(ROOT_ID)" \
	  --output $(RENDERTMP)/lfs-pdf.fo stylesheets/lfs-pdf.xsl \
	  $(RENDERTMP)/lfs-pdf.xml
	$(Q)sed -i -e 's/span="inherit"/span="all"/' $(RENDERTMP)/lfs-pdf.fo
	$(Q)bash pdf-fixups.sh $(RENDERTMP)/lfs-pdf.fo

	@echo "Generating PDF file..."
	$(Q)if [ ! -e $(BASEDIR) ]; then \
	  mkdir -p $(BASEDIR); \
	fi;
	$(Q)fop $(RENDERTMP)/lfs-pdf.fo $(BASEDIR)/$(PDF_OUTPUT)

nochunks: validate profile-html
	@echo "Generating non chunked XHTML file..."
	$(Q)xsltproc --nonet -stringparam rootid "$(ROOT_ID)" \
	  --output $(BASEDIR)/$(NOCHUNKS_OUTPUT) \
	  stylesheets/lfs-nochunks.xsl $(RENDERTMP)/lfs-html.xml

	@echo "Running Tidy..."
	$(Q)tidy -config tidy.conf $(BASEDIR)/$(NOCHUNKS_OUTPUT) || true
	@echo "Running obfuscate.sh..."
	$(Q)bash obfuscate.sh $(BASEDIR)/$(NOCHUNKS_OUTPUT)
	$(Q)sed -i -e "s@text/html@application/xhtml+xml@g"  \
	  $(BASEDIR)/$(NOCHUNKS_OUTPUT)
	$(Q)sed -i -e "s@../wget-list@wget-list@"  \
	  $(BASEDIR)/$(NOCHUNKS_OUTPUT)
	$(Q)$(MAKE) wget-list

tmpdir:
	@echo "Creating and cleaning $(RENDERTMP)"
	$(Q)[ -d $(RENDERTMP) ] || mkdir -p $(RENDERTMP)
	$(Q)rm -f $(RENDERTMP)/lfs-{full,html,pdf}.xml
	$(Q)rm -f $(RENDERTMP)/lfs-pdf.fo

validate: tmpdir
	@echo "Processing bootscripts..."
	$(Q)bash process-scripts.sh
	@echo "Validating the book..."
	$(Q)xmllint --nonet --noent --xinclude --postvalid \
	  -o $(RENDERTMP)/lfs-full.xml index.xml
	$(Q)rm -f appendices/*.script
	$(Q)./aux-file-data.sh $(RENDERTMP)/lfs-full.xml
	@echo "Validation complete."

profile-html: validate
	@echo "Generating profiled XML for XHTML..."
	$(Q)xsltproc --nonet --stringparam profile.condition html \
	  --output $(RENDERTMP)/lfs-html.xml stylesheets/lfs-xsl/profile.xsl \
	  $(RENDERTMP)/lfs-full.xml

wget-list:
	@echo "Generating wget list..."
	$(Q)mkdir -p $(BASEDIR)
	$(Q)xsltproc --xinclude --nonet --output $(BASEDIR)/wget-list \
	  stylesheets/wget-list.xsl chapter03/chapter03.xml

md5sums:
	@echo "Generating md5sum file..."
	$(Q)mkdir -p $(BASEDIR)
	$(Q)xsltproc --xinclude --nonet --output $(BASEDIR)/md5sums \
	  stylesheets/md5sum.xsl chapter03/chapter03.xml
	$(Q)sed -i -e "s/BOOTSCRIPTS-MD5SUM/$(shell md5sum lfs-bootscripts*.tar.bz2 | cut -d' ' -f1)/" \
      $(BASEDIR)/md5sums
	$(Q)sed -i -e "s/UDEV-MD5SUM/$(shell md5sum udev-config*.tar.bz2 | cut -d' ' -f1)/" \
      $(BASEDIR)/md5sums


dump-commands: validate
	@echo "Dumping book commands..."
	$(Q)xsltproc --output $(DUMPDIR)/ \
	   stylesheets/dump-commands.xsl $(RENDERTMP)/lfs-full.xml


all: lfs nochunks pdf dump-commands md5sums

.PHONY : all dump-commands lfs nochunks pdf profile-html tmpdir validate \
	 validate wget-list maketar md5sums
