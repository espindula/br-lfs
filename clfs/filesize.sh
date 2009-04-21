#!/bin/bash

FILENAME=$1

if [ "${FILENAME}" = ""  ]; then
  echo "To Calculate the proper file size use the following command."
  echo "$0 filename"
  exit 255
else
  FILESIZE=$(ls -l ${FILENAME} | cut -f5 -d' ')
  ((size=${FILESIZE}/1024))
  if [ "${size}" = "0" ]; then
    size=$(echo .$(echo ${FILESIZE} | cut -b1))
  fi
  FILEMD5SUM=$(md5sum ${FILENAME})

  echo "${size} KB"
  echo "${FILEMD5SUM}"
fi
