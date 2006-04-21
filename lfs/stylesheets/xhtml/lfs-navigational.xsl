<?xml version='1.0' encoding='ISO-8859-1'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

    <!-- Dropping the HEAD links -->
  <xsl:template name="html.head">
    <head>
      <xsl:call-template name="system.head.content"/>
      <xsl:call-template name="head.content"/>
      <xsl:call-template name="user.head.content"/>
    </head>
  </xsl:template>

    <!-- Header Navigation-->
  <xsl:template name="header.navigation">
    <xsl:param name="prev" select="/foo"/>
    <xsl:param name="next" select="/foo"/>
    <xsl:param name="nav.context"/>
    <xsl:variable name="home" select="/*[1]"/>
    <xsl:variable name="up" select="parent::*"/>
    <xsl:variable name="row" select="count($prev) &gt; 0 or (count($up) &gt; 0
            and generate-id($up) != generate-id($home)) or count($next) &gt; 0"/>
    <xsl:if test="$row and $home != .">
      <div class="navheader">
        <xsl:if test="$home != .">
          <div class="headertitles">
            <h4>
              <xsl:apply-templates select="$home" mode="object.title.markup"/>
              <xsl:text> - </xsl:text>
              <xsl:apply-templates select="$home" mode="object.subtitle.markup"/>
            </h4>
            <xsl:if test="$up != $home">
              <h3>
                <xsl:apply-templates select="$up" mode="object.title.markup"/>
              </h3>
            </xsl:if>
          </div>
        </xsl:if>
        <ul class="headerlinks">
          <xsl:if test="count($prev)&gt;0 and $prev != $home">
            <li class="prev">
              <a accesskey="p">
                <xsl:attribute name="href">
                  <xsl:call-template name="href.target">
                    <xsl:with-param name="object" select="$prev"/>
                  </xsl:call-template>
                </xsl:attribute>
                <xsl:attribute name="title">
                  <xsl:value-of select="$prev/title"/>
                </xsl:attribute>
                <xsl:call-template name="navig.content">
                  <xsl:with-param name="direction" select="'prev'"/>
                </xsl:call-template>
              </a>
              <p>
                <xsl:value-of select="$prev/title"/>
              </p>
            </li>
          </xsl:if>
          <xsl:if test="count($next)&gt;0">
            <li class="next">
              <a accesskey="n">
                <xsl:attribute name="href">
                  <xsl:call-template name="href.target">
                    <xsl:with-param name="object" select="$next"/>
                  </xsl:call-template>
                </xsl:attribute>
                <xsl:attribute name="title">
                  <xsl:choose>
                    <xsl:when test="local-name($next)='index'">
                      <xsl:call-template name="gentext">
                        <xsl:with-param name="key">Index</xsl:with-param>
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$next/title"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:call-template name="navig.content">
                  <xsl:with-param name="direction" select="'next'"/>
                </xsl:call-template>
              </a>
              <p>
                <xsl:choose>
                  <xsl:when test="local-name($next)='index'">
                    <xsl:call-template name="gentext">
                      <xsl:with-param name="key">Index</xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$next/title"/>
                  </xsl:otherwise>
                </xsl:choose>
              </p>
            </li>
          </xsl:if>
            <li class="up">
              <xsl:if test="count($up)&gt;0 and $up != $home">
                <a accesskey="u">
                  <xsl:attribute name="href">
                    <xsl:call-template name="href.target">
                      <xsl:with-param name="object" select="$up"/>
                    </xsl:call-template>
                  </xsl:attribute>
                  <xsl:attribute name="title">
                    <xsl:apply-templates select="$up" mode="object.title.markup"/>
                  </xsl:attribute>
                  <xsl:call-template name="navig.content">
                    <xsl:with-param name="direction" select="'up'"/>
                  </xsl:call-template>
                </a>
              </xsl:if>
              <xsl:text>.</xsl:text>
            </li>
          <li class="home">
            <a accesskey="h">
              <xsl:attribute name="href">
                <xsl:call-template name="href.target">
                  <xsl:with-param name="object" select="$home"/>
                </xsl:call-template>
              </xsl:attribute>
                <xsl:attribute name="title">
                  <xsl:value-of select="$home/bookinfo/title"/>
                  <xsl:text> - </xsl:text>
                  <xsl:value-of select="$home/bookinfo/subtitle"/>
                </xsl:attribute>
                <xsl:call-template name="navig.content">
                  <xsl:with-param name="direction" select="'home'"/>
                </xsl:call-template>
            </a>
          </li>
        </ul>
      </div>
    </xsl:if>
  </xsl:template>

    <!-- Footer Navigation-->
  <xsl:template name="footer.navigation">
    <xsl:param name="prev" select="/foo"/>
    <xsl:param name="next" select="/foo"/>
    <xsl:param name="nav.context"/>
    <xsl:variable name="home" select="/*[1]"/>
    <xsl:variable name="up" select="parent::*"/>
    <xsl:variable name="row" select="count($prev) &gt; 0 or count($up) &gt; 0
            or count($next) &gt; 0 or generate-id($home) != generate-id(.)"/>
    <xsl:if test="$row">
      <div class="navfooter">
        <ul>
          <xsl:if test="count($prev)&gt;0 and $prev != $home">
            <li class="prev">
              <a accesskey="p">
                <xsl:attribute name="href">
                  <xsl:call-template name="href.target">
                    <xsl:with-param name="object" select="$prev"/>
                  </xsl:call-template>
                </xsl:attribute>
                <xsl:attribute name="title">
                  <xsl:value-of select="$prev/title"/>
                </xsl:attribute>
                <xsl:call-template name="navig.content">
                  <xsl:with-param name="direction" select="'prev'"/>
                </xsl:call-template>
              </a>
              <p>
                <xsl:value-of select="$prev/title"/>
              </p>
            </li>
          </xsl:if>
          <xsl:if test="count($next)&gt;0">
            <li class="next">
              <a accesskey="n">
                <xsl:attribute name="href">
                  <xsl:call-template name="href.target">
                    <xsl:with-param name="object" select="$next"/>
                  </xsl:call-template>
                </xsl:attribute>
                <xsl:attribute name="title">
                  <xsl:choose>
                    <xsl:when test="local-name($next)='index'">
                      <xsl:call-template name="gentext">
                        <xsl:with-param name="key">Index</xsl:with-param>
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$next/title"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:call-template name="navig.content">
                  <xsl:with-param name="direction" select="'next'"/>
                </xsl:call-template>
              </a>
              <p>
                <xsl:choose>
                  <xsl:when test="local-name($next)='index'">
                    <xsl:call-template name="gentext">
                      <xsl:with-param name="key">Index</xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$next/title"/>
                  </xsl:otherwise>
                </xsl:choose>
              </p>
            </li>
          </xsl:if>
            <li class="up">
              <xsl:if test="count($up)&gt;0 and $up != $home">
                <a accesskey="u">
                  <xsl:attribute name="href">
                    <xsl:call-template name="href.target">
                      <xsl:with-param name="object" select="$up"/>
                    </xsl:call-template>
                  </xsl:attribute>
                  <xsl:attribute name="title">
                    <xsl:apply-templates select="$up" mode="object.title.markup"/>
                  </xsl:attribute>
                  <xsl:call-template name="navig.content">
                    <xsl:with-param name="direction" select="'up'"/>
                  </xsl:call-template>
                </a>
              </xsl:if>
              <xsl:text>.</xsl:text>
            </li>
            <li class="home">
              <xsl:if  test="$home != .">
                <a accesskey="h">
                  <xsl:attribute name="href">
                    <xsl:call-template name="href.target">
                      <xsl:with-param name="object" select="$home"/>
                    </xsl:call-template>
                  </xsl:attribute>
                  <xsl:attribute name="title">
                    <xsl:value-of select="$home/bookinfo/title"/>
                    <xsl:text> - </xsl:text>
                    <xsl:value-of select="$home/bookinfo/subtitle"/>
                  </xsl:attribute>
                  <xsl:call-template name="navig.content">
                    <xsl:with-param name="direction" select="'home'"/>
                  </xsl:call-template>
                </a>
              </xsl:if>
              <xsl:text>.</xsl:text>
            </li>
        </ul>
      </div>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>


