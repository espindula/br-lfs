BASEDIR = ~/hlfs-book
DUMPDIR = ~/hlfs-commands
RENDERTMP = $(HOME)/tmp
CHUNK_QUIET = 1
ROOT_ID =
PDF_OUTPUT = HLFS-BOOK.pdf
NOCHUNKS_OUTPUT = HLFS-BOOK.html

ifdef V
  Q =
else
  Q = @
endif

hlfs: maketar validxml profile-html
	@echo "Generating chunked XHTML files..."
	$(Q)xsltproc --nonet -stringparam chunk.quietly $(CHUNK_QUIET) \
	  -stringparam rootid "$(ROOT_ID)" -stringparam base.dir $(BASEDIR)/ \
	  stylesheets/lfs-chunked.xsl $(RENDERTMP)/hlfs-html.xml

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

pdf: validxml
	@echo "Generating profiled XML for PDF..."
	$(Q)xsltproc --nonet --stringparam profile.condition pdf \
	  --output $(RENDERTMP)/hlfs-pdf.xml stylesheets/lfs-xsl/profile.xsl \
	  $(RENDERTMP)/hlfs-full.xml

	@echo "Generating FO file..."
	$(Q)xsltproc --nonet -stringparam rootid "$(ROOT_ID)" \
	  --output $(RENDERTMP)/hlfs-pdf.fo stylesheets/lfs-pdf.xsl \
	  $(RENDERTMP)/hlfs-pdf.xml
	$(Q)sed -i -e 's/span="inherit"/span="all"/' $(RENDERTMP)/hlfs-pdf.fo
	$(Q)bash pdf-fixups.sh $(RENDERTMP)/hlfs-pdf.fo

	@echo "Generating PDF file..."
	$(Q)if [ ! -e $(BASEDIR) ]; then \
	  mkdir -p $(BASEDIR); \
	fi;
	$(Q)fop $(RENDERTMP)/hlfs-pdf.fo $(BASEDIR)/$(PDF_OUTPUT)

nochunks: maketar validxml profile-html
	@echo "Generating non chunked XHTML file..."
	$(Q)xsltproc --nonet -stringparam rootid "$(ROOT_ID)" \
	  --output $(BASEDIR)/$(NOCHUNKS_OUTPUT) \
	  stylesheets/lfs-nochunks.xsl $(RENDERTMP)/hlfs-html.xml

	@echo "Running Tidy..."
	$(Q)tidy -config tidy.conf $(BASEDIR)/$(NOCHUNKS_OUTPUT) || true
	@echo "Running obfuscate.sh..."
	$(Q)bash obfuscate.sh $(BASEDIR)/$(NOCHUNKS_OUTPUT)
	$(Q)sed -i -e "s@text/html@application/xhtml+xml@g"  \
	  $(BASEDIR)/$(NOCHUNKS_OUTPUT)

tmpdir:
	@echo "Creating and cleaning $(RENDERTMP)"
	$(Q)[ -d $(RENDERTMP) ] || mkdir -p $(RENDERTMP)
	$(Q)rm -f $(RENDERTMP)/hlfs-{full,html,pdf}.xml
	$(Q)rm -f $(RENDERTMP)/hlfs-pdf.fo

validxml: tmpdir
	@echo "Processing bootscripts..."
	$(Q)bash process-scripts.sh
	@echo "Validating the book..."
	$(Q)xmllint --nonet --noent --xinclude --postvalid \
	  -o $(RENDERTMP)/hlfs-full.xml index.xml
	$(Q)rm -f appendices/*.script
	$(Q)./aux-file-data.sh $(RENDERTMP)/hlfs-full.xml

maketar:
	@echo "Making tarballs..."
	$(Q)sh make-aux-files.sh

profile-html: validxml
	@echo "Generating profiled XML for XHTML..."
	$(Q)xsltproc --nonet --stringparam profile.condition html \
	  --output $(RENDERTMP)/hlfs-html.xml stylesheets/lfs-xsl/profile.xsl \
	  $(RENDERTMP)/hlfs-full.xml

wget-list:
	@echo "Generating wget list..."
	$(Q)mkdir -p $(BASEDIR)
	$(Q)xsltproc --xinclude --nonet --output $(BASEDIR)/wget-list \
	  stylesheets/wget-list.xsl chapter03/chapter03.xml

dump-commands: validxml
	@echo "Dumping book commands..."
	$(Q)xsltproc --output $(DUMPDIR)/ \
	   stylesheets/dump-commands.xsl $(RENDERTMP)/hlfs-full.xml

validate: maketar validxml
	@echo "Validation complete."

all: hlfs nochunks pdf dump-commands

.PHONY : all dump-commands hlfs nochunks pdf profile-html tmpdir validate \
	 validxml wget-list maketar
