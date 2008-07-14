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
	install -d -m ${DIRMODE} ${EXTDIR}/rcsysinit.d
	install -d -m ${DIRMODE} ${EXTDIR}/init.d
	install -d -m ${DIRMODE} ${EXTDIR}/sysconfig
	install -d -m ${DIRMODE} ${DESTDIR}/lib/lsb
	install -d -m ${DIRMODE} ${EXTDIR}/lsb/state

create-service-dir:
	install -d -m ${DIRMODE} ${EXTDIR}/sysconfig/network-devices/services

create-boottemp-dir:
	install -d -m ${DIRMODE} ${EXTDIR}/init.d/boottemp

install: create-dirs create-service-dir create-boottemp-dir
	install -m ${MODE} init.d/checkfs           ${EXTDIR}/init.d/
	install -m ${MODE} init.d/cleanfs           ${EXTDIR}/init.d/
	install -m ${CONFMODE} init.d/lfs-functions ${EXTDIR}/init.d/
	install -m ${MODE} init.d/halt              ${EXTDIR}/init.d/
	install -m ${MODE} init.d/console           ${EXTDIR}/init.d/
	install -m ${MODE} init.d/localnet          ${EXTDIR}/init.d/
	install -m ${MODE} init.d/modules           ${EXTDIR}/init.d/
	install -m ${MODE} init.d/mountfs           ${EXTDIR}/init.d/
	install -m ${MODE} init.d/mountkernfs       ${EXTDIR}/init.d/
	install -m ${MODE} init.d/network           ${EXTDIR}/init.d/
	install -m ${MODE} init.d/rc                ${EXTDIR}/init.d/
	install -m ${MODE} init.d/reboot            ${EXTDIR}/init.d/
	install -m ${MODE} init.d/sendsignals       ${EXTDIR}/init.d/
	install -m ${MODE} init.d/setclock          ${EXTDIR}/init.d/
	install -m ${MODE} init.d/sysklogd          ${EXTDIR}/init.d/
	install -m ${MODE} init.d/swap              ${EXTDIR}/init.d/
	install -m ${MODE} init.d/sysctl            ${EXTDIR}/init.d/
	install -m ${MODE} init.d/template          ${EXTDIR}/init.d/
	install -m ${MODE} init.d/udev              ${EXTDIR}/init.d/
	install -m ${MODE} init.d/udev_retry        ${EXTDIR}/init.d/
	install -m ${CONFMODE} lsb/init-functions   ${DESTDIR}/lib/lsb/
	install -m ${CONFMODE} lsb/manage-functions ${DESTDIR}/lib/lsb/
	install -m ${CONFMODE} etc/lsb-config       ${EXTDIR}/lsb/
	ln -sf ../init.d/network     ${EXTDIR}/rc0.d/K80network
	ln -sf ../init.d/sysklogd    ${EXTDIR}/rc0.d/K90sysklogd
	ln -sf ../init.d/sendsignals ${EXTDIR}/rc0.d/S60sendsignals
	ln -sf ../init.d/mountfs     ${EXTDIR}/rc0.d/S70mountfs
	ln -sf ../init.d/swap        ${EXTDIR}/rc0.d/S80swap
	ln -sf ../init.d/localnet    ${EXTDIR}/rc0.d/S90localnet
	ln -sf ../init.d/halt        ${EXTDIR}/rc0.d/S99halt
	ln -sf ../init.d/network     ${EXTDIR}/rc1.d/K80network
	ln -sf ../init.d/sysklogd    ${EXTDIR}/rc1.d/K90sysklogd
	ln -sf ../init.d/network     ${EXTDIR}/rc2.d/K80network
	ln -sf ../init.d/sysklogd    ${EXTDIR}/rc2.d/K90sysklogd
	ln -sf ../init.d/sysklogd    ${EXTDIR}/rc3.d/S10sysklogd
	ln -sf ../init.d/network     ${EXTDIR}/rc3.d/S20network
	ln -sf ../init.d/sysklogd    ${EXTDIR}/rc4.d/S10sysklogd
	ln -sf ../init.d/network     ${EXTDIR}/rc4.d/S20network
	ln -sf ../init.d/sysklogd    ${EXTDIR}/rc5.d/S10sysklogd
	ln -sf ../init.d/network     ${EXTDIR}/rc5.d/S20network
	ln -sf ../init.d/network     ${EXTDIR}/rc6.d/K80network
	ln -sf ../init.d/sysklogd    ${EXTDIR}/rc6.d/K90sysklogd
	ln -sf ../init.d/sendsignals ${EXTDIR}/rc6.d/S60sendsignals
	ln -sf ../init.d/mountfs     ${EXTDIR}/rc6.d/S70mountfs
	ln -sf ../init.d/swap        ${EXTDIR}/rc6.d/S80swap
	ln -sf ../init.d/localnet    ${EXTDIR}/rc6.d/S90localnet
	ln -sf ../init.d/reboot      ${EXTDIR}/rc6.d/S99reboot
	ln -sf ../init.d/mountkernfs ${EXTDIR}/rcsysinit.d/S00mountkernfs
	ln -sf ../init.d/sysctl      ${EXTDIR}/rcsysinit.d/S05sysctl
	ln -sf ../init.d/modules     ${EXTDIR}/rcsysinit.d/S10modules
	ln -sf ../init.d/udev        ${EXTDIR}/rcsysinit.d/S15udev
	ln -sf ../init.d/swap        ${EXTDIR}/rcsysinit.d/S20swap
	ln -sf ../init.d/setclock    ${EXTDIR}/rcsysinit.d/S25setclock
	ln -sf ../init.d/checkfs     ${EXTDIR}/rcsysinit.d/S30checkfs
	ln -sf ../init.d/mountfs     ${EXTDIR}/rcsysinit.d/S40mountfs
	ln -sf ../init.d/udev_retry  ${EXTDIR}/rcsysinit.d/S45udev_retry
	ln -sf ../init.d/cleanfs     ${EXTDIR}/rcsysinit.d/S50cleanfs
	ln -sf ../init.d/console     ${EXTDIR}/rcsysinit.d/S70console
	ln -sf ../init.d/localnet    ${EXTDIR}/rcsysinit.d/S80localnet
	if [ ! -f ${EXTDIR}/sysconfig/createfiles ]; then install -m ${CONFMODE} sysconfig/createfiles ${EXTDIR}/sysconfig/; fi
	if [ ! -f ${EXTDIR}/sysconfig/modules     ]; then install -m ${CONFMODE} sysconfig/modules     ${EXTDIR}/sysconfig/; fi
	if [ ! -f ${EXTDIR}/sysconfig/rc          ]; then install -m ${CONFMODE} sysconfig/rc          ${EXTDIR}/sysconfig/; fi
	if [ ! -f ${EXTDIR}/sysconfig/rc.site     ]; then install -m ${CONFMODE} sysconfig/rc.site     ${EXTDIR}/sysconfig/; fi
	install                   -m ${MODE} sysconfig/network-devices/ifup   ${EXTDIR}/sysconfig/network-devices/
	install                   -m ${MODE} sysconfig/network-devices/ifdown ${EXTDIR}/sysconfig/network-devices/
	install                   -m ${MODE} sysconfig/network-devices/services/ipv4-static       ${EXTDIR}/sysconfig/network-devices/services/
	install                   -m ${MODE} sysconfig/network-devices/services/ipv4-static-route ${EXTDIR}/sysconfig/network-devices/services/

