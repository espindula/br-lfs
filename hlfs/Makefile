BASEDIR = ~/hlfs-book
RENDERTMP = $(HOME)/tmp
CHUNK_QUIET = 1
ROOT_ID =

# This variables don't should be overwritten by command line
DUMPDIR = $(BASEDIR)/$(LIBC)-$(KERNEL)-commands
PDF_OUTPUT = HLFS-BOOK-$(LIBC)-$(KERNEL).pdf
NOCHUNKS_OUTPUT = HLFS-BOOK-$(LIBC)-$(KERNEL).html

ifdef V
  Q =
else
  Q = @
endif

# By default, generates all HTML books plus top-level and wget-list files
all: html wget-list

# Validate the book
validate:
	@echo "Validating the book..."
	$(Q)xmllint --noout --nonet --xinclude --postvalid index.xml

# HTML books
html: top-level glibc-26-book glibc-24-book uclibc-26-book uclibc-24-book common-stuff

# PDF books
pdf: glibc26pdf glibc24pdf uclibc26pdf uclibc24pdf

# Nonchunked books
nochunks: glibc26nochunk glibc24nochunk uclibc26nochunk uclibc24nochunk

# Dump commands
dump-commands: dump-glibc26 dump-glibc24 dump-uclibc26 dump-uclibc24

# Wget lists
wget-list: wget-glibc26 wget-glibc24 wget-uclibc26 wget-uclibc24

# All-in-one
world: all pdf nochunks dump-commands wget-list

# Targets for individual chunked books with top-level files
glibc26: top-level glibc-26-book common-stuff
glibc24: top-level glibc-24-book common-stuff
uclibc26: top-level uclibc-26-book common-stuff
uclibc24: top-level uclibc-24-book common-stuff

# Dump the book into a unique XML file with Xincludes and entities solved,
# then validate it. Useful to improve rendering speed on large tergets.
validxml: tmpdir
	@echo "Validating the book..."
	$(Q)xmllint --nonet --noent --xinclude --postvalid \
	  -o $(RENDERTMP)/hlfs-full.xml index.xml

# Be sure that RENDERDIR esist and clean it
tmpdir:
	@echo "Creating and cleaning $(RENDERTMP)"
	$(Q)[ -d $(RENDERTMP) ] || mkdir -p $(RENDERTMP)
	$(Q)rm -f $(RENDERTMP)/hlfs-{full,html,pdf,dump}.xml
	$(Q)rm -f $(RENDERTMP)/hlfs-pdf.fo


# CHUNKED BOOKS SUB-TARGETS #

