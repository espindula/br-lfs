TOP		:= $(PWD)

WORKDIR		:= $(TOP)/render-output

BASEDIR		:= $(WORKDIR)/cross-lfs-book
DUMPDIR		:= $(WORKDIR)/cross-lfs-commands
DLLISTDIR	:= $(WORKDIR)/cross-lfs-dllist
RENDERTMP       := $(WORKDIR)/tmp
CHUNK_QUIET	:= 1
ROOT_ID	 :=

S		:= -

ARCHS		:= x86 x86_64 x86_64-64 sparc sparc64 sparc64-64 mips mips64 mips64-64 \
		   ppc ppc64 alpha

ARCHS_VD_XML	:= $(ARCHS:%=%-validate_dump-xml)
ARCHS_P_XML	:= $(ARCHS:%=%-profiled-xml)

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

.PHONY: clfs lfs tidy render titlepage nochunks pdf validate trouble dump-commands \
	download-list tmpdir $(ARCHS_HTML) $(ARCHS_NOCHUNKS) $(ARCHS_PDF) \
	$(ARCHS_VALIDATE) $(ARCHS_TROUBLE) $(ARCHS_DUMP) $(ARCHS_DLLIST) tmpdir

clfs lfs: tmpdir render
render: $(ARCHS_HTML) titlepage
nochunks: tmpdir $(ARCHS_NOCHUNKS)
pdf: tmpdir $(ARCHS_PDF)
validate: $(ARCHS_VALIDATE)
trouble: tmpdir $(ARCHS_TROUBLE)
dump-commands: $(ARCHS_DUMP)
download-list: $(ARCHS_DLLIST)

tmpdir:
	$(Q)[ -d $(RENDERTMP) ] || mkdir -p $(RENDERTMP)

ifeq ($(shell which tidy >/dev/null 2>&1 && echo yes),yes)
tidy:
	@$(MAKE) --no-print-directory tidy-d TIDY_DIR=$(BASEDIR)

tidy-f:
	@echo "Running tidy on F:$(shell basename $(TIDY_FILE))"
	@$(TOP)/tidy.sh "$(TIDY_FILE)"

tidy-d:
	@echo "Running tidy on D:$(shell basename $(TIDY_DIR))"
	@$(TOP)/tidy.sh "$(TIDY_DIR)"
else
tidy tidy-f tidy-d:
	@echo "Tidy is not installed on this system"
endif

titlepage:
	@echo "Rendering the top-level index..."
	$(Q)xsltproc --nonet --output $(BASEDIR)/index.html \
	  $(PWD)/stylesheets/top-index.xsl $(PWD)/index.xml
	@$(MAKE) --no-print-directory tidy-f TIDY_FILE=$(BASEDIR)/index.html

$(ARCHS_VD_XML): override validate_dump_xml_arch = $(@:%-validate_dump-xml=%)
$(ARCHS_VD_XML): tmpdir
	@echo "Validating $(validate_dump_xml_arch) book..."
	$(Q)xmllint --nonet --noent --xinclude --postvalid \
	  -o $(RENDERTMP)/$(validate_dump_xml_arch)-full.xml $(PWD)/$(validate_dump_xml_arch)-index.xml

$(ARCHS_P_XML): override profiled_xml_arch = $(@:%-profiled-xml=%)
$(ARCHS_P_XML): tmpdir
	@$(MAKE) --no-print-directory $(profiled_xml_arch)-validate_dump-xml

	@echo "Generating profiled $(profiled_xml_arch) book for XHTML..."
	$(Q)xsltproc --nonet --stringparam profile.condition html \
	  --output $(RENDERTMP)/$(profiled_xml_arch)-html.xml \
	  $(PWD)/stylesheets/lfs-xsl/profile.xsl $(RENDERTMP)/$(profiled_xml_arch)-full.xml

