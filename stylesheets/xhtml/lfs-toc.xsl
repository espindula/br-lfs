<?xml version='1.0' encoding='ISO-8859-1'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">
                
		<!-- General settings -->
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
  
  	<!-- Making the TOC -->
	<xsl:template name="make.toc">
    <xsl:param name="toc-context" select="."/>
    <xsl:param name="nodes" select="/NOT-AN-ELEMENT"/>
    <xsl:if test="$nodes">
      <div class="toc">
        <h3>
          <xsl:call-template name="gentext">
            <xsl:with-param name="key">TableofContents</xsl:with-param>
          </xsl:call-template>
        </h3>
        <ul>
          <xsl:apply-templates select="$nodes" mode="toc">
            <xsl:with-param name="toc-context" select="$toc-context"/>
          </xsl:apply-templates>
        </ul>
      </div>
    </xsl:if>
  </xsl:template>
	
    <!-- Making the subtocs -->
  <xsl:template name="subtoc">
    <xsl:param name="toc-context" select="."/>
    <xsl:param name="nodes" select="NOT-AN-ELEMENT"/>
    <xsl:variable name="subtoc">
      <ul>
        <xsl:apply-templates mode="toc" select="$nodes">
          <xsl:with-param name="toc-context" select="$toc-context"/>
        </xsl:apply-templates>
      </ul>
    </xsl:variable>
    <xsl:variable name="depth">
      <xsl:choose>
        <xsl:when test="local-name(.) = 'sect1'">1</xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="depth.from.context"
            select="count(ancestor::*)-count($toc-context/ancestor::*)"/>
    <li class="{name(.)}">
      <xsl:call-template name="toc.line">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:call-template>
      <xsl:if test="$toc.section.depth &gt; $depth and count($nodes)&gt;0 
      				and $toc.max.depth &gt; $depth.from.context">
        <xsl:copy-of select="$subtoc"/>
      </xsl:if>
    </li>
  </xsl:template>

    <!--Adding the h* tags and dropping redundats links-->
  <xsl:template name="toc.line">
    <xsl:param name="toc-context" select="."/>
    <xsl:param name="depth" select="1"/>
    <xsl:param name="depth.from.context" select="8"/>
    <xsl:choose>
      <xsl:when test="local-name(.) = 'sect1'">
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="context" select="$toc-context"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:apply-templates select="." mode="titleabbrev.markup"/>
        </a>
      </xsl:when>
      <xsl:when test="local-name(.) = 'chapter' or local-name(.) = 'preface'">
        <h4>
          <xsl:variable name="label">
            <xsl:apply-templates select="." mode="label.markup"/>
          </xsl:variable>
          <xsl:copy-of select="$label"/>
          <xsl:if test="$label != ''">
            <xsl:value-of select="$autotoc.label.separator"/>
          </xsl:if>
          <xsl:apply-templates select="." mode="titleabbrev.markup"/>
        </h4>
      </xsl:when>
      <xsl:when test="local-name(.) = 'part'">
        <h3>
          <xsl:variable name="label">
            <xsl:apply-templates select="." mode="label.markup"/>
          </xsl:variable>
          <xsl:copy-of select="$label"/>
          <xsl:if test="$label != ''">
            <xsl:value-of select="$autotoc.label.separator"/>
          </xsl:if>
          <xsl:apply-templates select="." mode="titleabbrev.markup"/>
        </h3>
      </xsl:when>
      <xsl:otherwise>
        <h3>
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
        </h3>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
