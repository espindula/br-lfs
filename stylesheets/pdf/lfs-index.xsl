<?xml version='1.0' encoding='ISO-8859-1'?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY lowercase "'abcdefghijklmnopqrstuvwxyz'">
<!ENTITY uppercase "'ABCDEFGHIJKLMNOPQRSTUVWXYZ'">
<!ENTITY primary   'normalize-space(concat(primary/@sortas, primary[not(@sortas)]))'>
<!ENTITY secondary 'normalize-space(concat(secondary/@sortas, secondary[not(@sortas)]))'>
<!ENTITY scope 'count(ancestor::node()|$scope) = count(ancestor::node())'>
<!ENTITY sep '" "'>
]> 

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

    <!--Only one column to fit the table layout-->
  <xsl:param name="column.count.index" select="1"/>

    <!--Title-->
  <xsl:template match="index" mode="title.markup">
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
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-number="1" column-width="11em"/>
          <fo:table-column column-number="2" column-width="19em"/>
          <fo:table-column column-number="3"/>
          <fo:table-body>
            <xsl:apply-templates select="key('letter', $key)[&scope;]
                                        [count(.|key('primary', &primary;)[&scope;][1])=1]"
                                mode="index-primary">
              <xsl:sort select="translate(&primary;, &lowercase;, &uppercase;)"/>
              <xsl:with-param name="scope" select="$scope"/>
            </xsl:apply-templates>
          </fo:table-body>
        </fo:table>
      </fo:block>
    </xsl:if>
  </xsl:template>

    <!-- Dropping the separator from here -->
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
    <fo:table-row>
      <fo:table-cell>
        <fo:block>
          <xsl:value-of select="primary"/>
          <xsl:text>: </xsl:text>
        </fo:block>
      </fo:table-cell>
      <xsl:for-each select="$refs[not(see) and not(seealso)
                            and not(secondary)]">
        <xsl:apply-templates select="." mode="reference">
          <xsl:with-param name="scope" select="$scope"/>
        </xsl:apply-templates>
      </xsl:for-each>
    </fo:table-row>
    <xsl:if test="$refs/secondary">
      <xsl:apply-templates select="$refs[secondary and count(.|key('secondary',
              concat($key, &sep;, &secondary;))[&scope;][1]) = 1]" mode="index-secondary">
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:sort select="translate(&secondary;, &lowercase;, &uppercase;)"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match="indexterm" mode="index-secondary">
    <xsl:param name="scope" select="."/>
     <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;)"/>
    <xsl:variable name="refs" select="key('secondary', $key)[&scope;]"/>
    <fo:table-row>
      <fo:table-cell>
        <fo:block start-indent="1pc">
          <xsl:value-of select="secondary"/>
          <xsl:text>: </xsl:text>
        </fo:block>
      </fo:table-cell>
      <xsl:for-each select="$refs[not(see) and not(seealso) and not(tertiary)]">
        <xsl:apply-templates select="." mode="reference">
          <xsl:with-param name="scope" select="$scope"/>
        </xsl:apply-templates>
      </xsl:for-each>
    </fo:table-row>
  </xsl:template>
  
    <!-- Targets titles and bookmarks-->
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
        <fo:table-cell>
          <fo:block>
            <fo:basic-link internal-destination="{$id}">
              <xsl:value-of select="$target/title"/>
              <xsl:apply-templates select="$target" mode="page.citation">
                <xsl:with-param name="id" select="$id"/>
              </xsl:apply-templates>
            </fo:basic-link>
          </fo:block>
        </fo:table-cell>
        <fo:table-cell>
          <fo:block>
            <fo:basic-link internal-destination="{$id2}">
              <xsl:text>description</xsl:text>
              <xsl:apply-templates select="$target2" mode="page.citation">
                <xsl:with-param name="id" select="$id2"/>
              </xsl:apply-templates>
            </fo:basic-link>
          </fo:block>
        </fo:table-cell>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="zone" select="$zones"/>
        <xsl:variable name="target" select="key('id', $zone)[&scope;]"/>
        <xsl:variable name="id">
          <xsl:call-template name="object.id">
            <xsl:with-param name="object" select="$target[1]"/>
          </xsl:call-template>
        </xsl:variable>
        <fo:table-cell>
          <fo:block>
            <fo:basic-link internal-destination="{$id}">
              <xsl:value-of select="$target/title"/>
              <xsl:apply-templates select="$target" mode="page.citation">
                <xsl:with-param name="id" select="$id"/>
              </xsl:apply-templates>
            </fo:basic-link>
          </fo:block>
        </fo:table-cell>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
