epub: validate
	@echo "Generating HTML/XML for EPUB..."
	$(Q)if [ ! -e $(BASEDIR) ]; then \
	        mkdir -p $(BASEDIR); \
	fi;
	$(Q)mkdir -p $(RENDERTMP)/lfs-epub/
	$(Q)xsltproc --nonet --output $(RENDERTMP)/lfs-epub/ stylesheets/lfs-xsl/docbook-xsl-1.78.1/epub/docbook.xsl $(RENDERTMP)/lfs-full.xml
	@echo "Generating EPUB file..."
	echo "application/epub+zip" > $(RENDERTMP)/mimetype
	cwd=$$(pwd) ;\
	cd $(RENDERTMP)/; zip -0Xq $$cwd/$(BASEDIR)/$(EPUB_OUTPUT) ./mimetype
	cwd=$$(pwd) ;\
	cd $(RENDERTMP)/lfs-epub/; zip -Xr9Dq $$cwd/$(BASEDIR)/$(EPUB_OUTPUT) ./*
