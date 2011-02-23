TOP		:= $(PWD)

WORKDIR		:= $(TOP)/render-output

BASEDIR		:= $(WORKDIR)/cross-lfs-book
DUMPDIR		:= $(WORKDIR)/cross-lfs-commands
DLLISTDIR	:= $(WORKDIR)/cross-lfs-dllist
RENDERTMP       := $(WORKDIR)/tmp
CHUNK_QUIET	:= 1
ROOT_ID	 :=

FG_GREEN	:= $(shell echo -e '\e[0;32m')
FG_BLUE		:= $(shell echo -e '\e[0;34m')
FG_DEFAULT	:= $(shell echo -e '\e[0;0m')

ARCHS		:= x86 x86_64 x86_64-64 \
		   sparc sparc64 sparc64-64 \
		   mips mips64 mips64-64 \
		   ppc ppc64 \
		   alpha

ARCHS_VD_XML	:= $(ARCHS:%=%-validate_dump-xml)
ARCHS_P_XML	:= $(ARCHS:%=%-profiled-xml)

ARCHS_HTML	:= $(ARCHS:%=%-html)
ARCHS_NOCHUNKS	:= $(ARCHS:%=%-nochunks)
ARCHS_PDF	:= $(ARCHS:%=%-pdf)
ARCHS_VALIDATE	:= $(ARCHS:%=%-validate)
ARCHS_TROUBLE	:= $(ARCHS:%=%-trouble)
ARCHS_DUMP	:= $(ARCHS:%=%-dump)
ARCHS_DLLIST	:= $(ARCHS:%=%-dllist)

ifdef V
  Q =
else
  Q = @
endif

.PHONY: clfs lfs render nochunks pdf validate trouble dump-commands download-list
clfs lfs: tmpdir render
render: $(ARCHS_HTML) titlepage
nochunks: tmpdir $(ARCHS_NOCHUNKS)
pdf: tmpdir $(ARCHS_PDF)
validate: $(ARCHS_VALIDATE)
trouble: tmpdir $(ARCHS_TROUBLE)
dump-commands: $(ARCHS_DUMP)
download-list: $(ARCHS_DLLIST)

.PHONY: tmpdir
tmpdir:
	$(Q)mkdir -p $(RENDERTMP)

.PHONY: tidy tidy-f tidy-d
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

.PHONY: titlepage
titlepage:
	@echo "Rendering the top-level index..."
	$(Q)xsltproc --nonet --output $(BASEDIR)/index.html \
	  $(PWD)/stylesheets/top-index.xsl $(PWD)/index.xml
	@$(MAKE) --no-print-directory tidy-f TIDY_FILE=$(BASEDIR)/index.html


.PHONY: $(ARCHS_VD_XML)
$(ARCHS_VD_XML): override arch = $(@:%-validate_dump-xml=%)
$(ARCHS_VD_XML): tmpdir
	@echo "Validating $(arch) book..."
	$(Q)xmllint --nonet --noent --xinclude --postvalid \
	  -o $(RENDERTMP)/$(arch)-full.xml $(PWD)/$(arch)-index.xml

.PHONY: $(ARCHS_P_XML)
$(ARCHS_P_XML): override arch = $(@:%-profiled-xml=%)
$(ARCHS_P_XML): tmpdir
	@$(MAKE) --no-print-directory $(arch)-validate_dump-xml

	@echo "Generating profiled $(arch) book for XHTML..."
	$(Q)xsltproc --nonet --stringparam profile.condition html \
	  --output $(RENDERTMP)/$(arch)-html.xml \
	  $(PWD)/stylesheets/lfs-xsl/profile.xsl $(RENDERTMP)/$(arch)-full.xml

