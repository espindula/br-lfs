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

    <!-- Skip numeraration for sections with empty title -->
  <xsl:template match="sect2|sect3|sect4|sect5" mode="label.markup">
    <xsl:if test="string-length(title) > 0">
      <!-- label the parent -->
      <xsl:variable name="parent.label">
        <xsl:apply-templates select=".." mode="label.markup"/>
      </xsl:variable>
      <xsl:if test="$parent.label != ''">
        <xsl:apply-templates select=".." mode="label.markup"/>
      <xsl:apply-templates select=".." mode="intralabel.punctuation"/>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="@label">
          <xsl:value-of select="@label"/>
        </xsl:when>
        <xsl:when test="$section.autolabel != 0">
          <xsl:choose>
            <xsl:when test="local-name(.) = 'sect2'">
              <xsl:choose>
                <!-- If the first sect2 isn't numbered, renumber the remainig sections -->
                <xsl:when test="string-length(../sect2[1]/title) = 0">
                  <xsl:variable name="totalsect2">
                    <xsl:number count="sect2"/>
                  </xsl:variable>
                  <xsl:number value="$totalsect2 - 1"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:number count="sect2"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="local-name(.) = 'sect3'">
              <xsl:number count="sect3"/>
            </xsl:when>
            <xsl:when test="local-name(.) = 'sect4'">
              <xsl:number count="sect4"/>
            </xsl:when>
            <xsl:when test="local-name(.) = 'sect5'">
              <xsl:number count="sect5"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:message>label.markup: this can't happen!</xsl:message>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!-- Drop the trailing punctuation if title is empty -->
  <xsl:template match="section|sect1|sect2|sect3|sect4|sect5|simplesect
                      |bridgehead"
                mode="object.title.template">
    <xsl:choose>
      <xsl:when test="$section.autolabel != 0">
        <xsl:if test="string-length(title) > 0">
          <xsl:call-template name="gentext.template">
            <xsl:with-param name="context" select="'title-numbered'"/>
            <xsl:with-param name="name">
              <xsl:call-template name="xpath.location"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'title-unnumbered'"/>
          <xsl:with-param name="name">
            <xsl:call-template name="xpath.location"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

    <!-- Header -->
  <xsl:template name="header.content">
    <xsl:param name="sequence" select="''"/>
    <fo:block>
      <xsl:attribute name="text-align">
        <xsl:choose>
          <xsl:when test="$sequence = 'first' or $sequence = 'odd'">right</xsl:when>
          <xsl:otherwise>left</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:value-of select="/book/bookinfo/title"/>
      <xsl:text> - </xsl:text>
      <xsl:value-of select="/book/bookinfo/subtitle"/>
    </fo:block>
  </xsl:template>

  <xsl:template name="header.table">
    <xsl:param name="sequence" select="''"/>
    <xsl:param name="gentext-key" select="''"/>
    <xsl:choose>
      <xsl:when test="$gentext-key = 'book' or $sequence = 'blank'"/>
      <xsl:otherwise>
        <xsl:call-template name="header.content">
          <xsl:with-param name="sequence" select="$sequence"/>
        </xsl:call-template>
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
  <xsl:param name="page.margin.inner">0.5in</xsl:param>
  <xsl:param name="page.margin.outer">0.375in</xsl:param>
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
  
    <!-- Adding space before segmentedlist -->
  <xsl:template match="segmentedlist">
    <xsl:variable name="presentation">
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
      <xsl:otherwise>
        <fo:block space-before.minimum="0.4em" space-before.optimum="0.6em"
                space-before.maximum="0.8em">
          <xsl:apply-templates/>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


</xsl:stylesheet>
