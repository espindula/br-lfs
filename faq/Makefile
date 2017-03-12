all: fr.html

LANG_fr.po:=fr_FR.UTF-8

.PHONY: fr

.PRECIOUS: %.po

faq-en.html:
	wget -c http://linuxfromscratch.org/lfs/faq.html -O - | sed '/id="footer"/,$$d' | sed '/DOCTYPE/,/class="main"/d' | sed '339s|</dl>|</dl>\n      <dl>|' > $@

%.po: faq-en.html
	LANG=$(LANG_$@) po4a-updatepo -f xhtml -m $< -p $@

%.html: faq-en.html %.po
	$(LANG_EXPORT) po4a-translate -k 0 -f xhtml -m $< -l $@ -p $(word 2,$^)

clean:
	rm -f faq-en.html fr.html
