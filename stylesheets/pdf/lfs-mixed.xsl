<?xml version='1.0' encoding='ISO-8859-1'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

    <!-- Split URLs -->
  <xsl:template name="hyphenate-url">
    <xsl:param name="url" select="''"/>
    <xsl:choose>
      <xsl:when test="ancestor::varlistentry">
        <xsl:choose>
          <xsl:when test="string-length($url) > 88">
            <xsl:value-of select="substring($url, 1, 50)"/>
            <xsl:param name="rest" select="substring($url, 51)"/>
            <xsl:value-of select="substring-before($rest, '/')"/>
            <xsl:text> /</xsl:text>
            <xsl:value-of select="substring-after($rest, '/')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$url"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$url"/>
      <!--  <xsl:value-of select="substring-before($url, '//')"/>
        <xsl:text>// </xsl:text>
        <xsl:call-template name="split-url">
          <xsl:with-param name="url2" select="substring-after($url, '//')"/>
        </xsl:call-template>-->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--<xsl:template name="split-url">
    <xsl:choose>
      <xsl:when test="contains($url2, '/')">
      <xsl:param name="url2" select="''"/>
      <xsl:value-of select="substring-before($url2, '/')"/>
      <xsl:text> /</xsl:text>
      <xsl:call-template name="split-url">
        <xsl:with-param name="url2" select="substring-after($url2, '/')"/>
      </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$url2"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>-->

    <!-- Shade screen -->
  <xsl:param name="shade.verbatim" select="1"/>

    <!-- Graphics in admonitions -->
  <xsl:param name="admon.graphics" select="1"/>
  <xsl:param name="admon.graphics.path"
    select="'/usr/share/xml/docbook/xsl-stylesheets-1.65.1/images/'"/>

    <!-- Admonition block properties -->
  <xsl:template match="important|warning|caution">
    <xsl:choose>
      <xsl:when test="$admon.graphics != 0">
        <fo:block space-before.minimum="0.4em" space-before.optimum="0.6em"
              space-before.maximum="0.8em" border-style="solid" border-width="1pt"
              border-color="#500" background-color="#FFFFE6">
        <xsl:call-template name="graphical.admonition"/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="nongraphical.admonition"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="note|tip">
    <xsl:choose>
      <xsl:when test="$admon.graphics != 0">
        <fo:block space-before.minimum="0.4em" space-before.optimum="0.6em"
              space-before.maximum="0.8em" border-style="solid" border-width="1pt"
              border-color="#E0E0E0" background-color="#FFFFE6">
        <xsl:call-template name="graphical.admonition"/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="nongraphical.admonition"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
    <!-- Admonitions text properties -->
  <xsl:attribute-set name="admonition.properties">
    <xsl:attribute name="margin-right">6pt</xsl:attribute>
  </xsl:attribute-set>

    <!-- Adding left space to the graphics and color to the titles -->
  <xsl:template name="graphical.admonition">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    <xsl:variable name="graphic.width">
      <xsl:call-template name="admon.graphic.width"/>
    </xsl:variable>
    <fo:block id="{$id}">
      <fo:list-block provisional-distance-between-starts="{$graphic.width} + 18pt"
              provisional-label-separation="18pt" xsl:use-attribute-sets="list.block.spacing">
        <fo:list-item>
            <fo:list-item-label end-indent="label-end()">
              <fo:block margin-left="4pt">
                <fo:external-graphic width="auto" height="auto"
                        content-width="{$graphic.width}" >
                  <xsl:attribute name="src">
                    <xsl:call-template name="admon.graphic"/>
                  </xsl:attribute>
                </fo:external-graphic>
              </fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
              <xsl:if test="$admon.textlabel != 0 or title">
                <fo:block xsl:use-attribute-sets="admonition.title.properties">
                  <xsl:if test="ancestor-or-self::important">
                    <xsl:attribute name="color">#500</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="ancestor-or-self::warning">
                    <xsl:attribute name="color">#500</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="ancestor-or-self::caution">
                    <xsl:attribute name="color">#500</xsl:attribute>
                  </xsl:if>
                  <xsl:apply-templates select="." mode="object.title.markup"/>
                </fo:block>
              </xsl:if>
              <fo:block xsl:use-attribute-sets="admonition.properties">
                <xsl:apply-templates/>
              </fo:block>
            </fo:list-item-body>
        </fo:list-item>
      </fo:list-block>
    </fo:block>
  </xsl:template>

    <!-- How is rendered by default a variablelist -->
  <xsl:param name="variablelist.as.blocks" select="1"/>
  <xsl:param name="variablelist.max.termlength">32</xsl:param>

    <!-- Adding space before segmentedlist -->
  <xsl:template match="segmentedlist">
    <!--<xsl:variable name="presentation">
      <xsl:call-template name="pi-attribute">
        <xsl:with-param name="pis"
                        select="processing-instruction('dbfo')"/>
        <xsl:with-param name="attribute" select="'list-presentation'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$presentation = 'table'">
        <xsl:apply-templates select="." mode="seglist-table"/>
      </xsl:when>
      <xsl:when test="$presentation = 'list'">
        <fo:block space-before.minimum="0.4em" space-before.optimum="0.6em"
                space-before.maximum="0.8em">
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:when test="$segmentedlist.as.table != 0">
        <xsl:apply-templates select="." mode="seglist-table"/>
      </xsl:when>
      <xsl:otherwise>-->
        <fo:block space-before.minimum="0.4em" space-before.optimum="0.6em"
                space-before.maximum="0.8em">
          <xsl:apply-templates/>
        </fo:block>
      <!--</xsl:otherwise>
    </xsl:choose>-->
  </xsl:template>

</xsl:stylesheet>
