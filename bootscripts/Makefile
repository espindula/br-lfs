ETCDIR=/etc
EXTDIR=${DESTDIR}${ETCDIR}
MODE=754
DIRMODE=755
CONFMODE=644

all: install

create-dirs:
	install -d -m ${DIRMODE} ${EXTDIR}/rc.d/rc0.d
	install -d -m ${DIRMODE} ${EXTDIR}/rc.d/rc1.d
	install -d -m ${DIRMODE} ${EXTDIR}/rc.d/rc2.d
	install -d -m ${DIRMODE} ${EXTDIR}/rc.d/rc3.d
	install -d -m ${DIRMODE} ${EXTDIR}/rc.d/rc4.d
	install -d -m ${DIRMODE} ${EXTDIR}/rc.d/rc5.d
	install -d -m ${DIRMODE} ${EXTDIR}/rc.d/rc6.d
	install -d -m ${DIRMODE} ${EXTDIR}/rc.d/rcsysinit.d
	install -d -m ${DIRMODE} ${EXTDIR}/rc.d/init.d
	install -d -m ${DIRMODE} ${EXTDIR}/sysconfig

create-service-dir:
	install -d -m ${DIRMODE} ${EXTDIR}/sysconfig/network-devices/services

install: create-dirs create-service-dir
	install -m ${MODE} lfs/init.d/checkfs       ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/cleanfs       ${EXTDIR}/rc.d/init.d/
	install -m ${CONFMODE} lfs/init.d/functions ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/halt          ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/console       ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/consolelog    ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/localnet      ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/modules       ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/mountfs       ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/mountkernfs   ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/network       ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/rc            ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/reboot        ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/sendsignals   ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/setclock      ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/sysklogd	    ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/swap          ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/sysctl        ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/template      ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/udev          ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/udev_retry    ${EXTDIR}/rc.d/init.d/
	ln -sf ../init.d/network     ${EXTDIR}/rc.d/rc0.d/K80network
	ln -sf ../init.d/sysklogd   ${EXTDIR}/rc.d/rc0.d/K90sysklogd
	ln -sf ../init.d/sendsignals ${EXTDIR}/rc.d/rc0.d/S60sendsignals
	ln -sf ../init.d/mountfs     ${EXTDIR}/rc.d/rc0.d/S70mountfs
	ln -sf ../init.d/swap        ${EXTDIR}/rc.d/rc0.d/S80swap
	ln -sf ../init.d/localnet    ${EXTDIR}/rc.d/rc0.d/S90localnet
	ln -sf ../init.d/halt        ${EXTDIR}/rc.d/rc0.d/S99halt
	ln -sf ../init.d/network     ${EXTDIR}/rc.d/rc1.d/K80network
	ln -sf ../init.d/sysklogd   ${EXTDIR}/rc.d/rc1.d/K90sysklogd
	ln -sf ../init.d/network     ${EXTDIR}/rc.d/rc2.d/K80network
	ln -sf ../init.d/sysklogd   ${EXTDIR}/rc.d/rc2.d/K90sysklogd
	ln -sf ../init.d/sysklogd   ${EXTDIR}/rc.d/rc3.d/S10sysklogd
	ln -sf ../init.d/network     ${EXTDIR}/rc.d/rc3.d/S20network
	ln -sf ../init.d/sysklogd   ${EXTDIR}/rc.d/rc4.d/S10sysklogd
	ln -sf ../init.d/network     ${EXTDIR}/rc.d/rc4.d/S20network
	ln -sf ../init.d/sysklogd   ${EXTDIR}/rc.d/rc5.d/S10sysklogd
	ln -sf ../init.d/network     ${EXTDIR}/rc.d/rc5.d/S20network
	ln -sf ../init.d/network     ${EXTDIR}/rc.d/rc6.d/K80network
	ln -sf ../init.d/sysklogd   ${EXTDIR}/rc.d/rc6.d/K90sysklogd
	ln -sf ../init.d/sendsignals ${EXTDIR}/rc.d/rc6.d/S60sendsignals
	ln -sf ../init.d/mountfs     ${EXTDIR}/rc.d/rc6.d/S70mountfs
	ln -sf ../init.d/swap        ${EXTDIR}/rc.d/rc6.d/S80swap
	ln -sf ../init.d/localnet    ${EXTDIR}/rc.d/rc6.d/S90localnet
	ln -sf ../init.d/reboot      ${EXTDIR}/rc.d/rc6.d/S99reboot
	ln -sf ../init.d/mountkernfs ${EXTDIR}/rc.d/rcsysinit.d/S00mountkernfs
	ln -sf ../init.d/consolelog  ${EXTDIR}/rc.d/rcsysinit.d/S02consolelog
	ln -sf ../init.d/modules     ${EXTDIR}/rc.d/rcsysinit.d/S05modules
	ln -sf ../init.d/udev        ${EXTDIR}/rc.d/rcsysinit.d/S10udev
	ln -sf ../init.d/swap        ${EXTDIR}/rc.d/rcsysinit.d/S20swap
	ln -sf ../init.d/setclock    ${EXTDIR}/rc.d/rcsysinit.d/S25setclock
	ln -sf ../init.d/checkfs     ${EXTDIR}/rc.d/rcsysinit.d/S30checkfs
	ln -sf ../init.d/mountfs     ${EXTDIR}/rc.d/rcsysinit.d/S40mountfs
	ln -sf ../init.d/udev_retry  ${EXTDIR}/rc.d/rcsysinit.d/S45udev_retry
	ln -sf ../init.d/cleanfs     ${EXTDIR}/rc.d/rcsysinit.d/S50cleanfs
	ln -sf ../init.d/console     ${EXTDIR}/rc.d/rcsysinit.d/S70console
	ln -sf ../init.d/localnet    ${EXTDIR}/rc.d/rcsysinit.d/S80localnet
	ln -sf ../init.d/sysctl      ${EXTDIR}/rc.d/rcsysinit.d/S90sysctl
	if [ ! -f ${EXTDIR}/sysconfig/createfiles ]; then install -m ${CONFMODE} lfs/sysconfig/createfiles ${EXTDIR}/sysconfig/; fi
	if [ ! -f ${EXTDIR}/sysconfig/modules     ]; then install -m ${CONFMODE} lfs/sysconfig/modules     ${EXTDIR}/sysconfig/; fi
	if [ ! -f ${EXTDIR}/sysconfig/rc          ]; then install -m ${CONFMODE} lfs/sysconfig/rc          ${EXTDIR}/sysconfig/; fi
	install                   -m ${MODE} lfs/sysconfig/network-devices/ifup   ${EXTDIR}/sysconfig/network-devices/
	install                   -m ${MODE} lfs/sysconfig/network-devices/ifdown ${EXTDIR}/sysconfig/network-devices/
	install                   -m ${MODE} lfs/sysconfig/network-devices/services/ipv4-static       ${EXTDIR}/sysconfig/network-devices/services/
	install                   -m ${MODE} lfs/sysconfig/network-devices/services/ipv4-static-route ${EXTDIR}/sysconfig/network-devices/services/

