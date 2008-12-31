#!/bin/bash

# This script will find all XML files in the working repository copy
# that contains the same string in their name.

# To be executed from the top-level directory.

# Useful to find the files related with a same package in all
# directories and architectures.

NAME=`basename $0`

if [ -z "$1" ]; then
  echo "USAGE: $NAME string"
  exit
fi

find . -name "*$1*.xml" | sort
