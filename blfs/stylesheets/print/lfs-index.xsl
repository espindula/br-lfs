<?xml version='1.0' encoding='ISO-8859-1'?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY lowercase "'abcdefghijklmnopqrstuvwxyz'">
<!ENTITY uppercase "'ABCDEFGHIJKLMNOPQRSTUVWXYZ'">
<!ENTITY primary   'normalize-space(concat(primary/@sortas, primary[not(@sortas)]))'>
<!ENTITY scope 'count(ancestor::node()|$scope) = count(ancestor::node())'>
]> 

<!-- Version 0.9 - Manuel Canales Esparcia <macana@lfs-es.org> -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

    <!--Title-->
  <xsl:template match="index" mode="title.markup">
  	<xsl:param name="allow-anchors" select="0"/>
    <xsl:text>Index of packages and important installed files</xsl:text>
	</xsl:template>

  	<!-- Divisions-->
  <xsl:template match="indexterm" mode="index-div">
    <xsl:param name="scope" select="."/>
    <xsl:variable name="key"
                  select="translate(substring(&primary;, 1, 1),&lowercase;,&uppercase;)"/>
    <xsl:variable name="divtitle" select="translate($key, &lowercase;, &uppercase;)"/>
    <xsl:if test="key('letter', $key)[&scope;]
                  [count(.|key('primary', &primary;)[&scope;][1]) = 1]">
      <fo:block>
        <xsl:if test="contains(concat(&lowercase;, &uppercase;), $key)">
          <xsl:call-template name="indexdiv.title">
            <xsl:with-param name="titlecontent">
              <xsl:choose>
                <xsl:when test="$divtitle = 'A'">
                  <xsl:text>Paquetages</xsl:text>
              </xsl:when>
              <xsl:when test="$divtitle = 'B'">
                  <xsl:text>Programmes</xsl:text>
              </xsl:when>
              <xsl:when test="$divtitle = 'C'">
                  <xsl:text>Biblioth�ques</xsl:text>
              </xsl:when>
              <xsl:when test="$divtitle = 'D'">
                  <xsl:text>Scripts</xsl:text>
              </xsl:when>
              <xsl:when test="$divtitle = 'E'">
                  <xsl:text>Autres</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$divtitle"/>
              </xsl:otherwise>
            </xsl:choose>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        <fo:block>
          <xsl:apply-templates select="key('letter', $key)[&scope;]
                                      [count(.|key('primary', &primary;)[&scope;][1])=1]"
                              mode="index-primary">
            <xsl:sort select="translate(&primary;, &lowercase;, &uppercase;)"/>
            <xsl:with-param name="scope" select="$scope"/>
          </xsl:apply-templates>
        </fo:block>
      </fo:block>
    </xsl:if>
  </xsl:template>

  	<!-- The separator -->
  <xsl:template match="indexterm" mode="reference">
    <xsl:param name="scope" select="."/>
    <xsl:text>:   </xsl:text>
    	<xsl:call-template name="reference">
        <xsl:with-param name="zones" select="normalize-space(@zone)"/>
        <xsl:with-param name="scope" select="$scope"/>
      </xsl:call-template>
  </xsl:template>
  
  	<!--Bookmarks-->
  <xsl:template name="reference">
    <xsl:param name="scope" select="."/>
    <xsl:param name="zones"/>
    <xsl:choose>
      <xsl:when test="contains($zones, ' ')">
        <xsl:variable name="zone" select="substring-before($zones, ' ')"/>
        <xsl:variable name="zone2" select="substring-after($zones, ' ')"/>
        <xsl:variable name="target" select="key('id', $zone)[&scope;]"/>
        <xsl:variable name="target2" select="key('id', $zone2)[&scope;]"/>
        <xsl:variable name="id">
          <xsl:call-template name="object.id">
            <xsl:with-param name="object" select="$target[1]"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="id2">
          <xsl:call-template name="object.id">
            <xsl:with-param name="object" select="$target2[1]"/>
          </xsl:call-template>
        </xsl:variable>
        <fo:basic-link internal-destination="{$id}">
          <xsl:apply-templates select="$target" mode="page.citation">
          	<xsl:with-param name="id" select="$id"/>
          </xsl:apply-templates>
        </fo:basic-link>
          <xsl:text> ,  </xsl:text>
        <fo:basic-link internal-destination="{$id2}">
          <xsl:apply-templates select="$target2" mode="page.citation">
          	<xsl:with-param name="id" select="$id2"/>
          </xsl:apply-templates>
        </fo:basic-link>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="zone" select="$zones"/>
        <xsl:variable name="target" select="key('id', $zone)[&scope;]"/>
        <xsl:variable name="id">
          <xsl:call-template name="object.id">
            <xsl:with-param name="object" select="$target[1]"/>
          </xsl:call-template>
        </xsl:variable>
        <fo:basic-link internal-destination="{$id}">
          <xsl:apply-templates select="$target" mode="page.citation">
          	<xsl:with-param name="id" select="$id"/>
          </xsl:apply-templates>
        </fo:basic-link>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
