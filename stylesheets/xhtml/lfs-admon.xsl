<?xml version='1.0' encoding='ISO-8859-1'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

    <!-- Use graphics in admonitions -->
  <xsl:param name="admon.graphics" select="1"/>
  <xsl:param name="admon.graphics.path">../images/</xsl:param>
  <xsl:param name="admon.graphics.extension" select="'.png'"/>

    <!-- Changing the output tagging -->
  <xsl:template name="graphical.admonition">
    <xsl:variable name="admon.type">
      <xsl:choose>
        <xsl:when test="local-name(.)='note'">Note</xsl:when>
        <xsl:when test="local-name(.)='warning'">Warning</xsl:when>
        <xsl:when test="local-name(.)='caution'">Caution</xsl:when>
        <xsl:when test="local-name(.)='tip'">Tip</xsl:when>
        <xsl:when test="local-name(.)='important'">Important</xsl:when>
        <xsl:otherwise>Note</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <div class="admonition">
      <div class ="admonhead">
        <img alt="[{$admon.type}]">
          <xsl:attribute name="src">
            <xsl:call-template name="admon.graphic"/>
          </xsl:attribute>
        </img>
        <h3 class="{name(.)}">
          <xsl:value-of select="$admon.type"/>
          <xsl:if test="title">
            <xsl:text>: </xsl:text>
            <xsl:value-of select="title"/>
          </xsl:if>
        </h3>
      </div>
      <div class="admonbody">
        <xsl:apply-templates/>
      </div>
    </div>
  </xsl:template>

</xsl:stylesheet>
