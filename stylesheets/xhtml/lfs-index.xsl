<?xml version='1.0' encoding='ISO-8859-1'?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY lowercase "'abcdefghijklmnopqrstuvwxyz'">
<!ENTITY uppercase "'ABCDEFGHIJKLMNOPQRSTUVWXYZ'">
<!ENTITY primary   'normalize-space(concat(primary/@sortas, primary[not(@sortas)]))'>
<!ENTITY scope 'count(ancestor::node()|$scope) = count(ancestor::node())'>
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

    <!--Filename-->
  <xsl:template match="index" mode="recursive-chunk-filename">
    <xsl:text>longindex.html</xsl:text>
  </xsl:template>

    <!--Title-->
  <xsl:param name="index-title">Index of packages and important installed files</xsl:param>
  
  <xsl:template match="index" mode="title.markup">
    <xsl:value-of select="$index-title"/>
	</xsl:template>
  
  <xsl:template name="index.titlepage">
    <div class="titlepage">
    	<h1 class="index">
    		<xsl:value-of select="$index-title"/>
			</h1>
    </div>
  </xsl:template>

  	<!--Divisions-->
  <xsl:template match="indexterm" mode="index-div">
    <xsl:param name="scope" select="."/>
    <xsl:variable name="key" select="translate(substring(&primary;, 1, 1),&lowercase;,&uppercase;)"/>
    <xsl:variable name="divtitle" select="translate($key, &lowercase;, &uppercase;)"/>
    	<!-- Make sure that we don't generate a div if there are no terms in scope -->
    <xsl:if test="key('letter', $key)[&scope;] [count(.|key('primary', &primary;)[&scope;][1]) = 1]">
      <div class="indexdiv">
        <xsl:if test="contains(concat(&lowercase;, &uppercase;), $key)">
          <h2>
          	<xsl:choose>
            	<xsl:when test="$divtitle = 'A'">
              	<xsl:text>Packages</xsl:text>
             </xsl:when>
             <xsl:when test="$divtitle = 'B'">
              	<xsl:text>Programs</xsl:text>
             </xsl:when>
             <xsl:when test="$divtitle = 'C'">
              	<xsl:text>Libraries</xsl:text>
             </xsl:when>
             <xsl:when test="$divtitle = 'D'">
              	<xsl:text>Scripts</xsl:text>
             </xsl:when>
              <xsl:when test="$divtitle = 'E'">
                  <xsl:text>Others</xsl:text>
              </xsl:when>
             <xsl:otherwise>
          		<xsl:value-of select="$divtitle"/>
						</xsl:otherwise>
           </xsl:choose>
          </h2>
        </xsl:if>
        <ul>
          <xsl:apply-templates select="key('letter', $key)[&scope;]
          				[count(.|key('primary', &primary;)[&scope;][1])=1]" mode="index-primary">
            <xsl:with-param name="scope" select="$scope"/>
            <xsl:sort select="translate(&primary;, &lowercase;, &uppercase;)"/>
          </xsl:apply-templates>
        </ul>
      </div>
    </xsl:if>
  </xsl:template>

  	<!-- Dropping the separator from here-->
  <xsl:template match="indexterm" mode="reference">
    <xsl:param name="scope" select="."/>
      <xsl:call-template name="reference">
        <xsl:with-param name="zones" select="normalize-space(@zone)"/>
        <xsl:with-param name="scope" select="$scope"/>
      </xsl:call-template>
	</xsl:template>

  	<!-- Changing the output tags and re-addind the separator-->
  <xsl:template match="indexterm" mode="index-primary">
    <xsl:param name="scope" select="."/>
    <xsl:variable name="key" select="&primary;"/>
    <xsl:variable name="refs" select="key('primary', $key)[&scope;]"/>
    <li>
    	<strong class="item">
      	<xsl:value-of select="primary"/>
        <xsl:text>: </xsl:text>
			</strong>
      <xsl:for-each select="$refs[generate-id() = generate-id(key('primary-section',
      				concat($key, &#34; &#34;, generate-id((ancestor-or-self::book |ancestor-or-self::part
              |ancestor-or-self::chapter |ancestor-or-self::appendix |ancestor-or-self::preface
              |ancestor-or-self::sect1 |ancestor-or-self::sect2 |ancestor-or-self::sect3
              |ancestor-or-self::sect4 |ancestor-or-self::sect5 |ancestor-or-self::index)[last()])))[&scope;][1])]">
        <xsl:apply-templates select="." mode="reference">
          <xsl:with-param name="scope" select="$scope"/>
        </xsl:apply-templates>
      </xsl:for-each>
    	<xsl:if test="$refs/secondary">
        <ul>
          <xsl:apply-templates select="$refs[secondary and count(.|key('secondary', 
          				concat($key, &#34; &#34;, normalize-space(concat(secondary/@sortas,
                  secondary[not(@sortas)]))))[&scope;][1]) = 1]" mode="index-secondary">
            <xsl:with-param name="scope" select="$scope"/>
            <xsl:sort select="translate(normalize-space(concat(secondary/@sortas, 
            				secondary[not(@sortas)])), &lowercase;, &uppercase;)"/>
          </xsl:apply-templates>
     		</ul>
    	</xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="indexterm" mode="index-secondary">
    <xsl:param name="scope" select="."/>
    <xsl:variable name="key" select="concat(&primary;, &#34; &#34;,
    				normalize-space(concat(secondary/@sortas, secondary[not(@sortas)])))"/>
    <xsl:variable name="refs" select="key('secondary', $key)[&scope;]"/>
    <li>
    	<strong class="secitem">
      	<xsl:value-of select="secondary"/>
        <xsl:text>: </xsl:text>
			</strong>
      <xsl:for-each select="$refs[generate-id() = generate-id(key('secondary-section',
      				concat($key, &#34; &#34;, generate-id((ancestor-or-self::book |ancestor-or-self::part
              |ancestor-or-self::chapter |ancestor-or-self::appendix |ancestor-or-self::preface
              |ancestor-or-self::sect1 |ancestor-or-self::sect2 |ancestor-or-self::sect3
              |ancestor-or-self::sect4 |ancestor-or-self::sect5 |ancestor-or-self::index)[last()])))[&scope;][1])]">
        <xsl:apply-templates select="." mode="reference">
          <xsl:with-param name="scope" select="$scope"/>
        </xsl:apply-templates>
      </xsl:for-each>
    </li>
  </xsl:template>

    <!--Links (This template also fix a bug in the original code)-->
  <xsl:template name="reference">
    <xsl:param name="scope" select="."/>
    <xsl:param name="zones"/>
    <xsl:choose>
      <xsl:when test="contains($zones, ' ')">
        <xsl:variable name="zone" select="substring-before($zones, ' ')"/>
        <xsl:variable name="zone2" select="substring-after($zones, ' ')"/>
        <xsl:variable name="target" select="key('sections', $zone)[&scope;]"/>
        <xsl:variable name="target2" select="key('sections', $zone2)[&scope;]"/>
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="href.target.uri">
              <xsl:with-param name="object" select="$target[1]"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:apply-templates select="$target[1]" mode="index-title-content"/>
        </a>
        <xsl:text> -- </xsl:text>
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="href.target.uri">
              <xsl:with-param name="object" select="$target2[1]"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>description</xsl:text>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="zone" select="$zones"/>
        <xsl:variable name="target" select="key('sections', $zone)[&scope;]"/>
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="href.target.uri">
              <xsl:with-param name="object" select="$target[1]"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:apply-templates select="$target[1]" mode="index-title-content"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
    <!-- Dropping unneeded anchors -->
  <xsl:template match="indexterm"/>

</xsl:stylesheet>
