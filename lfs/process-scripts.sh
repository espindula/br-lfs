#!/bin/bash

# Boot scripts
for s in lsb-bootscripts/etc/init.d/*                    \
         lsb-bootscripts/etc/default/*                 \
         lsb-bootscripts/sbin/* \
         lsb-bootscripts/lib/network-services/*
do
  script=$(basename $s)
  
  # Skip directories
  [ $script == 'sbin' ] && continue
  [ $script == 'network-services'        ] && continue

  # Disambiguate duplicate file names
  [ $s == 'lsb-bootscripts/etc/default/rc'      ] && script='rc-sysinit'; 
  [ $s == 'lsb-bootscripts/etc/default/modules' ] && script='modules-sysinit'; 
  
  sed  -e 's/\&/\&amp\;/g' -e 's/</\&lt\;/g'   -e 's/>/\&gt\;/g' \
       -e "s/'/\&apos\;/g" -e 's/"/\&quot\;/g' -e 's/\t/    /g'  \
       $s > appendices/${script}.script 
done

# Udev rules
for s in udev-config/*.rules
do
  script=$(basename $s)

  sed  -e 's/\&/\&amp\;/g' -e 's/</\&lt\;/g'   -e 's/>/\&gt\;/g' \
       -e "s/'/\&apos\;/g" -e 's/"/\&quot\;/g' -e 's/\t/    /g'  \
       $s > appendices/${script}.script 
done
