TARGETS := faq-fr.html faq-lfs-fr.html faq-blfs-fr.html


all: $(TARGETS:%.html=generated/%.html)

LANG_fr.po:=fr_FR.UTF-8

.PHONY: generated

.PRECIOUS: %.po

generated:
	mkdir -p generated

faq-lfs-en.html:
	wget -c http://linuxfromscratch.org/lfs/faq.html -O - | sed '/id="footer"/,$$d' | sed '/DOCTYPE/,/class="main"/d' | sed '339s|</dl>|</dl>\n      <dl>|' > $@

faq-blfs-en.html:
	wget -c http://linuxfromscratch.org/blfs/faq.html -O - | sed '/id="footer"/,$$d' | sed '/DOCTYPE/,/class="main"/d' | sed '339s|</dl>|</dl>\n      <dl>|' > $@

faq-en.html:
	wget -c http://linuxfromscratch.org/faq/index.html -O - | sed '/id="footer"/,$$d' | sed '/DOCTYPE/,/class="main"/d' | sed '339s|</dl>|</dl>\n      <dl>|' > $@

complete.html: faq-en.html faq-blfs-en.html faq-lfs-en.html
	cat $^ > $@

%.po: complete.html
	LANG=$(LANG_$@) po4a-updatepo -f xhtml -m $< -p $@

generated/faq-%.html: faq-en.html %.po generated
	$(LANG_EXPORT) po4a-translate -k 0 -f xhtml -m $< -l $@ -p $(word 2,$^)

generated/faq-lfs-%.html: faq-lfs-en.html %.po generated
	$(LANG_EXPORT) po4a-translate -k 0 -f xhtml -m $< -l $@ -p $(word 2,$^)

generated/faq-blfs-%.html: faq-blfs-en.html %.po generated
	$(LANG_EXPORT) po4a-translate -k 0 -f xhtml -m $< -l $@ -p $(word 2,$^)

clean:
	rm -f *.html
	rm -rf generated
