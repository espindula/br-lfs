<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

  <!-- We use FO and FOP as the processor -->
  <xsl:import href="http://docbook.sourceforge.net/release/xsl/1.65.1/fo/docbook.xsl"/>
  <xsl:param name="fop.extensions" select="1"/>
  <xsl:param name="draft.mode" select="'no'"/>
  <!-- Probably want to make the paper size configurable -->
  <xsl:param name="paper.type" select="'A4'"/>

  <!-- Include our customised templates -->
  <xsl:include href="pdf/lfs-index.xsl"/>

  <!-- Font size -->
  <xsl:param name="body.font.master">8</xsl:param>
  <xsl:param name="body.font.size">10pt</xsl:param>

  <!-- Margins -->
  <xsl:param name="page.margin.inner">1in</xsl:param>
  <xsl:param name="page.margin.outer">0.5in</xsl:param>
  <xsl:param name="title.margin.left">-1pc</xsl:param>

  <!-- TOC stuff -->
  <xsl:param name="generate.toc">
    book      toc
    part      nop
  </xsl:param>
  <xsl:param name="toc.section.depth">1</xsl:param>
  <xsl:param name="generate.section.toc.level" select="-1"></xsl:param>
  <xsl:param name="toc.indent.width" select="18"></xsl:param>

  <!-- Force section1's onto a new page -->
  <xsl:attribute-set name="section.level1.properties">
    <xsl:attribute name="break-after">page</xsl:attribute>
  </xsl:attribute-set>

  <!-- Columns in appendix -->
  <xsl:param name="column.count.back" select="2"/>

  <!-- Don't hyphenate -->
  <xsl:param name="hyphenate">false</xsl:param>
  <xsl:param name="alignment">left</xsl:param>

  <!-- Page number in Xref-->
  <xsl:param name="insert.xref.page.number">yes</xsl:param>
  <xsl:template match="xref" name="xref">
    <xsl:variable name="targets" select="key('id',@linkend)"/>
    <xsl:variable name="target" select="$targets[1]"/>
    <xsl:variable name="refelem" select="local-name($target)"/>
    <xsl:call-template name="check.id.unique">
      <xsl:with-param name="linkend" select="@linkend"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="$refelem=''">
        <xsl:message>
          <xsl:text>XRef to nonexistent id: </xsl:text>
          <xsl:value-of select="@linkend"/>
        </xsl:message>
        <xsl:text>???</xsl:text>
      </xsl:when>
      <xsl:when test="@endterm">
        <fo:basic-link internal-destination="{@linkend}"
                       xsl:use-attribute-sets="xref.properties">
          <xsl:variable name="etargets" select="key('id',@endterm)"/>
          <xsl:variable name="etarget" select="$etargets[1]"/>
          <xsl:choose>
            <xsl:when test="count($etarget) = 0">
              <xsl:message>
                <xsl:value-of select="count($etargets)"/>
                <xsl:text>Endterm points to nonexistent ID: </xsl:text>
                <xsl:value-of select="@endterm"/>
              </xsl:message>
              <xsl:text>???</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="$etarget" mode="endterm"/>
            </xsl:otherwise>
          </xsl:choose>
        </fo:basic-link>
      </xsl:when>
      <xsl:when test="$target/@xreflabel">
        <fo:basic-link internal-destination="{@linkend}"
                       xsl:use-attribute-sets="xref.properties">
          <xsl:call-template name="xref.xreflabel">
            <xsl:with-param name="target" select="$target"/>
          </xsl:call-template>
        </fo:basic-link>
      </xsl:when>
      <xsl:otherwise>
        <fo:basic-link internal-destination="{@linkend}"
                       xsl:use-attribute-sets="xref.properties">
          <xsl:apply-templates select="$target" mode="xref-to">
            <xsl:with-param name="referrer" select="."/>
            <xsl:with-param name="xrefstyle">
              <xsl:choose>
                <xsl:when test="@role and not(@xrefstyle) and $use.role.as.xrefstyle != 0">
                  <xsl:value-of select="@role"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="@xrefstyle"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:apply-templates>
        </fo:basic-link>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="not(starts-with(normalize-space(@xrefstyle), 'select:') != ''
                  and (contains(@xrefstyle, 'page')
                   or contains(@xrefstyle, 'Page')))
                  and ( $insert.xref.page.number = 'yes'
                   or $insert.xref.page.number = '1')
                   or local-name($target) = 'para'">
      <fo:basic-link internal-destination="{@linkend}"
                     xsl:use-attribute-sets="xref.properties">
      	<xsl:text>, p. </xsl:text>
        <xsl:apply-templates select="$target" mode="page.citation">
          <xsl:with-param name="id" select="@linkend"/>
        </xsl:apply-templates>
      </fo:basic-link>
    </xsl:if>
  </xsl:template>

  <!-- Prevent duplicate e-mails in the Acknowledgments pages-->
  <xsl:param name="ulink.show" select="0"/>

</xsl:stylesheet>
