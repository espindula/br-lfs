<?xml version='1.0' encoding='ISO-8859-1'?>

<!-- This work against BLFS also -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:output method="text"/>

  <xsl:param name="links.directory">lfs/cvs/unstable/</xsl:param>
  <xsl:param name="deep.to.downloads">../../../</xsl:param>

  <xsl:template match="/">
    <xsl:text>#! /bin/bash

  cd /home/httpd/www.linuxfromscratch.org/patches/</xsl:text>
    <xsl:value-of select="$links.directory"/>
    <xsl:text> &amp;&amp;&#x0a;&#x0a;</xsl:text>
    <xsl:text>  rm -f *.patch &amp;&amp;&#x0a;&#x0a;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#x0a;  exit</xsl:text>
  </xsl:template>

  <xsl:template match="//text()">
    <xsl:text/>
  </xsl:template>

  <xsl:template match="//ulink">
    <xsl:if test="contains(@url, '.patch') and contains(@url, 'linuxfromscratch')">
      <xsl:text>  cp </xsl:text>
      <xsl:value-of select="$deep.to.downloads"/>
      <xsl:text>downloads/</xsl:text>
      <xsl:value-of select="substring-before (substring-after(@url, $links.directory), '-')"/>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="substring-after(@url, $links.directory)"/>
      <xsl:text> . &amp;&amp;&#x0a;</xsl:text>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
