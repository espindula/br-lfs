BASEDIR		:= ~/cross-lfs-book
DUMPDIR		:= ~/cross-lfs-commands
DLLISTDIR	:= ~/cross-lfs-dllist
RENDERTMP       := $(HOME)/tmp
CHUNK_QUIET	:= 1
ROOT_ID         :=

S		:= -

ARCHS		:= x86 x86_64 x86_64-64 sparc sparc64 sparc64-64 mips mips64 mips64-64 \
		   ppc ppc64 alpha native native64

ARCHS_HTML	:= $(ARCHS:%=%$(S)html)
ARCHS_NOCHUNKS	:= $(ARCHS:%=%$(S)nochunks)
ARCHS_PDF	:= $(ARCHS:%=%$(S)pdf)
ARCHS_VALIDATE	:= $(ARCHS:%=%$(S)validate)
ARCHS_TROUBLE	:= $(ARCHS:%=%$(S)trouble)
ARCHS_DUMP	:= $(ARCHS:%=%$(S)dump)
ARCHS_DLLIST	:= $(ARCHS:%=%$(S)dllist)

ifdef V
  Q =
else
  Q = @
endif

.PHONY: lfs tidy render titlepage $(ARCHS_HTML) nochunks $(ARCHS_NOCHUNKS) pdf \
	$(ARCHS_PDF) validate $(ARCHS_VALIDATE) trouble $(ARCHS_TROUBLE) \
	dump-commands $(ARCHS_DUMP) download-list $(ARCHS_DLLIST) tmpdir

lfs: tmpdir render tidy

