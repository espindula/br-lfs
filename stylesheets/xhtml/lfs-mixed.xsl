<?xml version='1.0' encoding='ISO-8859-1'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

    <!-- screen -->
  <xsl:template match="screen">
    <xsl:choose>
      <xsl:when test="child::* = userinput">
        <pre class="userinput">
            <xsl:apply-templates/>
        </pre>
      </xsl:when>
      <xsl:otherwise>
        <pre class="{name(.)}">
          <xsl:apply-templates/>
        </pre>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="userinput">
    <xsl:choose>
      <xsl:when test="ancestor::screen">
        <kbd class="command">
          <xsl:apply-templates/>
        </kbd>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-imports/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  
  <!-- variablelist -->
  <xsl:template match="variablelist">
    <div class="{name(.)}">
      <xsl:if test="title | bridgehead">
        <xsl:choose>
          <xsl:when test="@role = 'materials'">
            <h2>
              <xsl:value-of select="title | bridgehead"/>
            </h2>
          </xsl:when>
          <xsl:otherwise>
            <h3>
              <xsl:value-of select="title | bridgehead"/>
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

    <!-- External URLs in italic font -->
  <xsl:template match="ulink" name="ulink">
    <a>
      <xsl:if test="@id">
        <xsl:attribute name="id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
       <i>
        <xsl:choose>
          <xsl:when test="count(child::node())=0">
            <xsl:value-of select="@url"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </i>
    </a>
  </xsl:template>


</xsl:stylesheet>
