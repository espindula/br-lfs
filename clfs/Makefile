TOP		:= $(shell pwd)
RENDERDIR	:= $(TOP)/../render

VALIDATEDIR	:= $(RENDERDIR)/validate
PROFILEDIR	:= $(RENDERDIR)/profile

HTMLDIR		:= $(RENDERDIR)/html
NOCHUNKDIR	:= $(RENDERDIR)/nochunk

FODIR		:= $(RENDERDIR)/fo
PDFDIR		:= $(RENDERDIR)/pdf

TROUBLEDIR	:= $(RENDERDIR)/trouble
DUMPDIR		:= $(RENDERDIR)/commands
DLLISTDIR	:= $(RENDERDIR)/download-list

CHUNK_QUIET	:= 1
ROOT_ID		:=

ARCHS		:= x86 x86_64 x86_64-64 \
		   sparc sparc64 sparc64-64 \
		   mips mips64 mips64-64 \
		   ppc ppc64 ppc64-64

ifdef V
  Q =
else
  Q = @
endif

.PHONY: clfs lfs
clfs lfs: html

.PHONY: tidy tidy-f tidy-d
ifeq ($(shell which tidy >/dev/null 2>&1 && echo yes),yes)
tidy:
	@$(MAKE) --no-print-directory tidy-d TIDY_DIR=$(HTMLDIR)

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
	$(Q)xsltproc --nonet --output $(HTMLDIR)/index.html \
	  $(TOP)/stylesheets/top-index.xsl \
	  $(TOP)/index.xml
	@$(MAKE) --no-print-directory tidy-f TIDY_FILE=$(HTMLDIR)/index.html

ARCHS_VD_XML := $(ARCHS:%=%-validate_dump-xml)
.PHONY: $(ARCHS_VD_XML)
$(ARCHS_VD_XML): override arch = $(@:%-validate_dump-xml=%)
$(ARCHS_VD_XML):
	@echo "Validating $(arch) book..."
	$(Q)mkdir -p $(VALIDATEDIR)
	$(Q)xmllint --nonet --noent --xinclude \
	  --relaxng $(TOP)/schema/docbook/4.5/rng/docbook.rng \
	  -o $(VALIDATEDIR)/$(arch)-full.xml \
	  $(TOP)/$(arch)-index.xml

ARCHS_P_XML := $(ARCHS:%=%-profiled-xml)
.PHONY: $(ARCHS_P_XML)
$(ARCHS_P_XML): override arch = $(@:%-profiled-xml=%)
$(ARCHS_P_XML):
	@$(MAKE) --no-print-directory $(arch)-validate_dump-xml
	@echo "Generating profiled $(arch) book..."
	$(Q)mkdir -p $(PROFILEDIR)
	$(Q)xsltproc --nonet --stringparam profile.condition html \
	  --output $(PROFILEDIR)/$(arch)-html.xml \
	  $(TOP)/stylesheets/lfs-xsl/profile.xsl \
	  $(VALIDATEDIR)/$(arch)-full.xml

