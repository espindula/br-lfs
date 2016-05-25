BASEDIR = ~/lfs-book
SYSDDIR = ~/lfs-systemd
DUMPDIR = ~/lfs-commands
RENDERTMP = $(HOME)/tmp
CHUNK_QUIET = 1
ROOT_ID =
PDF_OUTPUT = LFS-BOOK.pdf
NOCHUNKS_OUTPUT = LFS-BOOK.html
NOCHUNKS_SYSD_FILE = LFS-SYSD-BOOK.html
SHELL = /bin/bash

ifdef V
  Q =
else
  Q = @
endif

sysv: validate profile-html
	$(Q)xsltproc --nonet                   \
      --output $(RENDERTMP)/lfs-html2.xml \
      --stringparam profile.revision sysv \
      stylesheets/lfs-xsl/profile.xsl     \
      $(RENDERTMP)/lfs-html.xml

	@echo "Generating chunked XHTML files..."
	$(Q)xsltproc --nonet                          \
      --stringparam chunk.quietly $(CHUNK_QUIET) \
      --stringparam rootid "$(ROOT_ID)"          \
      --stringparam base.dir $(BASEDIR)/         \
      stylesheets/lfs-chunked.xsl                \
      $(RENDERTMP)/lfs-html2.xml

	@echo "Copying CSS code and images..."
	$(Q)mkdir -p $(BASEDIR)/stylesheets
	$(Q)cp stylesheets/lfs-xsl/*.css $(BASEDIR)/stylesheets
	$(Q)pushd $(BASEDIR)/ > /dev/null;                     \
       sed -i -e "s@../stylesheets@stylesheets@g" *.html; \
       popd > /dev/null

	$(Q)mkdir -p $(BASEDIR)/images
	$(Q)cp images/*.png $(BASEDIR)/images

	@echo "Running Tidy and obfuscate.sh..."
	$(Q)for filename in `find $(BASEDIR) -name "*.html"`; do \
         tidy -config tidy.conf $$filename;           \
         true;                                        \
         /bin/bash obfuscate.sh $$filename;           \
         sed -e "s@text/html@application/xhtml+xml@g" \
             -e "s/\xa9/\&copy;/ "                    \
             -i $$filename;                           \
   done;

	$(Q)$(MAKE) --no-print-directory wget-list md5sums

systemd: validated profile-html
	$(Q)xsltproc --nonet                      \
      --output $(RENDERTMP)/lfs-html2.xml    \
      --stringparam profile.revision systemd \
      stylesheets/lfs-xsl/profile.xsl        \
      $(RENDERTMP)/lfs-html.xml

	@echo "Generating chunked XHTML files..."
	$(Q)xsltproc --nonet                          \
      --stringparam chunk.quietly $(CHUNK_QUIET) \
      --stringparam rootid "$(ROOT_ID)"          \
      --stringparam base.dir $(SYSDDIR)/         \
      stylesheets/lfs-chunked.xsl                \
      $(RENDERTMP)/lfs-html2.xml

	@echo "Copying CSS code and images..."
	$(Q)mkdir -p $(SYSDDIR)/stylesheets
	$(Q)cp stylesheets/lfs-xsl/*.css $(SYSDDIR)/stylesheets

	$(Q)mkdir -p $(SYSDDIR)/images
	$(Q)cp images/*.png $(SYSDDIR)/images

	@echo "Running Tidy and obfuscate.sh..."
	$(Q)for filename in `find $(SYSDDIR) -name "*.html"`; do \
         tidy -config tidy.conf $$filename;           \
         true;                                        \
         /bin/bash obfuscate.sh $$filename;           \
         sed -e "s@text/html@application/xhtml+xml@g" \
             -e "s/\xa9/\&copy;/ "                    \
             -i $$filename;                           \
       done;

	$(Q)$(MAKE) --no-print-directory wget-listd md5sumsd

pdf: validate
	@echo "Generating profiled XML for PDF..."
	$(Q)xsltproc --nonet \
                --stringparam profile.condition pdf \
                --stringparam profile.revision sysv \
                --output $(RENDERTMP)/lfs-pdf.xml   \
                stylesheets/lfs-xsl/profile.xsl     \
                $(RENDERTMP)/lfs-full.xml

	@echo "Generating FO file..."
	$(Q)xsltproc --nonet                           \
                --stringparam rootid "$(ROOT_ID)" \
                --output $(RENDERTMP)/lfs-pdf.fo  \
                stylesheets/lfs-pdf.xsl           \
                $(RENDERTMP)/lfs-pdf.xml

	$(Q)sed -i -e 's/span="inherit"/span="all"/' $(RENDERTMP)/lfs-pdf.fo
	$(Q)bash pdf-fixups.sh $(RENDERTMP)/lfs-pdf.fo

	@echo "Generating PDF file..."
	$(Q)mkdir -p $(BASEDIR)

	$(Q)fop -q  $(RENDERTMP)/lfs-pdf.fo $(BASEDIR)/$(PDF_OUTPUT) 2>fop.log
	@echo "$(BASEDIR)/$(PDF_OUTPUT) created"
	@echo "fop.log created"

nochunks: validate profile-html
	$(Q)xsltproc --nonet                             \
                --output $(RENDERTMP)/lfs-html2.xml \
                --stringparam profile.revision sysv \
                stylesheets/lfs-xsl/profile.xsl     \
                $(RENDERTMP)/lfs-html.xml

	@echo "Generating non chunked XHTML file..."
	$(Q)xsltproc --nonet                                \
                --stringparam rootid "$(ROOT_ID)"      \
                --output $(BASEDIR)/$(NOCHUNKS_OUTPUT) \
                stylesheets/lfs-nochunks.xsl           \
                $(RENDERTMP)/lfs-html2.xml

	@echo "Running Tidy..."
	$(Q)tidy -config tidy.conf $(BASEDIR)/$(NOCHUNKS_OUTPUT) || true

	@echo "Running obfuscate.sh..."
	$(Q)bash obfuscate.sh                                $(BASEDIR)/$(NOCHUNKS_OUTPUT)
	$(Q)sed -i -e "s@text/html@application/xhtml+xml@g"  $(BASEDIR)/$(NOCHUNKS_OUTPUT)
	$(Q)sed -i -e "s@../wget-list@wget-list@"            $(BASEDIR)/$(NOCHUNKS_OUTPUT)
	$(Q)sed -i -e "s@../md5sums@md5sums@"                $(BASEDIR)/$(NOCHUNKS_OUTPUT)
	$(Q)sed -i -e "s@\xa9@\&copy;@"                      $(BASEDIR)/$(NOCHUNKS_OUTPUT)

	@echo "Output at $(BASEDIR)/$(NOCHUNKS_OUTPUT)"

nochunksd: validated profile-html
	$(Q)xsltproc --nonet                                \
                --output $(RENDERTMP)/lfs-html2.xml    \
                --stringparam profile.revision systemd \
                stylesheets/lfs-xsl/profile.xsl        \
                $(RENDERTMP)/lfs-html.xml

	@echo "Generating non chunked XHTML file..."
	$(Q)xsltproc --nonet                                   \
                --stringparam rootid "$(ROOT_ID)"         \
                --output $(SYSDDIR)/$(NOCHUNKS_SYSD_FILE) \
                stylesheets/lfs-nochunks.xsl              \
                $(RENDERTMP)/lfs-html2.xml

	@echo "Running Tidy..."
	$(Q)tidy -config tidy.conf $(SYSDDIR)/$(NOCHUNKS_SYSD_FILE) || true

	@echo "Running obfuscate.sh..."
	$(Q)bash obfuscate.sh                                $(SYSDDIR)/$(NOCHUNKS_SYSD_FILE)
	$(Q)sed -i -e "s@text/html@application/xhtml+xml@g"  $(SYSDDIR)/$(NOCHUNKS_SYSD_FILE)
	$(Q)sed -i -e "s@../wget-list@wget-list@"            $(SYSDDIR)/$(NOCHUNKS_SYSD_FILE)
	$(Q)sed -i -e "s@../md5sums@md5sums@"                $(SYSDDIR)/$(NOCHUNKS_SYSD_FILE)
	$(Q)sed -i -e "s@\xa9@\&copy;@"                      $(SYSDDIR)/$(NOCHUNKS_SYSD_FILE)

	@echo "Output at $(SYSDDIR)/$(NOCHUNKS_SYSD_FILE)"

tmpdir:
	@echo "Creating and cleaning $(RENDERTMP)"
	$(Q)mkdir -p $(RENDERTMP)
	$(Q)rm -f $(RENDERTMP)/lfs*.xml
	$(Q)rm -f $(RENDERTMP)/sysd*.xml
	$(Q)rm -f $(RENDERTMP)/*pdf.fo

validate: tmpdir
	@echo "Processing bootscripts..."
	$(Q)bash process-scripts.sh
	@echo "Validating the book..."
	$(Q)xmllint --nonet                      \
               --noent                      \
               --xinclude                   \
               --postvalid                  \
	            -o $(RENDERTMP)/lfs-full.xml \
               index.xml
	$(Q)rm -f appendices/*.script
	$(Q)./aux-file-data.sh $(RENDERTMP)/lfs-full.xml
	@echo "Validation complete."

validated: tmpdir
	@echo "Validating the book..."
	$(Q)xmllint --nonet                      \
               --noent                      \
               --xinclude                   \
               --postvalid                  \
	            -o $(RENDERTMP)/lfs-full.xml \
               indexd.xml
	@echo "Validation complete."

profile-html: 
	@echo "Generating profiled XML for XHTML..."
	$(Q)xsltproc --nonet                              \
                --stringparam profile.condition html \
	             --output $(RENDERTMP)/lfs-html.xml   \
                stylesheets/lfs-xsl/profile.xsl      \
	             $(RENDERTMP)/lfs-full.xml

wget-list: $(BASEDIR)/wget-list
$(BASEDIR)/wget-list: stylesheets/wget-list.xsl chapter03/chapter03.xml \
                      packages.ent patches.ent
	@echo "Generating wget list for sysv..."
	$(Q)mkdir -p $(BASEDIR)

	$(Q)xsltproc --nonet --xinclude                  \
                --stringparam profile.revision sysv \
                --output $(RENDERTMP)/sysd-wget.xml \
                stylesheets/lfs-xsl/profile.xsl     \
                chapter03/chapter03.xml

	$(Q)xsltproc --xinclude --nonet            \
                --output $(BASEDIR)/wget-list \
	             stylesheets/wget-list.xsl     \
                chapter03/chapter03.xml

wget-listd: $(SYSDDIR)/wget-listd
$(SYSDDIR)/wget-listd: stylesheets/wget-list.xsl chapter03/chapter03.xml \
                       packages.ent patches.ent
	@echo "Generating wget list for systemd..."
	$(Q)mkdir -p $(SYSDDIR)

	$(Q)xsltproc --xinclude --nonet                     \
                --stringparam profile.revision systemd \
                --output $(RENDERTMP)/sysd-wget.xml    \
                stylesheets/lfs-xsl/profile.xsl        \
                chapter03/chapter03.xml

	$(Q)xsltproc --xinclude --nonet            \
                --output $(SYSDDIR)/wget-list \
                stylesheets/wget-list.xsl     \
                $(RENDERTMP)/sysd-wget.xml

md5sums: $(BASEDIR)/md5sums
$(BASEDIR)/md5sums: stylesheets/wget-list.xsl chapter03/chapter03.xml \
                    packages.ent patches.ent
	@echo "Generating md5sum file for sysv..."
	$(Q)mkdir -p $(BASEDIR)

	$(Q)xsltproc --nonet --xinclude                    \
                --stringparam profile.revision sysv   \
                --output $(RENDERTMP)/sysv-md5sum.xml \
                stylesheets/lfs-xsl/profile.xsl       \
                chapter03/chapter03.xml

	$(Q)xsltproc --xinclude --nonet          \
                --output $(BASEDIR)/md5sums \
                stylesheets/md5sum.xsl      \
                $(RENDERTMP)/sysv-md5sum.xml
	$(Q)sed -i -e \
       "s/BOOTSCRIPTS-MD5SUM/$(shell md5sum lfs-bootscripts*.tar.bz2 | cut -d' ' -f1)/" \
       $(BASEDIR)/md5sums

md5sumsd: $(SYSDDIR)/md5sums
$(SYSDDIR)/md5sums: stylesheets/wget-list.xsl chapter03/chapter03.xml \
                    packages.ent patches.ent
	@echo "Generating md5sum file for systemd..."
	$(Q)mkdir -p $(SYSDDIR)
	$(Q)xsltproc --nonet --xinclude                     \
                --stringparam profile.revision systemd \
                --output $(RENDERTMP)/sysd-md5sum.xml  \
                stylesheets/lfs-xsl/profile.xsl        \
                chapter03/chapter03.xml

	$(Q)xsltproc --xinclude --nonet          \
                --output $(SYSDDIR)/md5sums \
	             stylesheets/md5sum.xsl      \
                $(RENDERTMP)/sysd-md5sum.xml

dump-commands: validate
	@echo "Dumping book commands..."
	$(Q)xsltproc --nonet                   \
      --output $(RENDERTMP)/lfs-html.xml  \
      --stringparam profile.revision sysv \
      stylesheets/lfs-xsl/profile.xsl     \
      $(RENDERTMP)/lfs-full.xml

	$(Q)rm -rf $(DUMPDIR)

	$(Q)xsltproc --output $(DUMPDIR)/          \
                stylesheets/dump-commands.xsl \
                $(RENDERTMP)/lfs-html.xml
	@echo "Dumping book commands complete in $(DUMPDIR)"

dump-commandsd: validated
	@echo "Dumping book commands..."
	$(Q)xsltproc --nonet                      \
      --output $(RENDERTMP)/lfs-html.xml     \
      --stringparam profile.revision systemd \
      stylesheets/lfs-xsl/profile.xsl        \
      $(RENDERTMP)/lfs-full.xml

	$(Q)rm -rf $(DUMPDIR)
  
	$(Q)xsltproc --output $(DUMPDIR)/          \
                stylesheets/dump-commands.xsl \
                $(RENDERTMP)/lfs-html.xml
	@echo "Dumping book commands complete in $(DUMPDIR)"

all: lfs nochunks pdf dump-commands

.PHONY : all sysv systemd dump-commands lfs nochunks pdf profile-html tmpdir validate 

