<?xml version='1.0' encoding='ISO-8859-1'?>

<!-- Version 0.9 - Manuel Canales Esparcia <macana@lfs-es.org> -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

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
      <!-- This should be fixed in the XML code -->
      <!--
      <xsl:when test="contains(text() , 'SBU')">
        <p class="sbu">
          <tt>
            <xsl:value-of select="substring-before(text() , 'R')"/>
            <br/>
            <xsl:value-of select="substring-after(text() , 'U')"/>
          </tt>
        </p>
      </xsl:when>
      -->
      <xsl:otherwise>
        <pre class="{name(.)}">
          <xsl:apply-templates/>
        </pre>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