ARCHS_HTML := $(ARCHS:%=%-html)
.PHONY: html render $(ARCHS_HTML)
html render: $(ARCHS_HTML) titlepage
$(ARCHS_HTML): override arch = $(@:%-html=%)
$(ARCHS_HTML):
	@$(MAKE) --no-print-directory $(arch)-profiled-xml

	@echo "Rendering chunked XHTML of $(arch)..."
	$(Q)mkdir -p $(HTMLDIR)/$(arch)
	$(Q)xsltproc --nonet -stringparam chunk.quietly $(CHUNK_QUIET) \
	  -stringparam rootid "$(ROOT_ID)" \
	  -stringparam base.dir $(HTMLDIR)/$(arch)/ \
	  $(TOP)/stylesheets/clfs-chunked.xsl \
	  $(PROFILEDIR)/$(arch)-html.xml

	@echo "Copying CSS code and images for $(arch)..."
	$(Q)mkdir -p $(HTMLDIR)/$(arch)/stylesheets
	$(Q)cp $(TOP)/stylesheets/lfs-xsl/*.css $(HTMLDIR)/$(arch)/stylesheets
	$(Q)sed -i -e "s@../stylesheets@stylesheets@g" $(HTMLDIR)/$(arch)/*.html
	$(Q)mkdir -p $(HTMLDIR)/$(arch)/images
	$(Q)cp $(TOP)/images/*.png $(HTMLDIR)/$(arch)/images
	$(Q)sed -i -e "s@../images@images@g" $(HTMLDIR)/$(arch)/*.html

	@$(MAKE) --no-print-directory tidy-d TIDY_DIR=$(HTMLDIR)/$(arch)

ARCHS_NOCHUNKS := $(ARCHS:%=%-nochunks)
.PHONY: nochunks $(ARCHS_NOCHUNKS)
nochunks: $(ARCHS_NOCHUNKS)
$(ARCHS_NOCHUNKS): override arch = $(@:%-nochunks=%)
$(ARCHS_NOCHUNKS):
	@$(MAKE) --no-print-directory $(arch)-profiled-xml

	@echo "Rendering Single File HTML of $(arch)..."
	$(Q)mkdir -p $(NOCHUNKDIR)
	$(Q)xsltproc --nonet -stringparam rootid "$(ROOT_ID)" \
	  --output $(NOCHUNKDIR)/CLFS-$(arch).html \
	  $(TOP)/stylesheets/clfs-nochunks.xsl \
	  $(PROFILEDIR)/$(arch)-html.xml

	@$(MAKE) --no-print-directory tidy-f TIDY_FILE=$(NOCHUNKDIR)/CLFS-$(arch).html

ARCHS_FO := $(ARCHS:%=%-fo)
.PHONY: fo $(ARCHS_FO)
fo: $(ARCHS_FO)
$(ARCHS_FO): override arch = $(@:%-fo=%)
$(ARCHS_FO):
	@$(MAKE) --no-print-directory $(arch)-profiled-xml

	@echo "Generating FO file of $(arch)..."
	@mkdir -p $(FODIR)
	$(Q)xsltproc --nonet -stringparam rootid "$(ROOT_ID)" \
	  --output $(FODIR)/$(arch).fo \
	  $(TOP)/stylesheets/clfs-pdf.xsl \
	  $(PROFILEDIR)/$(arch)-html.xml
	$(Q)sed -i -e 's/span="inherit"/span="all"/' $(FODIR)/$(arch).fo

ARCHS_PDF := $(ARCHS:%=%-pdf)
.PHONY: pdf $(ARCHS_PDF)
pdf: $(ARCHS_PDF)
$(ARCHS_PDF): override arch = $(@:%-pdf=%)
$(ARCHS_PDF):
	@$(MAKE) --no-print-directory $(arch)-fo

	@echo "Rendering PDF of $(arch)..."
	$(Q)mkdir -p $(PDFDIR)
	$(Q)fop $(FODIR)/$(arch).fo $(PDFDIR)/CLFS-$(arch).pdf

ARCHS_VALIDATE := $(ARCHS:%=%-validate)
.PHONY: validate $(ARCHS_VALIDATE)
validate: $(ARCHS_VALIDATE)
$(ARCHS_VALIDATE): override arch =  $(@:%-validate=%)
$(ARCHS_VALIDATE):
	@echo "Validating $(arch)..."
	$(Q)xmllint --xinclude --noout --nonet \
	  --relaxng $(TOP)/schema/docbook/4.5/rng/docbook.rng \
	  $(TOP)/$(arch)-index.xml

ARCHS_TROUBLE := $(ARCHS:%=%-trouble)
.PHONY: trouble $(ARCHS_TROUBLE)
trouble: $(ARCHS_TROUBLE)
$(ARCHS_TROUBLE): override arch = $(@:%-trouble=%)
$(ARCHS_TROUBLE):
	@echo "Troubleshooting $(arch)..."
	@mkdir -p $(TROUBLEDIR)
	$(Q)xmllint --xinclude --nonet \
	  --relaxng $(TOP)/schema/docbook/4.5/rng/docbook.rng \
	  -o $(TROUBLEDIR)/dump-$(arch) \
	  $(TOP)/$(arch)-index.xml
	$(Q)xmllint --xinclude --noout --nonet \
	  --relaxng $(TOP)/schema/docbook/4.5/rng/docbook.rng \
	  $(TROUBLEDIR)/dump-$(arch)
	@echo "You can now look at $(TROUBLEDIR)/dump-$(arch) to see the errors"

ARCHS_DUMP := $(ARCHS:%=%-dump)
.PHONY: dump-commands $(ARCHS_DUMP)
dump-commands: $(ARCHS_DUMP)
$(ARCHS_DUMP): override arch = $(@:%-dump=%)
$(ARCHS_DUMP):
	@echo "Extracting commands from $(arch)..."
	$(Q)mkdir -p $(DUMPDIR)/$(arch)
	$(Q)xsltproc --xinclude --nonet \
	  --output $(DUMPDIR)/$(arch)/ \
	  $(TOP)/stylesheets/dump-commands.xsl \
	  $(TOP)/$(arch)-index.xml

ARCHS_DLLIST := $(ARCHS:%=%-dllist)
.PHONY: download-list $(ARCHS_DLLIST)
download-list: $(ARCHS_DLLIST)
$(ARCHS_DLLIST): override arch = $(@:%-dllist=%)
$(ARCHS_DLLIST):
	@echo "Creating download list for $(arch)..."
	$(Q)mkdir -p $(DLLISTDIR)
	$(Q)xsltproc --xinclude --nonet \
	  --output $(DLLISTDIR)/$(arch).list \
	  $(TOP)/stylesheets/wget.xsl \
	  $(TOP)/$(arch)-index.xml

ARCHS_MD5LIST := $(ARCHS:%=%-md5list)
.PHONY: md5-list $(ARCHS_MD5LIST)
md5-list: $(ARCHS_MD5LIST)
$(ARCHS_MD5LIST): override arch = $(@:%-md5list=%)
$(ARCHS_MD5LIST):
	@echo "Creating md5 hash list for $(arch)..."
	$(Q)mkdir -p $(DLLISTDIR)
	$(Q)xsltproc --xinclude --nonet \
	  --output $(DLLISTDIR)/$(arch).md5sum \
	  $(TOP)/stylesheets/md5sum.xsl \
	  $(TOP)/$(arch)-index.xml
       
FG_GREEN := $(shell echo -e '\e[0;32m')
FG_BLUE := $(shell echo -e '\e[0;34m')
FG_DEFAULT := $(shell echo -e '\e[0;0m')
help:
	@echo "Output: $(RENDERDIR)"
	@echo
	@echo "HTML Targets"
	@echo "  $(FG_GREEN)clfs lfs tidy html render titlepage $(FG_BLUE)$(ARCHS_HTML)$(FG_DEFAULT)"
	@echo
	@echo "NoChunks Targets"
	@echo "  $(FG_GREEN)nochunks tidy $(FG_BLUE)$(ARCHS_NOCHUNKS)$(FG_DEFAULT)"
	@echo
	@echo "FO Targets"
	@echo "  $(FG_GREEN)fo $(FG_BLUE)$(ARCHS_FO)$(FG_DEFAULT)"
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
	@echo
	@echo "md5-List Targets"
	@echo "  $(FG_GREEN)md5-list $(FG_BLUE)$(ARCHS_MD5LIST)$(FG_DEFAULT)"
