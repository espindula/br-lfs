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
    	<h3>
      	<xsl:value-of select="title"/>
    	</h3>
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
</xsl:stylesheet>