# top-level index.html
top-level:
	@echo "Generating top-level files..."
	$(Q)xsltproc --nonet --output $(BASEDIR)/index.html \
	  stylesheets/top-index.xsl prologue/bookinfo.xml

	$(Q)xsltproc --xinclude --nonet -stringparam chapter.autolabel 0 \
	  -stringparam section.autolabel 0 --output $(BASEDIR)/features.html \
	  stylesheets/hlfs-nochunks.xsl features.xml

	$(Q)if [ ! -e $(BASEDIR)/images ]; then \
	  mkdir -p $(BASEDIR)/images; \
	fi;
	$(Q)cp images/*.png $(BASEDIR)/images
	$(Q)cp stylesheets/features.js $(BASEDIR)

# Books variables
glibc-26-book glibc-24-book:   LIBC=glibc
uclibc-26-book uclibc-24-book: LIBC=uclibc
glibc-26-book uclibc-26-book:  KERNEL=2.6
glibc-24-book uclibc-24-book:  KERNEL=2.4

# Chunked books targets
glibc-26-book uclibc-26-book glibc-24-book uclibc-24-book: validxml
	@echo "Generating profiled XML for XHTML $(LIBC) + $(KERNEL)..."
	$(Q)xsltproc --nonet --stringparam profile.condition html,$(LIBC) \
	  -stringparam profile.vendor $(KERNEL) --output $(RENDERTMP)/hlfs-html.xml \
	  stylesheets/lfs-xsl/profile.xsl $(RENDERTMP)/hlfs-full.xml

	@echo "Generating chunked XHTML files..."
	$(Q)xsltproc --nonet -stringparam chunk.quietly $(CHUNK_QUIET) \
	  -stringparam rootid "$(ROOT_ID)" \
	  -stringparam base.dir $(BASEDIR)/$(LIBC)-$(KERNEL)/ \
	  stylesheets/hlfs-chunked.xsl $(RENDERTMP)/hlfs-html.xml

	@echo "Copying CSS code and images..."
	$(Q)if [ ! -e $(BASEDIR)/$(LIBC)-$(KERNEL)/stylesheets ]; then \
	  mkdir -p $(BASEDIR)/$(LIBC)-$(KERNEL)/stylesheets; \
	fi;
	$(Q)cp stylesheets/lfs-xsl/*.css $(BASEDIR)/$(LIBC)-$(KERNEL)/stylesheets
	$(Q)if [ ! -e $(BASEDIR)/$(LIBC)-$(KERNEL)/images ]; then \
	  mkdir -p $(BASEDIR)/$(LIBC)-$(KERNEL)/images; \
	fi;
	$(Q)cp images/*.png $(BASEDIR)/$(LIBC)-$(KERNEL)/images
	$(Q)cd $(BASEDIR)/$(LIBC)-$(KERNEL)/; sed -i -e "s@../stylesheets@stylesheets@g" *.html
	$(Q)cd $(BASEDIR)/$(LIBC)-$(KERNEL)/; sed -i -e "s@../images@images@g" *.html

# Common stuff for top-level and chunked books
common-stuff:
	@echo "Running Tidy and obfuscate.sh..."
	$(Q)for filename in `find $(BASEDIR) -name "*.html"`; do \
	  tidy -config tidy.conf $$filename; \
	  true; \
	  sh obfuscate.sh $$filename; \
	  sed -i -e "s@text/html@application/xhtml+xml@g" $$filename; \
	done;

#-----------------------#


# PDF BOOKS SUB-TARGETS #

# Books variables
glibc26pdf glibc24pdf:   LIBC=glibc
uclibc26pdf uclibc24pdf: LIBC=uclibc
glibc26pdf uclibc26pdf:  KERNEL=2.6
glibc24pdf uclibc24pdf:  KERNEL=2.4

glibc26pdf glibc24pdf uclibc26pdf uclibc24pdf: validxml
	@echo "Generating profiled XML for PDF $(LIBC) + $(KERNEL)..."
	$(Q)xsltproc --nonet --stringparam profile.condition pdf,$(LIBC) \
	  -stringparam profile.vendor $(KERNEL) --output $(RENDERTMP)/hlfs-pdf.xml \
	  stylesheets/lfs-xsl/profile.xsl $(RENDERTMP)/hlfs-full.xml

	@echo "Generating FO file..."
	$(Q)xsltproc --nonet -stringparam rootid "$(ROOT_ID)" \
	  --output $(RENDERTMP)/hlfs-pdf.fo stylesheets/hlfs-pdf.xsl \
	  $(RENDERTMP)/hlfs-pdf.xml
	$(Q)sed -i -e 's/span="inherit"/span="all"/' $(RENDERTMP)/hlfs-pdf.fo

	@echo "Generating PDF file..."
	$(Q)[ -d $(BASEDIR) ] || mkdir -p $(BASEDIR)
	$(Q)fop $(RENDERTMP)/hlfs-pdf.fo $(BASEDIR)/$(PDF_OUTPUT)

#-----------------------#


# NOCHUNK BOOKS SUB-TARGETS #

# Books variables
glibc26nochunk glibc24nochunk:   LIBC=glibc
uclibc26nochunk uclibc24nochunk: LIBC=uclibc
glibc26nochunk uclibc26nochunk:  KERNEL=2.6
glibc24nochunk uclibc24nochunk:  KERNEL=2.4

glibc26nochunk glibc24nochunk uclibc26nochunk uclibc24nochunk: validxml
	@echo "Generating profiled XML for XHTML $(LIBC) + $(KERNEL)..."
	$(Q)xsltproc --nonet --stringparam profile.condition html,$(LIBC) \
	  -stringparam profile.vendor $(KERNEL) --output $(RENDERTMP)/hlfs-html.xml \
	  stylesheets/lfs-xsl/profile.xsl $(RENDERTMP)/hlfs-full.xml

	@echo "Generating non chunked XHTML file..."
	$(Q)xsltproc --nonet -stringparam rootid "$(ROOT_ID)" \
	  --output $(BASEDIR)/$(NOCHUNKS_OUTPUT) \
	  stylesheets/hlfs-nochunks.xsl $(RENDERTMP)/hlfs-html.xml

	@echo "Running Tidy..."
	$(Q)tidy -config tidy.conf $(BASEDIR)/$(NOCHUNKS_OUTPUT) || true

	@echo "Running obfuscate.sh..."
	$(Q)sh obfuscate.sh $(BASEDIR)/$(NOCHUNKS_OUTPUT)

	$(Q)sed -i -e "s@text/html@application/xhtml+xml@g"  \
	  $(BASEDIR)/$(NOCHUNKS_OUTPUT)

#-----------------------#


# DUMP-COMMANDS SUB-TARGETS #

# Books variables
dump-glibc26 dump-glibc24:   LIBC=glibc
dump-uclibc26 dump-uclibc24: LIBC=uclibc
dump-glibc26 dump-uclibc26:  KERNEL=2.6
dump-glibc24 dump-uclibc24:  KERNEL=2.4

dump-glibc26 dump-glibc24 dump-uclibc26 dump-uclibc24: validxml
	@echo "Dumping book commands for $(LIBC) + $(KERNEL)..."
	$(Q)xsltproc --nonet --stringparam profile.condition html,$(LIBC) \
	  -stringparam profile.vendor $(KERNEL) --output $(RENDERTMP)/hlfs-dump.xml \
	  stylesheets/lfs-xsl/profile.xsl $(RENDERTMP)/hlfs-full.xml

	$(Q)xsltproc --nonet --output $(DUMPDIR)/ \
	   stylesheets/dump-commands.xsl $(RENDERTMP)/hlfs-dump.xml

#-----------------------#


# WGET-LIST SUB-TARGETS #

# Books variables
wget-glibc26 wget-glibc24:   LIBC=glibc
wget-uclibc26 wget-uclibc24: LIBC=uclibc
wget-glibc26 wget-uclibc26:  KERNEL=2.6
wget-glibc24 wget-uclibc24:  KERNEL=2.4

wget-glibc26 wget-glibc24 wget-uclibc26 wget-uclibc24:
	@echo "Generating wget list for $(LIBC) + $(KERNEL)..."
	$(Q)mkdir -p $(BASEDIR)
	$(Q)xsltproc --xinclude --nonet -stringparam libc $(LIBC) \
	  -stringparam kernel $(KERNEL) --output $(BASEDIR)/wget-$(LIBC)-$(KERNEL)-list \
	  stylesheets/wget-list.xsl chapter04/chapter04.xml

#-----------------------#

.PHONY: all common-stuff dump-commands dump-glibc24 dump-glibc26 dump-uclibc24 \
	dump-uclibc26 glibc24 glibc-24-book glibc24nochunk glibc24pdf glibc26 \
	glibc-26-book glibc26nochunk glibc26pdf html nochunks pdf top-level uclibc24 \
	uclibc-24-book uclibc24nochunk uclibc24pdf uclibc26 uclibc-26-book \
	uclibc26nochunk uclibc26pdf validate wget-glibc24 wget-glibc26 wget-list \
	wget-uclibc24 wget-uclibc26 world validxml

