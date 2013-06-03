<?xml version='1.0' encoding='ISO-8859-1'?>
<!DOCTYPE xsl:stylesheet [
 <!ENTITY % general-entities SYSTEM "../general.ent">
  %general-entities;
]>

<!--
XSLT stylesheet to create md5sum file for packages and patches to check integrity.
Only for Cross-LFS.

Usage example:

xsltproc -xinclude -nonet -output mips64.md5sum stylesheets/md5sum.xsl materials/mips64-chapter.xml
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">

  <xsl:output method="text"/>

  <xsl:template match="/">
    <xsl:apply-templates select="//ulink"/>
  </xsl:template>

  <xsl:template name="filename-basename">
    <!-- We assume all filenames are really URIs and use "/" -->
    <xsl:param name="filename"></xsl:param>
    <xsl:param name="recurse" select="false()"/>

    <xsl:choose>
      <xsl:when test="contains($filename, '/')">
        <xsl:call-template name="filename-basename">
          <xsl:with-param name="filename"
                          select="substring-after($filename, '/')"/>
          <xsl:with-param name="recurse" select="true()"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="contains($filename, '?')">
            <xsl:value-of select="substring-before($filename,'?')"/>
	  </xsl:when>
	  <xsl:otherwise>
            <xsl:value-of select="$filename"/>
	  </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="ulink">
      <!-- Packages. If some package don't have the string ".tar." in their
      name, the next test must be fixed to match it also. -->
    <xsl:if test="contains(@url, '.tar.') or contains(@url, '.tgz')
            or contains(@url, '.patch') and contains(@url, '&patches-root;')
            and not(ancestor-or-self::*/@condition = 'pdf')">
      <xsl:value-of select="../following-sibling::para/literal"/>
      <xsl:text>  </xsl:text>
      <xsl:call-template name="filename-basename">
        <xsl:with-param name="filename" select="@url"/>
        <xsl:with-param name="recurse" select="true()"/>
      </xsl:call-template>
      <xsl:text>&#x0a;</xsl:text>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
