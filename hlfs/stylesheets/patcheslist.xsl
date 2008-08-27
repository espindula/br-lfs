<?xml version='1.0' encoding='ISO-8859-1'?>
<!DOCTYPE xsl:stylesheet [
 <!ENTITY % general-entities SYSTEM "../general.ent">
  %general-entities;
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:output method="text"/>

    <!-- Allow select the dest dir at runtime -->
  <xsl:param name="dest.dir">
    <xsl:value-of select="concat('/srv/www/', substring-after('&patches-root;', 'http://'))"/>
  </xsl:param>

  <xsl:template match="/">
    <xsl:text>#! /bin/bash

function copy
{
  install --preserve-timestamps --mode=0664 --group=lfswww $1 $2 >>copyerrs 2>&amp;1
}

umask 002 &#x0a;&#x0a;</xsl:text>

      <!-- Create dest.dir if it doesn't exist. -->
      <!-- This 'if' statement works around instances when the directory
           already exists and I do not own it. -->
    <xsl:text>if test ! -d </xsl:text>
    <xsl:value-of select="$dest.dir"/>
    <!-- Create the directory with 'set group ID' so that subdirectories keep
         the same group ownership. -->
    <xsl:text> ; then install --directory --mode=2775 --group=lfswww </xsl:text>
    <xsl:value-of select="$dest.dir"/>
    <xsl:text> ; fi</xsl:text>

    <xsl:text> &amp;&amp;&#x0a;</xsl:text>
    <xsl:text>cd </xsl:text>
    <xsl:value-of select="$dest.dir"/>
    <xsl:text> &amp;&amp;&#x0a;&#x0a;</xsl:text>
      <!-- Remove old patches -->
    <xsl:text>rm -f *.patch copyerrs &amp;&amp; &#x0a;&#x0a;</xsl:text>
    <xsl:apply-templates/>
      <!-- Ensure correct owneship -->
      <!-- Changes to the group ID would be weird here too. -->
    <xsl:text>&#x0a;chgrp --changes lfswww *.patch &amp;&amp;&#x0a;</xsl:text>
    <xsl:text>
if [ `wc -l copyerrs | sed 's/ *//' | cut -f1 -d' '` -gt 0 ]; then
  mail -s "Missing HLFS patches" hlfs-book@linuxfromscratch.org &lt; copyerrs
fi&#x0a;&#x0a;</xsl:text>

    <xsl:text>exit&#x0a;</xsl:text>
  </xsl:template>

  <xsl:template match="//text()"/>

  <xsl:template match="//ulink">
      <!-- Match only local patches links and skip duplicated URLs splitted for PDF output-->
    <xsl:if test="contains(@url, '.patch') and contains(@url, '&patches-root;')
            and not(ancestor-or-self::*/@condition = 'pdf')">
      <xsl:variable name="patch.name" select="substring-after(@url, '&patches-root;')"/>
      <xsl:variable name="cut"
              select="translate(substring-after($patch.name, '-'), '0123456789', '0000000000')"/>
      <xsl:variable name="patch.name2">
        <xsl:value-of select="substring-before($patch.name, '-')"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="$cut"/>
      </xsl:variable>
      <xsl:text>copy /srv/www/www.linuxfromscratch.org/patches/downloads/</xsl:text>
          <xsl:value-of select="substring-before($patch.name2, '-0')"/>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="$patch.name"/>
      <xsl:text> . &#x0a;</xsl:text>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
