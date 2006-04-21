<?xml version='1.0' encoding='ISO-8859-1'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

    <!-- Generating the page -->
  <xsl:template match="legalnotice" mode="titlepage.mode">
    <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>
      <xsl:variable name="filename" select="concat($base.dir, 'prologue/legalnotice.html')"/>
    <xsl:variable name="title">
      <xsl:apply-templates select="." mode="title.markup"/>
    </xsl:variable>
    <xsl:call-template name="write.chunk">
      <xsl:with-param name="filename" select="$filename"/>
      <xsl:with-param name="quiet" select="$chunk.quietly"/>
      <xsl:with-param name="content">
        <html>
          <head>
            <xsl:call-template name="system.head.content"/>
            <xsl:call-template name="head.content"/>
            <xsl:call-template name="user.head.content"/>
          </head>
          <body>
            <xsl:call-template name="body.attributes"/>
            <div class="{local-name(.)}">
              <xsl:apply-templates mode="titlepage.mode"/>
            </div>
            <div class="navfooter">
              <ul class="footerlinks">
                <li class="home">
                  <a accesskey="h">
                    <xsl:attribute name="href">
                      <xsl:text>../index.html</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                      <xsl:value-of select="/book/bookinfo/title"/>
                      <xsl:text> - </xsl:text>
                      <xsl:value-of select="/book/bookinfo/subtitle"/>
                    </xsl:attribute>
                    <xsl:call-template name="navig.content">
                      <xsl:with-param name="direction" select="'home'"/>
                    </xsl:call-template>
                  </a>
                </li>
              </ul>
            </div>
          </body>
        </html>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

    <!-- Making the link-->
  <xsl:template match="copyright" mode="titlepage.mode">
    <p class="{name(.)}">
      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="'prologue/legalnotice.html'"/>
        </xsl:attribute>
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'Copyright'"/>
        </xsl:call-template>
      </a>
      <xsl:call-template name="gentext.space"/>
      <xsl:call-template name="dingbat">
        <xsl:with-param name="dingbat">copyright</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="gentext.space"/>
      <xsl:call-template name="copyright.years">
        <xsl:with-param name="years" select="year"/>
        <xsl:with-param name="print.ranges" select="$make.year.ranges"/>
        <xsl:with-param name="single.year.ranges" select="$make.single.year.ranges"/>
      </xsl:call-template>
      <xsl:call-template name="gentext.space"/>
      <xsl:apply-templates select="holder" mode="titlepage.mode"/>
    </p>
  </xsl:template>

</xsl:stylesheet>
