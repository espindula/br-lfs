<?xml version='1.0' encoding='ISO-8859-1'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

    <!-- Force section1's onto a new page -->
  <xsl:attribute-set name="section.level1.properties">
    <xsl:attribute name="break-after">
      <xsl:choose>
        <xsl:when test="not(position()=last())">
          <xsl:text>page</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>auto</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:attribute-set>

    <!-- Header -->
  <xsl:attribute-set name="header.content.properties">
    <xsl:attribute name="font-family">
      <xsl:value-of select="$body.fontset"/>
    </xsl:attribute>
    <xsl:attribute name="text-align">right</xsl:attribute>
  </xsl:attribute-set>

  <xsl:template name="header.content">
    <xsl:value-of select="/book/bookinfo/title"/>
    <xsl:text> - </xsl:text>
    <xsl:value-of select="/book/bookinfo/subtitle"/>
  </xsl:template>

  <xsl:template name="header.table">
    <xsl:param name="gentext-key" select="''"/>
    <xsl:choose>
      <xsl:when test="$gentext-key = 'book'"/>
      <xsl:otherwise>
        <xsl:call-template name="header.content"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

    <!-- Centered titles for book and part -->
  <xsl:template name="book.titlepage">
    <fo:block space-before="2in">
      <fo:block>
        <xsl:call-template name="book.titlepage.before.recto"/>
        <xsl:call-template name="book.titlepage.recto"/>
      </fo:block>
      <fo:block>
        <xsl:call-template name="book.titlepage.before.verso"/>
        <xsl:call-template name="book.titlepage.verso"/>
      </fo:block>
      <xsl:call-template name="book.titlepage.separator"/>
    </fo:block>
  </xsl:template>

  <xsl:template name="part.titlepage">
    <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format">
      <fo:block space-before="2.5in">
        <xsl:call-template name="part.titlepage.before.recto"/>
        <xsl:call-template name="part.titlepage.recto"/>
      </fo:block>
      <fo:block>
        <xsl:call-template name="part.titlepage.before.verso"/>
        <xsl:call-template name="part.titlepage.verso"/>
      </fo:block>
      <xsl:call-template name="part.titlepage.separator"/>
    </fo:block>
  </xsl:template>

    <!-- Margins -->
  <xsl:param name="page.margin.inner">0.75in</xsl:param>
  <xsl:param name="page.margin.outer">0.75in</xsl:param>
  <xsl:param name="title.margin.left">-1pc</xsl:param>
  <xsl:attribute-set name="normal.para.spacing">
    <xsl:attribute name="space-before.optimum">0.8em</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0.6em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">1em</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="list.block.spacing">
    <xsl:attribute name="space-before.optimum">0.8em</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0.6em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">1em</xsl:attribute>
    <xsl:attribute name="space-after.optimum">0.8em</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0.6em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">1em</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="list.item.spacing">
    <xsl:attribute name="space-before.optimum">0.6em</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0.4em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">0.8em</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="verbatim.properties">
    <xsl:attribute name="space-before.minimum">0.6em</xsl:attribute>
    <xsl:attribute name="space-before.optimum">0.8em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">1em</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0.6em</xsl:attribute>
    <xsl:attribute name="space-after.optimum">0.8em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">1em</xsl:attribute>
  </xsl:attribute-set>

    <!-- Others-->
  <xsl:param name="header.rule" select="0"></xsl:param>
  <xsl:param name="footer.rule" select="0"></xsl:param>
  <xsl:param name="marker.section.level" select="-1"></xsl:param>

    <!-- Dropping a blank page -->
  <xsl:template name="book.titlepage.separator"/>

    <!-- How render a variablelist -->
  <xsl:param name="variablelist.as.blocks" select="1"/>

</xsl:stylesheet>
