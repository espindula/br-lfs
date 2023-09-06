ifeq ($(REV), systemd)
ISSYSD=true
else
ISSYSD=
endif

epub: validate
	@echo "Generating HTML/XML for EPUB..."
	$(Q)if [ ! -e $(BASEDIR) ]; then \
	        mkdir -p $(BASEDIR); \
	fi;
	$(Q)mkdir -p $(RENDERTMP)/lfs-epub-$(REV)/
	$(Q)xsltproc --nonet --output $(RENDERTMP)/lfs-epub-$(REV)/ stylesheets/lfs-xsl/docbook-xsl-1.78.1/epub/docbook.xsl \
		$(RENDERTMP)/lfs-full.xml
		#$(if $(ISSYSD), $(RENDERTMP)/lfs-systemd-full.xml,$(RENDERTMP)/lfs-full.xml)
	@echo "Generating EPUB file..."
	echo "application/epub+zip" > $(RENDERTMP)/mimetype
	cwd=$$(pwd) ;\
	cd $(RENDERTMP)/; zip -0Xq $$cwd/../$(EPUB_OUTPUT) ./mimetype
	cwd=$$(pwd) ;\
	cd $(RENDERTMP)/lfs-epub-$(REV)/; zip -Xr9Dq $$cwd/../$(EPUB_OUTPUT) ./*
