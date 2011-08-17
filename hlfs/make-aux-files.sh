#!/bin/bash

rm -f hlfs-bootscripts*.tar.bz2

# Get base file name and move bootscripts directory to that name
version=`grep "ENTITY hlfs-bootscripts-version" packages.ent |cut -d'"' -f2`
mv bootscripts hlfs-bootscripts-$version

# Create the tarball and clean up
tar -cjf hlfs-bootscripts-$version.tar.bz2 --exclude .svn hlfs-bootscripts-$version
mv hlfs-bootscripts-$version bootscripts 

rm -f udev-config*.bz2

# Get file name and move udev config directory to that name
version=`grep "ENTITY udev-config " packages.ent |cut -d'"' -f2`
mv udev-config $version

# Create the tarball and clean up
tar -cjf $version.tar.bz2 --exclude .svn $version
mv $version udev-config