.PHONY: $(ARCHS_HTML)
$(ARCHS_HTML): override arch = $(@:%-html=%)
$(ARCHS_HTML): tmpdir
	@$(MAKE) --no-print-directory $(arch)-profiled-xml

	@echo "Rendering chunked XHTML of $(arch)..."
	$(Q)mkdir -p $(BASEDIR)/$(arch)
	$(Q)xsltproc --nonet -stringparam chunk.quietly $(CHUNK_QUIET) \
	  -stringparam rootid "$(ROOT_ID)" \
	  -stringparam base.dir $(BASEDIR)/$(arch)/ \
	  $(PWD)/stylesheets/clfs-chunked.xsl $(RENDERTMP)/$(arch)-html.xml

	@echo "Copying CSS code and images for $(arch)..."
	$(Q)mkdir -p $(BASEDIR)/$(arch)/stylesheets
	$(Q)cp $(PWD)/stylesheets/lfs-xsl/*.css $(BASEDIR)/$(arch)/stylesheets
	$(Q)sed -i -e "s@../stylesheets@stylesheets@g" $(BASEDIR)/$(arch)/*.html
	$(Q)mkdir -p $(BASEDIR)/$(arch)/images
	$(Q)cp $(PWD)/images/*.png $(BASEDIR)/$(arch)/images
	$(Q)sed -i -e "s@../images@images@g" $(BASEDIR)/$(arch)/*.html

	@$(MAKE) --no-print-directory tidy-d TIDY_DIR=$(BASEDIR)/$(arch)

.PHONY: $(ARCHS_NOCHUNKS)
$(ARCHS_NOCHUNKS): override arch = $(@:%-nochunks=%)
$(ARCHS_NOCHUNKS): tmpdir
	@$(MAKE) --no-print-directory $(arch)-profiled-xml

	@echo "Rendering Single File HTML of $(arch)..."
	$(Q)mkdir -p $(BASEDIR)
	$(Q)xsltproc --nonet -stringparam rootid "$(ROOT_ID)" \
	  --output $(BASEDIR)/CLFS-$(arch).html \
	  $(PWD)/stylesheets/clfs-nochunks.xsl $(RENDERTMP)/$(arch)-html.xml

	@$(MAKE) --no-print-directory tidy-f TIDY_FILE=$(BASEDIR)/CLFS-$(arch).html

.PHONY: $(ARCHS_PDF)
$(ARCHS_PDF): override arch =  $(@:%-pdf=%)
$(ARCHS_PDF): tmpdir
	@$(MAKE) --no-print-directory $(arch)-profiled-xml

	@echo "Generating FO file of $(arch)..."
	$(Q)xsltproc --nonet -stringparam rootid "$(ROOT_ID)" \
	  --output $(RENDERTMP)/$(arch).fo $(PWD)/stylesheets/clfs-pdf.xsl \
	  $(RENDERTMP)/$(arch)-html.xml
	$(Q)sed -i -e 's/span="inherit"/span="all"/' $(RENDERTMP)/$(arch).fo

	@echo "Rendering PDF of $(arch)..."
	$(Q)mkdir -p $(BASEDIR)
	$(Q)fop $(RENDERTMP)/$(arch).fo $(BASEDIR)/CLFS-$(arch).pdf

.PHONY: $(ARCHS_VALIDATE)
$(ARCHS_VALIDATE): override arch =  $(@:%-validate=%)
$(ARCHS_VALIDATE):
	@echo "Validating $(arch)..."
	$(Q)xmllint --xinclude --noout --nonet --postvalid $(PWD)/$(arch)-index.xml

.PHONY: $(ARCHS_TROUBLE)
$(ARCHS_TROUBLE): override trouble_arch =  $(@:%-trouble=%)
$(ARCHS_TROUBLE): tmpdir
	@echo "Troubleshooting $(trouble_arch)..."
	$(Q)xmllint --xinclude --nonet --postvalid \
	  -o $(RENDERTMP)/dump-$(arch) $(PWD)/$(arch)-index.xml
	$(Q)xmllint --xinclude --noout --nonet --valid $(RENDERTMP)/dump-$(arch)
	@echo "You can now look at $(RENDERTMP)/dump-$(arch) to see the errors"

.PHONY: $(ARCHS_DUMP)
$(ARCHS_DUMP): override arch =  $(@:%-dump=%)
$(ARCHS_DUMP):
	@echo "Extracting commands from $(arch)..."
	$(Q)mkdir -p $(DUMPDIR)/$(arch)
	$(Q)xsltproc --xinclude --nonet --output $(DUMPDIR)/$(arch)/ \
	  $(PWD)/stylesheets/dump-commands.xsl $(PWD)/$(arch)-index.xml

.PHONY: $(ARCHS_DLLIST)
$(ARCHS_DLLIST): override arch = $(@:%-dllist=%)
$(ARCHS_DLLIST):
	@echo "Creating download list for $(arch)..."
	$(Q)mkdir -p $(DLLISTDIR)
	$(Q)xsltproc --xinclude --nonet --output $(DLLISTDIR)/$(arch)/dl.list \
	  $(PWD)/stylesheets/wget.xsl $(PWD)/$(arch)-index.xml

help:
	@echo "Output: $(WORKDIR)"
	@echo
	@echo "HTML Targets"
	@echo "  $(FG_GREEN)clfs lfs tidy render titlepage $(FG_BLUE)$(ARCHS_HTML)$(FG_DEFAULT)"
	@echo
	@echo "NoChunks Targets"
	@echo "  $(FG_GREEN)nochunks tidy $(FG_BLUE)$(ARCHS_NOCHUNKS)$(FG_DEFAULT)"
	@echo
	@echo "PDF Targets"
	@echo "  $(FG_GREEN)pdf $(FG_BLUE)$(ARCHS_PDF)$(FG_DEFAULT)"
	@echo
	@echo "Validate Targets"
	@echo "  $(FG_GREEN)validate $(FG_BLUE)$(ARCHS_VALIDATE)$(FG_DEFAULT)"
	@echo
	@echo "Trouble Targets"
	@echo "  $(FG_GREEN)trouble $(FG_BLUE)$(ARCHS_TROUBLE)$(FG_DEFAULT)"
	@echo
	@echo "Dump-Commands Targets"
	@echo "  $(FG_GREEN)dump-commands $(FG_BLUE)$(ARCHS_DUMP)$(FG_DEFAULT)"
	@echo
	@echo "Download-List Targets"
	@echo "  $(FG_GREEN)download-list $(FG_BLUE)$(ARCHS_DLLIST)$(FG_DEFAULT)"
