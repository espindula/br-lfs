pdf: validate
	@echo "Generating profiled XML for PDF..."
	$(Q)xsltproc --nonet \
                --stringparam profile.condition pdf \
                --output $(RENDERTMP)/blfs-pdf.xml   \
                stylesheets/lfs-xsl/profile.xsl     \
                $(RENDERTMP)/blfs-html2.xml
	@echo "Generating FO file..."
	$(Q)xsltproc --nonet                           \
                 --stringparam rootid "$(ROOT_ID)" \
                 --output $(RENDERTMP)/blfs-pdf.fo  \
                 stylesheets/blfs-pdf.xsl           \
                 $(RENDERTMP)/blfs-pdf.xml
	$(Q)sed -i -e 's/span="inherit"/span="all"/' $(RENDERTMP)/blfs-pdf.fo
	$(Q)cp -r images/ $(RENDERTMP)/
	@echo "Generating PDF file..."
	$(Q)fop -q  $(RENDERTMP)/blfs-pdf.fo $(BASEDIR)/$(PDF_OUTPUT) 2>fop.log
	@echo "$(BASEDIR)/$(PDF_OUTPUT) created"
	@echo "fop.log created"

# Not included: before Genration PDF file...
#$(Q)bash pdf-fixups.sh $(RENDERTMP)/blfs-pdf.fo
