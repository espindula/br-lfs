EXTDIR=${DESTDIR}/etc
LIBDIR=${DESTDIR}/lib/services
MAN8=${DESTDIR}/usr/share/man/man8
SBIN=${DESTDIR}/sbin
MODE=754
DIRMODE=755
CONFMODE=644

all: links

install: all

create-dirs:
	install -d -m ${DIRMODE}  ${EXTDIR}/rc.d/rc0.d
	install -d -m ${DIRMODE}  ${EXTDIR}/rc.d/rc1.d
	install -d -m ${DIRMODE}  ${EXTDIR}/rc.d/rc2.d
	install -d -m ${DIRMODE}  ${EXTDIR}/rc.d/rc3.d
	install -d -m ${DIRMODE}  ${EXTDIR}/rc.d/rc4.d
	install -d -m ${DIRMODE}  ${EXTDIR}/rc.d/rc5.d
	install -d -m ${DIRMODE}  ${EXTDIR}/rc.d/rc6.d
	install -d -m ${DIRMODE}  ${EXTDIR}/rc.d/rcS.d
	install -d -m ${DIRMODE}  ${EXTDIR}/rc.d/init.d
	install -d -m ${DIRMODE}  ${EXTDIR}/sysconfig
	install -d -m ${DIRMODE}  ${LIBDIR}
	install -d -m ${DIRMODE}  ${MAN8}
	install -d -m ${DIRMODE}  ${SBIN}
	ln -sfn       services    ${DESTDIR}/lib/lsb
	ln -sfn       rc.d/init.d ${EXTDIR}/init.d

files: create-dirs 
	install -m ${MODE} lfs/init.d/checkfs       ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/cleanfs       ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/halt          ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/console       ${EXTDIR}/rc.d/init.d/
	install -m ${CONFMODE} lfs/init.d/functions ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/localnet      ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/modules       ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/mountfs       ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/mountvirtfs   ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/network       ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/rc            ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/reboot        ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/sendsignals   ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/setclock      ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/swap          ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/sysctl        ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/sysklogd      ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/template      ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/udev          ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/init.d/udev_retry    ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} lfs/sbin/ifup            ${SBIN}
	install -m ${MODE} lfs/sbin/ifdown          ${SBIN}
	install -m ${MODE} lfs/sbin/ifup.8          ${MAN8}
	ln -sf  ifup.8                              ${MAN8}/ifdown.8
	install -m ${MODE} lfs/lib/services/ipv4-static-route  ${LIBDIR}
	install -m ${MODE} lfs/lib/services/ipv4-static        ${LIBDIR}
	install -m ${CONFMODE} lfs/lib/services/init-functions ${LIBDIR}
	if [ ! -f ${EXTDIR}/sysconfig/createfiles ]; then \
          install -m ${CONFMODE} lfs/sysconfig/createfiles ${EXTDIR}/sysconfig/ ;\
        fi
	if [ ! -f ${EXTDIR}/sysconfig/modules     ]; then \
          install -m ${CONFMODE} lfs/sysconfig/modules     ${EXTDIR}/sysconfig/ ;\
        fi
	if [ ! -f ${EXTDIR}/sysconfig/udev_retry  ]; then \
          install -m ${CONFMODE} lfs/sysconfig/udev_retry  ${EXTDIR}/sysconfig/ ;\
        fi
	if [ ! -f ${EXTDIR}/sysconfig/rc          ]; then \
          install -m ${CONFMODE} lfs/sysconfig/rc          ${EXTDIR}/sysconfig/ ;\
        fi
	if [ ! -f ${EXTDIR}/sysconfig/rc.site     ]; then \
          install -m ${CONFMODE} lfs/sysconfig/rc.site     ${EXTDIR}/sysconfig/ ;\
        fi

links: rcS rc0 rc1 rc2 rc3 rc4 rc5 rc6

