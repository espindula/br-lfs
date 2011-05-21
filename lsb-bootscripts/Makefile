ETCDIR=/etc
EXTDIR=${DESTDIR}${ETCDIR}
MODE=754
DIRMODE=755
CONFMODE=644

all: install

create-dirs:
	if test ! -d /${DESTDIR}; then install -d -m ${DIRMODE} ${EXTDIR}; fi
	install -d -m ${DIRMODE} ${EXTDIR}/rc0.d
	install -d -m ${DIRMODE} ${EXTDIR}/rc1.d
	install -d -m ${DIRMODE} ${EXTDIR}/rc2.d
	install -d -m ${DIRMODE} ${EXTDIR}/rc3.d
	install -d -m ${DIRMODE} ${EXTDIR}/rc4.d
	install -d -m ${DIRMODE} ${EXTDIR}/rc5.d
	install -d -m ${DIRMODE} ${EXTDIR}/rc6.d
	install -d -m ${DIRMODE} ${EXTDIR}/rcS.d
	install -d -m ${DIRMODE} ${EXTDIR}/init.d
	install -d -m ${DIRMODE} ${EXTDIR}/default
	install -d -m ${DIRMODE} ${EXTDIR}/network
	install -d -m ${DIRMODE} ${DESTDIR}/sbin
	install -d -m ${DIRMODE} ${DESTDIR}/lib/lsb
	install -d -m ${DIRMODE} ${DESTDIR}/lib/network-services

install: create-dirs
	install -m ${MODE} etc/init.d/checkfs               ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/cleanfs               ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/halt                  ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/console               ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/localnet              ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/modules               ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/mountfs               ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/mountvirtfs           ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/network               ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/rc                    ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/reboot                ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/sendsignals           ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/setclock              ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/sysklogd              ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/swap                  ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/sysctl                ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/template              ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/udev                  ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/udev_retry            ${EXTDIR}/init.d/
	install -m ${CONFMODE} lib/lsb/init-functions       ${DESTDIR}/lib/lsb/
	if [ ! -f ${EXTDIR}/default/createfiles ]; then install -m ${CONFMODE} etc/default/createfiles ${EXTDIR}/default/; fi
	if [ ! -f ${EXTDIR}/default/modules     ]; then install -m ${CONFMODE} etc/default/modules     ${EXTDIR}/default/; fi
	if [ ! -f ${EXTDIR}/default/rc          ]; then install -m ${CONFMODE} etc/default/rc          ${EXTDIR}/default/; fi
	if [ ! -f ${EXTDIR}/default/rc.site     ]; then install -m ${CONFMODE} etc/default/rc.site     ${EXTDIR}/default/; fi
	if [ -f   ${EXTDIR}/inittab               ]; then install -m ${CONFMODE} ${EXTDIR}/inittab     ${EXTDIR}/inittab.bak; fi
	install                   -m ${CONFMODE} etc/inittab ${EXTDIR}/
	install                   -m ${MODE} sbin/ifup   ${DESTDIR}/sbin/
	install                   -m ${MODE} sbin/ifdown ${DESTDIR}/sbin/
	install                   -m ${MODE} lib/network-services/ipv4-static       ${DESTDIR}/lib/network-services/
	install                   -m ${MODE} lib/network-services/ipv4-static-route ${DESTDIR}/lib/network-services/
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/checkfs
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/cleanfs
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/halt
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/console
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/localnet
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/modules
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/mountfs
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/mountvirtfs
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/network
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/reboot
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/sendsignals
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/sysklogd
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/swap
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/sysctl
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/udev
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/udev_retry

minimal: create-dirs
	install -m ${MODE} etc/init.d/checkfs           ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/cleanfs           ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/halt              ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/localnet          ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/mountfs           ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/mountvirtfs       ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/rc                ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/reboot            ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/sendsignals       ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/detclock          ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/swap              ${EXTDIR}/init.d/
	install -m ${MODE} etc/init.d/udev              ${EXTDIR}/init.d/
	install -m ${CONFMODE} lib/lsb/init-functions   ${DESTDIR}/lib/lsb/
	if [ ! -f ${EXTDIR}/default/rc          ]; then install -m ${CONFMODE} default/rc          ${EXTDIR}/default/; fi
	if [ -f   ${EXTDIR}/inittab               ]; then install -m ${CONFMODE} ${EXTDIR}/inittab     ${EXTDIR}/inittab.bak; fi
	install                   -m ${CONFMODE} etc/inittab ${EXTDIR}/
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/checkfs
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/cleanfs
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/halt
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/localnet
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/mountfs
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/mountvirtfs
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/reboot
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/sendsignals
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/swap
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/udev

.PHONY: all create-dirs install minimal

