#!/bin/sh
# Written By: Joe Ciccone <jciccone@gmail.com>

if test -z "$1"; then
  echo "Usage: $0 path"
  exit 1
fi

TOP=`dirname $0`

if test -d "$1"; then
  find "$1" -type f -name \*.html | while read file; do
    tidy -config "${TOP}/tidy.conf" "$file"
    bash "${TOP}/obfuscate.sh" "$file"
    sed -i -e "s@text/html@application/xhtml+xml@g" "$file"
  done
else
  tidy -config "${TOP}/tidy.conf" "$1"
    bash "${TOP}/obfuscate.sh" "$1"
    sed -i -e "s@text/html@application/xhtml+xml@g" "$1"
fi

exit $?
