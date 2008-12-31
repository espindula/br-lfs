#!/bin/bash

# This script will create a copy of the given XML file
# with the Xinclude tags resolved.

# Must be executed from the same dir where the XML file
# to be resolved is found.

# The DTD declaration is removed from the output due that
# xmllint add also the full set of entities.

# Useful to see the actual text and commands and to know
# in what files the Xincluded blocks are actually placed.

# Remember to remove the full-*xml files after finished
# your review of that files. They don't be commited to the
# SVN repository.

NAME=`basename $0`

if [ -z "$1" ]; then
  echo "USAGE: $NAME filename.xml"
  exit
fi

xmllint -xinclude -output /tmp/temp.xml $1

xmllint -dropdtd -output full-$1 /tmp/temp.xml
