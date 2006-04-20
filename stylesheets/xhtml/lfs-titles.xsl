<?xml version='1.0' encoding='ISO-8859-1'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

  <xsl:template name="part.titlepage">
    <div class="titlepage">
      <h1 class="{name(.)}">
        <xsl:apply-templates select="." mode="label.markup"/>
        <xsl:text>. </xsl:text>
        <xsl:value-of select="title"/>
      </h1>
    </div>
  </xsl:template>

  <xsl:template name="chapter.titlepage">
    <div class="titlepage">
      <h1 class="{name(.)}">
        <xsl:apply-templates select="." mode="label.markup"/>
        <xsl:text>. </xsl:text>
        <xsl:value-of select="title"/>
      </h1>
    </div>
  </xsl:template>

  <xsl:template name="preface.titlepage">
    <div class="titlepage">
      <h1 class="{name(.)}">
        <xsl:value-of select="title"/>
      </h1>
    </div>
  </xsl:template>

  <xsl:template name="appendix.titlepage">
    <div class="titlepage">
      <h1 class="{name(.)}">
        <xsl:apply-templates select="." mode="label.markup"/>
        <xsl:text>. </xsl:text>
        <xsl:value-of select="title"/>
      </h1>
    </div>
  </xsl:template>

  <xsl:template name="sect1.titlepage">
    <xsl:choose>
        <!-- I should find a better test -->
      <xsl:when test="position() = 4">
        <div class="titlepage">
          <xsl:if test="@id">
            <a id="{@id}" name="{@id}"/>
          </xsl:if>
          <h2 class="{name(.)}">
            <xsl:apply-templates select="." mode="label.markup"/>
            <xsl:text>. </xsl:text>
            <xsl:value-of select="title"/>
          </h2>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="titlepage">
          <h1 class="{name(.)}">
            <xsl:apply-templates select="." mode="label.markup"/>
            <xsl:text>. </xsl:text>
            <xsl:value-of select="title"/>
          </h1>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="sect2.titlepage">
    <xsl:choose>
      <xsl:when test="string-length(title) = 0"/>
      <xsl:otherwise>
        <div class="titlepage">
          <xsl:if test="@id">
            <a id="{@id}" name="{@id}"/>
          </xsl:if>
          <h2 class="{name(.)}">
            <xsl:if test="not(ancestor::preface)">
              <xsl:apply-templates select="." mode="label.markup"/>
              <xsl:text>. </xsl:text>
            </xsl:if>
            <xsl:value-of select="title"/>
          </h2>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="dedication.titlepage">
    <div class="titlepage">
      <h2 class="{name(.)}">
        <xsl:value-of select="title"/>
      </h2>
    </div>
  </xsl:template>

    <!-- Added the role param for proper punctuation in xref calls. -->
  <xsl:template match="*" mode="insert.title.markup">
    <xsl:param name="purpose"/>
    <xsl:param name="xrefstyle"/>
    <xsl:param name="title"/>
    <xsl:param name="role"/>
    <xsl:choose>
      <xsl:when test="$purpose = 'xref' and titleabbrev">
        <xsl:apply-templates select="." mode="titleabbrev.markup"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$title"/>
        <xsl:value-of select="$role"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