install-consolelog: create-dirs
	install -m ${MODE} contrib/init.d/consolelog   ${EXTDIR}/rc.d/init.d
	ln -sf ../init.d/consolelog  ${EXTDIR}/rc.d/rcsysinit.d/S00consolelog

install-lsb-compliant:
	make -C contrib/lsb

install-service-mtu: create-service-dir
	install -m ${MODE} contrib/sysconfig/network-devices/services/mtu ${EXTDIR}/sysconfig/network-devices/services

minimal: create-dirs create-service-dir
	install -m ${MODE} lfs/init.d/checkfs       ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/cleanfs       ${EXTDIR}/rc.d/init.d/
	install -m ${CONFMODE} lfs/init.d/functions ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/halt          ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/localnet      ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/mountfs       ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/mountkernfs   ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/rc            ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/reboot        ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/sendsignals   ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/setclock      ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/swap          ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/udev          ${EXTDIR}/rc.d/init.d/
	ln -sf ../init.d/sendsignals ${EXTDIR}/rc.d/rc0.d/S60sendsignals
	ln -sf ../init.d/mountfs     ${EXTDIR}/rc.d/rc0.d/S70mountfs
	ln -sf ../init.d/swap        ${EXTDIR}/rc.d/rc0.d/S80swap
	ln -sf ../init.d/halt        ${EXTDIR}/rc.d/rc0.d/S99halt
	ln -sf ../init.d/sendsignals ${EXTDIR}/rc.d/rc6.d/S60sendsignals
	ln -sf ../init.d/mountfs     ${EXTDIR}/rc.d/rc6.d/S70mountfs
	ln -sf ../init.d/swap        ${EXTDIR}/rc.d/rc6.d/S80swap
	ln -sf ../init.d/reboot      ${EXTDIR}/rc.d/rc6.d/S99reboot
	ln -sf ../init.d/mountkernfs ${EXTDIR}/rc.d/rcsysinit.d/S00mountkernfs
	ln -sf ../init.d/udev        ${EXTDIR}/rc.d/rcsysinit.d/S10udev
	ln -sf ../init.d/swap        ${EXTDIR}/rc.d/rcsysinit.d/S20swap
	ln -sf ../init.d/setclock    ${EXTDIR}/rc.d/rcsysinit.d/S25setclock
	ln -sf ../init.d/checkfs     ${EXTDIR}/rc.d/rcsysinit.d/S30checkfs
	ln -sf ../init.d/mountfs     ${EXTDIR}/rc.d/rcsysinit.d/S40mountfs
	ln -sf ../init.d/cleanfs     ${EXTDIR}/rc.d/rcsysinit.d/S50cleanfs
	if [ ! -f ${EXTDIR}/sysconfig/rc          ]; then install -m ${CONFMODE} lfs/sysconfig/rc          ${EXTDIR}/sysconfig/; fi

.PHONY: all create-dirs create-service-dir \
	install install-service-mtu