$(ARCHS_HTML): override html_arch = $(@:%$(S)html=%)
$(ARCHS_HTML): tmpdir
	@$(MAKE) --no-print-directory $(html_arch)-profiled-xml

	@echo "Rendering chunked XHTML of $(html_arch)..."
	$(Q)mkdir -p $(BASEDIR)/$(html_arch)
	$(Q)xsltproc --nonet -stringparam chunk.quietly $(CHUNK_QUIET) \
	  -stringparam paper.type A4 \
	  -stringparam rootid "$(ROOT_ID)" \
	  -stringparam base.dir $(BASEDIR)/$(html_arch)/ \
	  $(PWD)/stylesheets/clfs-chunked.xsl $(RENDERTMP)/$(html_arch)-html.xml

	@echo "Copying CSS code and images for $(html_arch)..."
	$(Q)mkdir -p $(BASEDIR)/$(html_arch)/stylesheets
	$(Q)cp $(PWD)/stylesheets/lfs-xsl/*.css $(BASEDIR)/$(html_arch)/stylesheets
	$(Q)sed -i -e "s@../stylesheets@stylesheets@g" $(BASEDIR)/$(html_arch)/*.html
	$(Q)mkdir -p $(BASEDIR)/$(html_arch)/images
	$(Q)cp $(PWD)/images/*.png $(BASEDIR)/$(html_arch)/images
	$(Q)sed -i -e "s@../images@images@g" $(BASEDIR)/$(html_arch)/*.html

	@$(MAKE) --no-print-directory tidy-d TIDY_DIR=$(BASEDIR)/$(html_arch)

$(ARCHS_NOCHUNKS): override nochunk_arch = $(@:%$(S)nochunks=%)
$(ARCHS_NOCHUNKS): tmpdir
	@$(MAKE) --no-print-directory $(nochunk_arch)-profiled-xml

	@echo "Rendering Single File HTML of $(nochunk_arch)..."
	$(Q)mkdir -p $(BASEDIR)
	$(Q)xsltproc --nonet -stringparam rootid "$(ROOT_ID)" \
		-stringparam paper.type A4 \
	  --output $(BASEDIR)/CLFS-$(nochunk_arch).html \
	  $(PWD)/stylesheets/clfs-nochunks.xsl $(RENDERTMP)/$(nochunk_arch)-html.xml

	@$(MAKE) --no-print-directory tidy-f TIDY_FILE=$(BASEDIR)/CLFS-$(nochunk_arch).html

$(ARCHS_PDF): override pdf_arch =  $(@:%$(S)pdf=%)
$(ARCHS_PDF): tmpdir
	@$(MAKE) --no-print-directory $(pdf_arch)-profiled-xml

	@echo "Generating FO file of $(pdf_arch)..."
	$(Q)xsltproc --nonet -stringparam rootid "$(ROOT_ID)" \
	  --output $(RENDERTMP)/$(pdf_arch).fo $(PWD)/stylesheets/clfs-pdf.xsl \
	  $(RENDERTMP)/$(pdf_arch)-pdf.xml
	$(Q)sed -i -e 's/span="inherit"/span="all"/' $(RENDERTMP)/$(pdf_arch).fo

	@echo "Rendering PDF of $(pdf_arch)..."
	$(Q)mkdir -p $(BASEDIR)
	$(Q)fop $(RENDERTMP)/$(pdf_arch).fo $(BASEDIR)/CLFS-$(pdf_arch).pdf

$(ARCHS_VALIDATE): override validate_arch =  $(@:%$(S)validate=%)
$(ARCHS_VALIDATE):
	@echo "Validating $(validate_arch)..."
	$(Q)xmllint --xinclude --noout --nonet --postvalid $(PWD)/$(validate_arch)-index.xml

$(ARCHS_TROUBLE): override trouble_arch =  $(@:%$(S)trouble=%)
$(ARCHS_TROUBLE): tmpdir
	@echo "Troubleshooting $(trouble_arch)..."
	$(Q)xmllint --xinclude --nonet --postvalid \
	  -o $(RENDERTMP)/dump-$(trouble_arch) $(PWD)/$(trouble_arch)-index.xml
	$(Q)xmllint --xinclude --noout --nonet --valid $(RENDERTMP)/dump-$(trouble_arch)
	@echo "You can now look at $(RENDERTMP)/dump-$(trouble_arch) to see the errors"

$(ARCHS_DUMP): override dump_arch =  $(@:%$(S)dump=%)
$(ARCHS_DUMP):
	@echo "Extracting commands from $(dump_arch)..."
	$(Q)mkdir -p $(DUMPDIR)/$(dump_arch)
	$(Q)xsltproc --xinclude --nonet --output $(DUMPDIR)/$(dump_arch)/ \
	  $(PWD)/stylesheets/dump-commands.xsl $(PWD)/$(dump_arch)-index.xml

$(ARCHS_DLLIST): override dllist_arch = $(@:%$(S)dllist=%)
$(ARCHS_DLLIST):
	@echo "Creating download list for $(dllist_arch)..."
	$(Q)mkdir -p $(DLLISTDIR)
	$(Q)xsltproc --xinclude --nonet --output $(DLLISTDIR)/$(dllist_arch)/dl.list \
	  $(PWD)/stylesheets/wget.xsl $(PWD)/$(dllist_arch)-index.xml

help:
	@echo "Output: $(WORKDIR)"
	@echo
	@echo "HTML Targets"
	@echo -e "  \e[0;32mclfs lfs tidy render titlepage \e[0;34m$(ARCHS_HTML)\e[0;0m"
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
