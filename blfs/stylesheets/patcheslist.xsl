<?xml version='1.0' encoding='UTF-8'?>
<!DOCTYPE xsl:stylesheet [
 <!ENTITY % general-entities SYSTEM "../general.ent">
  %general-entities;
]>

<!--
$LastChangedBy: randy $
$Date: 2007-01-30 21:25:59 +0100 (mar, 30 jan 2007) $
-->

<!--
  This stylesheet creates a script to copy the patches referenced
  in the BLFS book from the patches repository to the blfs
  download area.  It is very specific to the installation on
  the home server.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:output method="text"/>

    <!-- Allow select the dest dir at runtime -->
  <xsl:param name="dest.dir">
    <xsl:value-of select="concat('/srv/www/', substring-after('&patch-root;', 'http://'))"/>
  </xsl:param>

  <xsl:template match="/">
    <xsl:text>#! /bin/bash&#x0a;&#x0a;</xsl:text>
    <xsl:text>function copy
{
   cp $1 $2 >>copyerrs 2>&amp;1
}&#x0a;&#x0a;</xsl:text>
      <!-- Create dest.dir if it don't exist -->
    <xsl:text>mkdir -p </xsl:text>
    <xsl:value-of select="$dest.dir"/>
    <xsl:text> &amp;&amp;&#x0a;</xsl:text>
    <xsl:text>cd </xsl:text>
    <xsl:value-of select="$dest.dir"/>
    <xsl:text> &amp;&amp;&#x0a;&#x0a;</xsl:text>
      <!-- Remove old patches and possible list of missing patches-->
    <xsl:text>rm -f *.patch copyerrs &amp;&amp;&#x0a;&#x0a;</xsl:text>
    <xsl:apply-templates/>
      <!-- Ensure correct ownership -->
    <xsl:text>&#x0a;chgrp lfswww *.patch &amp;&amp;&#x0a;</xsl:text>
    <xsl:text>if [ `wc -l copyerrs|sed 's/ *//' |cut -f1 -d' '` -gt 0 ]; then
  mail -s "Missing BLFS patches" blfs-book@linuxfromscratch.org &lt; copyerrs
fi</xsl:text>
    <xsl:text>&#x0a;exit&#x0a;</xsl:text>
  </xsl:template>

  <xsl:template match="//text()"/>

  <xsl:template match="//ulink">
      <!-- Match only local patches links and skip duplicated URLs splitted for PDF output-->
    <xsl:if test="contains(@url, '.patch') and contains(@url, '&patch-root;')
            and not(ancestor-or-self::*/@condition = 'pdf')">
      <xsl:variable name="patch.name" select="substring-after(@url, '&patch-root;')"/>
      <xsl:text>copy /srv/www/www.linuxfromscratch.org/patches/downloads</xsl:text>
      <xsl:choose>
          <!-- cdparanoia -->
        <xsl:when test="contains($patch.name, '-III')">
          <xsl:text>/cdparanoia</xsl:text>
        </xsl:when>
          <!-- Open Office -->
        <xsl:when test="contains($patch.name, 'OOo')">
          <xsl:text>/OOo</xsl:text>
        </xsl:when>
          <!-- QT -->
        <xsl:when test="contains($patch.name, 'qt-x')">
          <xsl:text>/qt</xsl:text>
        </xsl:when>
          <!-- XOrg -->
        <xsl:when test="contains($patch.name, 'X11R6')">
          <xsl:text>/xorg</xsl:text>
        </xsl:when>
          <!-- net-tools -->
        <xsl:when test="contains($patch.name, 'net-tools')">
          <xsl:text>/net-tools</xsl:text>
        </xsl:when>
          <!-- x265 -->
        <xsl:when test="contains($patch.name, 'x265')">
          <xsl:text>/x265</xsl:text>
        </xsl:when>
          <!-- General rule -->
        <xsl:otherwise>
          <xsl:variable name="cut"
                  select="translate(substring-after($patch.name, '-'), '0123456789', '0000000000')"/>
          <xsl:variable name="patch.name2">
            <xsl:value-of select="substring-before($patch.name, '-')"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="$cut"/>
          </xsl:variable>
          <xsl:value-of select="substring-before($patch.name2, '-0')"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="$patch.name"/>
      <xsl:text> . &#x0a;</xsl:text>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>

