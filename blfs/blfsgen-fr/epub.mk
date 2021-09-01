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
	$(Q)mkdir -p $(RENDERTMP)/blfs-epub/
	$(Q)xsltproc --nonet --output $(RENDERTMP)/blfs-epub/ /usr/share/xml/docbook/stylesheet/docbook-xsl/epub/docbook.xsl \
		$(if $(ISSYSD), $(RENDERTMP)/blfs-systemd-full.xml,$(RENDERTMP)/blfs-systemd-full.xml)
	@echo "Generating EPUB file..."
	echo "application/epub+zip" > $(RENDERTMP)/mimetype
	cwd=$$(pwd) ;\
	cd $(RENDERTMP)/; zip -0Xq $$cwd/../$(EPUB_OUTPUT) ./mimetype
	cwd=$$(pwd) ;\
	cd $(RENDERTMP)/lfs-epub/; zip -Xr9Dq $$cwd/../$(EPUB_OUTPUT) ./*