rcS: files
	ln -sf ../init.d/mountvirtfs ${EXTDIR}/rc.d/rcS.d/S00mountvirtfs
	ln -sf ../init.d/modules     ${EXTDIR}/rc.d/rcS.d/S05modules
	ln -sf ../init.d/localnet    ${EXTDIR}/rc.d/rcS.d/S08localnet
	ln -sf ../init.d/udev        ${EXTDIR}/rc.d/rcS.d/S10udev
	ln -sf ../init.d/swap        ${EXTDIR}/rc.d/rcS.d/S20swap
	ln -sf ../init.d/checkfs     ${EXTDIR}/rc.d/rcS.d/S30checkfs
	ln -sf ../init.d/mountfs     ${EXTDIR}/rc.d/rcS.d/S40mountfs
	ln -sf ../init.d/cleanfs     ${EXTDIR}/rc.d/rcS.d/S45cleanfs
	ln -sf ../init.d/udev_retry  ${EXTDIR}/rc.d/rcS.d/S50udev_retry
	ln -sf ../init.d/console     ${EXTDIR}/rc.d/rcS.d/S70console
	ln -sf ../init.d/sysctl      ${EXTDIR}/rc.d/rcS.d/S90sysctl

rc0: files
	ln -sf ../init.d/network     ${EXTDIR}/rc.d/rc0.d/K80network
	ln -sf ../init.d/sysklogd    ${EXTDIR}/rc.d/rc0.d/K90sysklogd
	ln -sf ../init.d/sendsignals ${EXTDIR}/rc.d/rc0.d/S60sendsignals
	ln -sf ../init.d/mountfs     ${EXTDIR}/rc.d/rc0.d/S70mountfs
	ln -sf ../init.d/swap        ${EXTDIR}/rc.d/rc0.d/S80swap
	ln -sf ../init.d/localnet    ${EXTDIR}/rc.d/rc0.d/S90localnet
	ln -sf ../init.d/halt        ${EXTDIR}/rc.d/rc0.d/S99halt

rc1: files
	ln -sf ../init.d/network     ${EXTDIR}/rc.d/rc1.d/K80network
	ln -sf ../init.d/sysklogd    ${EXTDIR}/rc.d/rc1.d/K90sysklogd

rc2: files
	ln -sf ../init.d/network     ${EXTDIR}/rc.d/rc2.d/K80network
	ln -sf ../init.d/sysklogd    ${EXTDIR}/rc.d/rc2.d/K90sysklogd

rc3: files
	ln -sf ../init.d/sysklogd    ${EXTDIR}/rc.d/rc3.d/S10sysklogd
	ln -sf ../init.d/network     ${EXTDIR}/rc.d/rc3.d/S20network

rc4: files
	ln -sf ../init.d/sysklogd    ${EXTDIR}/rc.d/rc4.d/S10sysklogd
	ln -sf ../init.d/network     ${EXTDIR}/rc.d/rc4.d/S20network

rc5: files
	ln -sf ../init.d/sysklogd    ${EXTDIR}/rc.d/rc5.d/S10sysklogd
	ln -sf ../init.d/network     ${EXTDIR}/rc.d/rc5.d/S20network

rc6: files
	ln -sf ../init.d/network     ${EXTDIR}/rc.d/rc6.d/K80network
	ln -sf ../init.d/sysklogd    ${EXTDIR}/rc.d/rc6.d/K90sysklogd
	ln -sf ../init.d/sendsignals ${EXTDIR}/rc.d/rc6.d/S60sendsignals
	ln -sf ../init.d/mountfs     ${EXTDIR}/rc.d/rc6.d/S70mountfs
	ln -sf ../init.d/swap        ${EXTDIR}/rc.d/rc6.d/S80swap
	ln -sf ../init.d/localnet    ${EXTDIR}/rc.d/rc6.d/S90localnet
	ln -sf ../init.d/reboot      ${EXTDIR}/rc.d/rc6.d/S99reboot

uninstall:
	rm -rf ${DESTDIR}/lib/services ${DESTDIR}/lib/lsb ${EXTDIR}/rc.d ${EXTDIR}/init.d \
               ${SBIN}/ifup ${SBIN}/ifdown ${MAN8}/ifup.8 ${MAN8}/ifdown.8 \
               ${EXTDIR}/sysconfig/rc 

.PHONY: all create-dirs install files links rcS rc0 rc1 rc2 rc3 rc4 rc5 rc6 uninstall