minimal: create-dirs create-service-dir create-boottemp-dir
	install -m ${MODE} init.d/checkfs           ${EXTDIR}/init.d/
	install -m ${MODE} init.d/cleanfs           ${EXTDIR}/init.d/
	install -m ${CONFMODE} init.d/lfs-functions ${EXTDIR}/init.d/
	install -m ${MODE} init.d/halt              ${EXTDIR}/init.d/
	install -m ${MODE} init.d/localnet          ${EXTDIR}/init.d/
	install -m ${MODE} init.d/mountfs           ${EXTDIR}/init.d/
	install -m ${MODE} init.d/mountkernfs       ${EXTDIR}/init.d/
	install -m ${MODE} init.d/rc                ${EXTDIR}/init.d/
	install -m ${MODE} init.d/reboot            ${EXTDIR}/init.d/
	install -m ${MODE} init.d/sendsignals       ${EXTDIR}/init.d/
	install -m ${MODE} init.d/setclock          ${EXTDIR}/init.d/
	install -m ${MODE} init.d/swap              ${EXTDIR}/init.d/
	install -m ${MODE} init.d/udev              ${EXTDIR}/init.d/
	install -m ${CONFMODE} lsb/init-functions   ${DESTDIR}/lib/lsb/
	install -m ${CONFMODE} lsb/manage-functions ${DESTDIR}/lib/lsb/
	install -m ${CONFMODE} etc/lsb-config       ${EXTDIR}/lsb/
	ln -sf ../init.d/sendsignals ${EXTDIR}/rc0.d/S60sendsignals
	ln -sf ../init.d/mountfs     ${EXTDIR}/rc0.d/S70mountfs
	ln -sf ../init.d/swap        ${EXTDIR}/rc0.d/S80swap
	ln -sf ../init.d/halt        ${EXTDIR}/rc0.d/S99halt
	ln -sf ../init.d/sendsignals ${EXTDIR}/rc6.d/S60sendsignals
	ln -sf ../init.d/mountfs     ${EXTDIR}/rc6.d/S70mountfs
	ln -sf ../init.d/swap        ${EXTDIR}/rc6.d/S80swap
	ln -sf ../init.d/reboot      ${EXTDIR}/rc6.d/S99reboot
	ln -sf ../init.d/mountkernfs ${EXTDIR}/rcsysinit.d/S00mountkernfs
	ln -sf ../init.d/udev        ${EXTDIR}/rcsysinit.d/S10udev
	ln -sf ../init.d/swap        ${EXTDIR}/rcsysinit.d/S20swap
	ln -sf ../init.d/setclock    ${EXTDIR}/rcsysinit.d/S25setclock
	ln -sf ../init.d/checkfs     ${EXTDIR}/rcsysinit.d/S30checkfs
	ln -sf ../init.d/mountfs     ${EXTDIR}/rcsysinit.d/S40mountfs
	ln -sf ../init.d/cleanfs     ${EXTDIR}/rcsysinit.d/S50cleanfs
	if [ ! -f ${EXTDIR}/sysconfig/rc          ]; then install -m ${CONFMODE} sysconfig/rc          ${EXTDIR}/sysconfig/; fi

.PHONY: all create-dirs create-service-dir create-boottemp-dir \
	install minimal 

