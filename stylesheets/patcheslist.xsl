<?xml version='1.0' encoding='ISO-8859-1'?>
<!DOCTYPE xsl:stylesheet [
 <!ENTITY % general-entities SYSTEM "../general.ent">
  %general-entities;
]>

<!-- To work against BLFS some changes are needed -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:output method="text"/>

  <xsl:param name="links.directory">
    <xsl:value-of select="substring-after('&patches-root;', 'patches/')"/>
  </xsl:param>

  <xsl:template match="/">
    <xsl:text>#! /bin/bash&#x0a;</xsl:text>
    <xsl:text>&#x0a;  cd /home/httpd/</xsl:text>
    <xsl:value-of select="substring-after('&patches-root;', 'http://')"/>
    <xsl:text> &amp;&amp;&#x0a;&#x0a;</xsl:text>
    <xsl:text>  rm -f *.patch &amp;&amp;&#x0a;&#x0a;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#x0a;  chgrp lfswww *.patch &amp;&amp;&#x0a;</xsl:text>
    <xsl:text>&#x0a;  exit&#x0a;</xsl:text>
  </xsl:template>

  <xsl:template match="//text()">
    <xsl:text/>
  </xsl:template>

  <xsl:template match="//ulink">
    <xsl:if test="contains(@url, '.patch') and contains(@url, '&patches-root;')">
      <xsl:choose>
        <xsl:when test="ancestor-or-self::*/@condition = 'pdf'"/>
        <xsl:otherwise>
          <xsl:text>  cp </xsl:text>
          <xsl:text>/home/httpd/</xsl:text>
          <xsl:value-of select="substring-before (substring-after ('&patches-root;', 'http://'), $links.directory)"/>
          <xsl:text>downloads/</xsl:text>
          <xsl:if test="contains (@url, '-')">
            <xsl:variable name="cut" select="translate (@url, '0123456789', '2222222222')"/>
            <xsl:variable name="links.directory2" select="translate ($links.directory, '0123456789', '2222222222')"/>
            <xsl:choose>
              <xsl:when test="contains ($cut, ',')">
                <xsl:value-of select="substring-before (substring-after($cut, $links.directory2), ',2')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="contains ($cut, '-src-2')">
                    <xsl:value-of select="substring-before (substring-after($cut, $links.directory2), '-src-2')"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="substring-before (substring-after($cut, $links.directory2), '-2')"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="substring-after(@url, $links.directory)"/>
          <xsl:text> . &#x0a;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
