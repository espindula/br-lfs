epub: validate
	@echo "Generating HTML/XML for EPUB..."
	$(Q)if [ ! -e $(BASEDIR) ]; then \
	        mkdir -p $(BASEDIR); \
	fi;
	$(Q)mkdir -p $(RENDERTMP)/blfs-epub/
	$(Q)xsltproc --nonet --output $(RENDERTMP)/blfs-epub/ DOCBOOK_LOCATION/epub/docbook.xsl $(RENDERTMP)/lfs-full.xml
	@echo "Generating EPUB file..."
	echo "application/epub+zip" > $(RENDERTMP)/mimetype
	cwd=$$(pwd) ;\
	cd $(RENDERTMP)/; zip -0Xq $$cwd/../$(EPUB_OUTPUT) ./mimetype
	cwd=$$(pwd) ;\
	cd $(RENDERTMP)/lfs-epub/; zip -Xr9Dq $$cwd/../$(EPUB_OUTPUT) ./*
