<?xml version='1.0' encoding='ISO-8859-1'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

    <!-- screen -->
  <xsl:template match="screen">
    <xsl:choose>
        <!-- Temporally hack -->
      <xsl:when test="child::* = userinput">
        <pre class="{name(.)}">
          <kbd class="command">
            <xsl:value-of select="."/>
          </kbd>
        </pre>
      </xsl:when>
      <xsl:otherwise>
        <pre class="{name(.)}">
          <xsl:apply-templates/>
        </pre>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- variablelist -->
  <xsl:template match="variablelist">
    <div class="{name(.)}">
      <xsl:if test="title">
        <xsl:choose>
          <xsl:when test="@role = 'materials'">
            <h2>
              <xsl:value-of select="title"/>
            </h2>
          </xsl:when>
          <xsl:otherwise>
            <h3>
              <xsl:value-of select="title"/>
            </h3>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <dl>
        <xsl:if test="@role">
          <xsl:attribute name="class">
            <xsl:value-of select="@role"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:apply-templates select="varlistentry"/>
      </dl>
    </div>
  </xsl:template>

    <!-- Body attributes -->
  <xsl:template name="body.attributes">
    <xsl:attribute name="id">
      <xsl:text>lfs</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="class">
      <xsl:value-of select="substring-after(/book/bookinfo/subtitle, ' ')"/>
    </xsl:attribute>
  </xsl:template>

   <!-- Sect1 attributes -->
  <xsl:template match="sect1">
    <div>
      <xsl:choose>
        <xsl:when test="@role">
          <xsl:attribute name="class">
            <xsl:value-of select="@role"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">
            <xsl:value-of select="name(.)"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="language.attribute"/>
      <xsl:call-template name="sect1.titlepage"/>
      <xsl:apply-templates/>
      <xsl:call-template name="process.chunk.footnotes"/>
    </div>
  </xsl:template>

    <!-- Sect2 attributes -->
  <xsl:template match="sect2">
    <div>
      <xsl:choose>
        <xsl:when test="@role">
          <xsl:attribute name="class">
            <xsl:value-of select="@role"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">
            <xsl:value-of select="name(.)"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="language.attribute"/>
      <xsl:call-template name="sect2.titlepage"/>
      <xsl:apply-templates/>
      <xsl:call-template name="process.chunk.footnotes"/>
    </div>
  </xsl:template>

</xsl:stylesheet>