tmpdir:
	@echo "Creating and cleaning $(RENDERTMP)"
	$(Q)[ -d $(RENDERTMP) ] || mkdir -p $(RENDERTMP)
	$(Q)rm -f $(RENDERTMP)/*-{full,html,pdf}.xml
	$(Q)rm -f $(RENDERTMP)/*.fo

ifeq ($(shell which tidy >/dev/null 2>&1 && echo yes),yes)
tidy:
	@echo "Running tidy on the created HTML"
	$(Q)for filename in `find $(BASEDIR) -name "*.html"`; do \
	  tidy -config $(PWD)/tidy.conf $$filename; \
	  true; \
	  sh $(PWD)/obfuscate.sh $$filename; \
	  sed -i -e "s@text/html@application/xhtml+xml@g" $$filename; \
	done;
else
tidy:
	@echo "Tidy is not installed on this system"
endif

render: $(ARCHS_HTML) titlepage

titlepage:
	$(Q)xsltproc --nonet --output $(BASEDIR)/index.html \
	  $(PWD)/stylesheets/top-index.xsl $(PWD)/index.xml

$(ARCHS_HTML): override html_arch = $(@:%$(S)html=%)
$(ARCHS_HTML):
	@echo "Validating $(html_arch) book..."
	$(Q)xmllint --nonet --noent --xinclude --postvalid \
	  -o $(RENDERTMP)/$(html_arch)-full.xml $(PWD)/$(html_arch)-index.xml

	@echo "Generating profiled $(html_arch) book for XHTML..."
	$(Q)xsltproc --nonet --stringparam profile.condition html \
	  --output $(RENDERTMP)/$(html_arch)-html.xml \
	  $(PWD)/stylesheets/lfs-xsl/profile.xsl $(RENDERTMP)/$(html_arch)-full.xml

	@echo "Rendering chunked XHTML of $(html_arch)..."
	$(Q)mkdir -p $(BASEDIR)/$(html_arch)
	$(Q)xsltproc --nonet -stringparam chunk.quietly $(CHUNK_QUIET) \
	  -stringparam rootid "$(ROOT_ID)" \
	  -stringparam base.dir $(BASEDIR)/$(html_arch)/ \
	  $(PWD)/stylesheets/clfs-chunked.xsl $(RENDERTMP)/$(html_arch)-html.xml

	@echo "Copying CSS code and images..."
	$(Q)mkdir -p $(BASEDIR)/$(html_arch)/stylesheets
	$(Q)cp $(PWD)/stylesheets/lfs-xsl/*.css $(BASEDIR)/$(html_arch)/stylesheets
	$(Q)sed -i -e "s@../stylesheets@stylesheets@g" $(BASEDIR)/$(html_arch)/*.html
	$(Q)mkdir -p $(BASEDIR)/$(html_arch)/images
	$(Q)cp $(PWD)/images/*.png $(BASEDIR)/$(html_arch)/images
	$(Q)sed -i -e "s@../images@images@g" $(BASEDIR)/$(html_arch)/*.html

nochunks: tmpdir $(ARCHS_NOCHUNKS) tidy

$(ARCHS_NOCHUNKS): override nochunk_arch = $(@:%$(S)nochunks=%)
$(ARCHS_NOCHUNKS):
	@echo "Validating $(nochunk_arch) book..."
	$(Q)xmllint --nonet --noent --xinclude --postvalid \
	  -o $(RENDERTMP)/$(nochunk_arch)-full.xml $(PWD)/$(nochunk_arch)-index.xml

	@echo "Generating profiled $(nochunk_arch) book for XHTML..."
	$(Q)xsltproc --nonet --stringparam profile.condition html \
	  --output $(RENDERTMP)/$(nochunk_arch)-html.xml \
	  $(PWD)/stylesheets/lfs-xsl/profile.xsl \
	  $(RENDERTMP)/$(nochunk_arch)-full.xml

	@echo "Rendering Single File HTML of $(nochunk_arch)..."
	$(Q)mkdir -p $(BASEDIR)
	$(Q)xsltproc --nonet -stringparam rootid "$(ROOT_ID)" \
	  --output $(BASEDIR)/CLFS-$(nochunk_arch).html \
	  $(PWD)/stylesheets/clfs-nochunks.xsl $(RENDERTMP)/$(nochunk_arch)-html.xml

	@echo "Running Tidy..."
	$(Q)tidy -config $(PWD)/tidy.conf $(BASEDIR)/CLFS-$(nochunk_arch).html || true
	@echo "Running obfuscate.sh..."
	$(Q)sh $(PWD)/obfuscate.sh $(BASEDIR)/CLFS-$(nochunk_arch).html
	$(Q)sed -i -e "s@text/html@application/xhtml+xml@g"  \
	  $(BASEDIR)/CLFS-$(nochunk_arch).html

pdf: tmpdir $(ARCHS_PDF)

$(ARCHS_PDF): override pdf_arch =  $(@:%$(S)pdf=%)
$(ARCHS_PDF):
	@echo "Validating $(pdf_arch) book..."
	$(Q)xmllint --nonet --noent --xinclude --postvalid \
	  -o $(RENDERTMP)/$(pdf_arch)-full.xml $(PWD)/$(pdf_arch)-index.xml

	@echo "Generating profiled $(pdf_arch) book for PDF..."
	$(Q)xsltproc --nonet --stringparam profile.condition pdf \
	  --output $(RENDERTMP)/$(pdf_arch)-pdf.xml \
	  $(PWD)/stylesheets/lfs-xsl/profile.xsl \
	  $(RENDERTMP)/$(pdf_arch)-full.xml

	@echo "Generating FO file of $(pdf_arch)..."
	$(Q)xsltproc --nonet -stringparam rootid "$(ROOT_ID)" \
	  --output $(RENDERTMP)/$(pdf_arch).fo $(PWD)/stylesheets/clfs-pdf.xsl \
	  $(RENDERTMP)/$(pdf_arch)-pdf.xml
	$(Q)sed -i -e 's/span="inherit"/span="all"/' $(RENDERTMP)/$(pdf_arch).fo

	@echo "Rendering PDF of $(pdf_arch)..."
	$(Q)mkdir -p $(BASEDIR)
	$(Q)fop $(RENDERTMP)/$(pdf_arch).fo $(BASEDIR)/CLFS-$(pdf_arch).pdf

validate: $(ARCHS_VALIDATE)

$(ARCHS_VALIDATE): override validate_arch =  $(@:%$(S)validate=%)
$(ARCHS_VALIDATE):
	@echo "Validating $(validate_arch)..."
	$(Q)xmllint --xinclude --noout --nonet --postvalid $(PWD)/$(validate_arch)-index.xml

trouble: tmpdir $(ARCHS_TROUBLE)

$(ARCHS_TROUBLE): override trouble_arch =  $(@:%$(S)trouble=%)
$(ARCHS_TROUBLE):
	@echo "Troubleshooting $(trouble_arch)..."
	$(Q)xmllint --xinclude --nonet --postvalid \
	  -o $(RENDERTMP)/dump-$(trouble_arch) $(PWD)/$(trouble_arch)-index.xml
	$(Q)xmllint --xinclude --noout --nonet --valid $(RENDERTMP)/dump-$(trouble_arch)
	@echo "You can now look at $(RENDERTMP)/dump-$(trouble_arch) to see the errors"

dump-commands: $(ARCHS_DUMP)

$(ARCHS_DUMP): override dump_arch =  $(@:%$(S)dump=%)
$(ARCHS_DUMP):
	@echo "Extracting commands from $(dump_arch)..."
	$(Q)mkdir -p $(DUMPDIR)/$(dump_arch)
	$(Q)xsltproc --xinclude --nonet --output $(DUMPDIR)/$(dump_arch)/ \
	  $(PWD)/stylesheets/dump-commands.xsl $(PWD)/$(dump_arch)-index.xml

download-list: $(ARCHS_DLLIST)

$(ARCHS_DLLIST): override dllist_arch = $(@:%$(S)dllist=%)
$(ARCHS_DLLIST):
	@echo "Creating download list for $(dllist_arch)..."
	$(Q)mkdir -p $(DLLISTDIR)
	$(Q)xsltproc --xinclude --nonet --output $(DLLISTDIR)/$(dllist_arch).dl.list \
	  $(PWD)/stylesheets/wget.xsl $(PWD)/$(dllist_arch)-index.xml

help:
	@echo "HTML Targets"
	@echo -e "  \e[0;32mlfs tidy render titlepage \e[0;34m$(ARCHS_HTML)\e[0;0m"
	@echo
	@echo "NoChunks Targets"
	@echo -e "  \e[0;32mnochunks tidy \e[0;34m$(ARCHS_NOCHUNKS)\e[0;0m"
	@echo
	@echo "PDF Targets"
	@echo -e "  \e[0;32mpdf \e[0;34m$(ARCHS_PDF)\e[0;0m"
	@echo
	@echo "Validate Targets"
	@echo -e "  \e[0;32mvalidate \e[0;34m$(ARCHS_VALIDATE)\e[0;0m"
	@echo
	@echo "Trouble Targets"
	@echo -e "  \e[0;32mtrouble \e[0;34m$(ARCHS_TROUBLE)\e[0;0m"
	@echo
	@echo "Dump-Commands Targets"
	@echo -e "  \e[0;32mdump-commands \e[0;34m$(ARCHS_DUMP)\e[0;0m"
	@echo
	@echo "Download-List Targets"
	@echo -e "  \e[0;32mdownload-list \e[0;34m$(ARCHS_DLLIST)\e[0;0m"
