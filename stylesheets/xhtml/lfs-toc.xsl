<?xml version='1.0' encoding='ISO-8859-1'?>

<!-- Version 0.8.0 - Manuel Canales Esparcia <macana@lfs-es.org> -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">


<!--TOC stuff-->
  <xsl:param name="generate.toc">
    appendix  toc
    book      toc,title,figure,table,example,equation
    chapter   nop
    part      toc
    preface   nop
    qandadiv  nop
    qandaset  nop
    reference nop
    sect1     nop
    sect2     nop
    sect3     nop
    sect4     nop
    sect5     nop
    section   nop
    set       nop
  </xsl:param>

  <xsl:param name="toc.section.depth">1</xsl:param>

  <xsl:param name="toc.max.depth">3</xsl:param>

    <!-- Type of list-->
  <xsl:param name="toc.list.type">ul</xsl:param>

    <!--Adding the h* tags and dropping redundats links-->
  <xsl:template name="toc.line">
    <xsl:param name="toc-context" select="."/>
    <xsl:param name="depth" select="1"/>
    <xsl:param name="depth.from.context" select="8"/>
    <xsl:choose>
      <xsl:when test="local-name(.) = 'sect1'">
        <span>
          <xsl:attribute name="class"><xsl:value-of select="local-name(.)"/></xsl:attribute>
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="context" select="$toc-context"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:apply-templates select="." mode="titleabbrev.markup"/>
          </a>
        </span>
      </xsl:when>
      <xsl:when test="local-name(.) = 'chapter' or local-name(.) = 'preface'">
        <h4>
          <span>
            <xsl:attribute name="class"><xsl:value-of select="local-name(.)"/></xsl:attribute>
            <xsl:variable name="label">
              <xsl:apply-templates select="." mode="label.markup"/>
            </xsl:variable>
            <xsl:copy-of select="$label"/>
            <xsl:if test="$label != ''">
              <xsl:value-of select="$autotoc.label.separator"/>
            </xsl:if>
            <xsl:apply-templates select="." mode="titleabbrev.markup"/>
          </span>
        </h4>
      </xsl:when>
      <xsl:when test="local-name(.) = 'part'">
        <h3>
          <span>
            <xsl:attribute name="class"><xsl:value-of select="local-name(.)"/></xsl:attribute>
            <xsl:variable name="label">
              <xsl:apply-templates select="." mode="label.markup"/>
            </xsl:variable>
            <xsl:copy-of select="$label"/>
            <xsl:if test="$label != ''">
              <xsl:value-of select="$autotoc.label.separator"/>
            </xsl:if>
            <xsl:apply-templates select="." mode="titleabbrev.markup"/>
          </span>
        </h3>
      </xsl:when>
      <xsl:otherwise>
        <h3>
          <span>
            <xsl:attribute name="class"><xsl:value-of select="local-name(.)"/></xsl:attribute>
            <a>
              <xsl:attribute name="href">
                <xsl:call-template name="href.target">
                  <xsl:with-param name="context" select="$toc-context"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:variable name="label">
                <xsl:apply-templates select="." mode="label.markup"/>
              </xsl:variable>
              <xsl:copy-of select="$label"/>
              <xsl:if test="$label != ''">
                <xsl:value-of select="$autotoc.label.separator"/>
              </xsl:if>
              <xsl:apply-templates select="." mode="titleabbrev.markup"/>
            </a>
          </span>
        </h3>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
