ETCDIR=/etc
EXTDIR=${DESTDIR}${ETCDIR}
MODE=754
DIRMODE=755
CONFMODE=644

all: install

create-dirs:
	install -d -m ${DIRMODE} ${EXTDIR}/rc0.d
	install -d -m ${DIRMODE} ${EXTDIR}/rc1.d
	install -d -m ${DIRMODE} ${EXTDIR}/rc2.d
	install -d -m ${DIRMODE} ${EXTDIR}/rc3.d
	install -d -m ${DIRMODE} ${EXTDIR}/rc4.d
	install -d -m ${DIRMODE} ${EXTDIR}/rc5.d
	install -d -m ${DIRMODE} ${EXTDIR}/rc6.d
	install -d -m ${DIRMODE} ${EXTDIR}/rcS.d
	install -d -m ${DIRMODE} ${EXTDIR}/init.d
	install -d -m ${DIRMODE} ${EXTDIR}/sysconfig
	install -d -m ${DIRMODE} ${DESTDIR}/lib/lsb
	install -d -m ${DIRMODE} ${EXTDIR}/lsb/state

create-service-dir:
	install -d -m ${DIRMODE} ${EXTDIR}/sysconfig/network-devices/services

create-boottemp-dir:
	install -d -m ${DIRMODE} ${EXTDIR}/init.d/boottemp

install: create-dirs create-service-dir create-boottemp-dir
	install -m ${MODE} init.d/checkfs.sh            ${EXTDIR}/init.d/
	install -m ${MODE} init.d/cleanfs               ${EXTDIR}/init.d/
	install -m ${CONFMODE} init.d/lfs-functions     ${EXTDIR}/init.d/
	install -m ${MODE} init.d/halt                  ${EXTDIR}/init.d/
	install -m ${MODE} init.d/console-screen-kbd.sh ${EXTDIR}/init.d/
	install -m ${MODE} init.d/localnet              ${EXTDIR}/init.d/
	install -m ${MODE} init.d/modules               ${EXTDIR}/init.d/
	install -m ${MODE} init.d/mountfs               ${EXTDIR}/init.d/
	install -m ${MODE} init.d/mountkernfs           ${EXTDIR}/init.d/
	install -m ${MODE} init.d/network               ${EXTDIR}/init.d/
	install -m ${MODE} init.d/rc                    ${EXTDIR}/init.d/
	install -m ${MODE} init.d/reboot                ${EXTDIR}/init.d/
	install -m ${MODE} init.d/sendsigs              ${EXTDIR}/init.d/
	install -m ${MODE} init.d/setclock              ${EXTDIR}/init.d/
	install -m ${MODE} init.d/sysklogd              ${EXTDIR}/init.d/
	install -m ${MODE} init.d/swap                  ${EXTDIR}/init.d/
	install -m ${MODE} init.d/sysctl                ${EXTDIR}/init.d/
	install -m ${MODE} init.d/template              ${EXTDIR}/init.d/
	install -m ${MODE} init.d/udev                  ${EXTDIR}/init.d/
	install -m ${MODE} init.d/udev_retry            ${EXTDIR}/init.d/
	install -m ${CONFMODE} lsb/init-functions       ${DESTDIR}/lib/lsb/
	install -m ${CONFMODE} lsb/manage-functions     ${DESTDIR}/lib/lsb/
	install -m ${CONFMODE} etc/lsb-config           ${EXTDIR}/lsb/
	if [ ! -f ${EXTDIR}/sysconfig/createfiles ]; then install -m ${CONFMODE} sysconfig/createfiles ${EXTDIR}/sysconfig/; fi
	if [ ! -f ${EXTDIR}/sysconfig/modules     ]; then install -m ${CONFMODE} sysconfig/modules     ${EXTDIR}/sysconfig/; fi
	if [ ! -f ${EXTDIR}/sysconfig/rc          ]; then install -m ${CONFMODE} sysconfig/rc          ${EXTDIR}/sysconfig/; fi
	if [ ! -f ${EXTDIR}/sysconfig/rc.site     ]; then install -m ${CONFMODE} sysconfig/rc.site     ${EXTDIR}/sysconfig/; fi
	if [ -f   ${EXTDIR}/inittab               ]; then install -m ${CONFMODE} ${EXTDIR}/inittab     ${EXTDIR}/inittab.bak; fi
	install                   -m ${CONFMODE} etc/inittab ${EXTDIR}/
	install                   -m ${MODE} sysconfig/network-devices/ifup   ${EXTDIR}/sysconfig/network-devices/
	install                   -m ${MODE} sysconfig/network-devices/ifdown ${EXTDIR}/sysconfig/network-devices/
	install                   -m ${MODE} sysconfig/network-devices/services/ipv4-static       ${EXTDIR}/sysconfig/network-devices/services/
	install                   -m ${MODE} sysconfig/network-devices/services/ipv4-static-route ${EXTDIR}/sysconfig/network-devices/services/
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/checkfs.sh
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/cleanfs
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/halt
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/console-screen-kbd.sh
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/localnet
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/modules
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/mountfs
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/mountkernfs
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/network
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/reboot
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/sendsigs
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/setclock
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/sysklogd
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/swap
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/sysctl
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/udev
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/udev_retry

minimal: create-dirs create-service-dir create-boottemp-dir
	install -m ${MODE} init.d/checkfs.sh        ${EXTDIR}/init.d/
	install -m ${MODE} init.d/cleanfs           ${EXTDIR}/init.d/
	install -m ${CONFMODE} init.d/lfs-functions ${EXTDIR}/init.d/
	install -m ${MODE} init.d/halt              ${EXTDIR}/init.d/
	install -m ${MODE} init.d/localnet          ${EXTDIR}/init.d/
	install -m ${MODE} init.d/mountfs           ${EXTDIR}/init.d/
	install -m ${MODE} init.d/mountkernfs       ${EXTDIR}/init.d/
	install -m ${MODE} init.d/rc                ${EXTDIR}/init.d/
	install -m ${MODE} init.d/reboot            ${EXTDIR}/init.d/
	install -m ${MODE} init.d/sendsigs       ${EXTDIR}/init.d/
	install -m ${MODE} init.d/setclock          ${EXTDIR}/init.d/
	install -m ${MODE} init.d/swap              ${EXTDIR}/init.d/
	install -m ${MODE} init.d/udev              ${EXTDIR}/init.d/
	install -m ${CONFMODE} lsb/init-functions   ${DESTDIR}/lib/lsb/
	install -m ${CONFMODE} lsb/manage-functions ${DESTDIR}/lib/lsb/
	install -m ${CONFMODE} etc/lsb-config       ${EXTDIR}/lsb/
	if [ ! -f ${EXTDIR}/sysconfig/rc          ]; then install -m ${CONFMODE} sysconfig/rc          ${EXTDIR}/sysconfig/; fi
	if [ -f   ${EXTDIR}/inittab               ]; then install -m ${CONFMODE} ${EXTDIR}/inittab     ${EXTDIR}/inittab.bak; fi
	install                   -m ${CONFMODE} etc/inittab ${EXTDIR}/
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/checkfs.sh
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/cleanfs
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/halt
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/localnet
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/mountfs
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/mountkernfs
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/reboot
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/sendsigs
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/setclock
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/swap
	/usr/lib/lsb/install_initd ${EXTDIR}/init.d/udev

.PHONY: all create-dirs create-service-dir create-boottemp-dir \
	install minimal 

