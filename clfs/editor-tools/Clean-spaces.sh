#!/bin/bash -e

# This script will clean the trailing spaces on the given file
# or in all XML files under the given directory.

NAME=`basename $0`

if [ -z "$1" ]; then
  echo "USAGE: $NAME -d directory"
  echo "       $NAME -f file"
  exit;
fi

case "$1" in
  -d )

    if [ -z "$2" ]; then
      echo "A directory is needed"
      exit
    fi;

    for filename in `find $2 -name "*.xml"`; do
      sed  -i -e "s/[[:space:]]\+$//" "${filename}"
    done;
    exit;;

  -f )

    if [ -z "$2" ]; then
      echo "A filename is needed"
      exit
    fi

    sed  -i -e "s/[[:space:]]\+$//" $2
    exit;;

  * )

    echo "USAGE: $NAME -d directory"
    echo "       $NAME -f file"
    exit;;

esac
