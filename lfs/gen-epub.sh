#/bin/bash


RENDERTMP=$1
BASEDIR=$2
EPUB_OUTPUT=$3

echo "RENDERTMP=$RENDERTMP"
echo "BASEDIR=$BASEDIR"
echo "EPUB_OUTPUT=EPUB_OUTPUT"

echo "application/epub+zip" > $RENDERTMP/mimetype
cd $RENDERTMP/
zip -0Xq $BASEDIR/$EPUB_OUTPUT ./mimetype
cd $RENDERTMP/lfs-epub/
zip -Xr9Dq $BASEDIR/$EPUB_OUTPUT ./*

