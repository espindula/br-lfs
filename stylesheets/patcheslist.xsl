<?xml version='1.0' encoding='ISO-8859-1'?>

<!-- This also work again BLFS -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:output method="text"/>

  <xsl:template match="//text()">
    <xsl:text/>
  </xsl:template>

  <xsl:template match="//ulink">
    <xsl:if test="contains(@url, '.patch')">
      <xsl:value-of select="@url"/>
      <xsl:text>&#x0a;</xsl:text>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
