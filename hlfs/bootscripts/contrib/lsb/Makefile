ETCDIR=/etc
EXTDIR=${DESTDIR}${ETCDIR}
MODE=754
DIRMODE=755
CONFMODE=644

install:
	install -d -m ${DIRMODE} ${DESTDIR}/lib/lsb
	install -m ${CONFMODE} lib/init-functions ${DESTDIR}/lib/lsb

.PHONY: install
