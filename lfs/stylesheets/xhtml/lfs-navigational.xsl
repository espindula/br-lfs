<?xml version='1.0' encoding='ISO-8859-1'?>

<!-- Version 0.9 - Manuel Canales Esparcia <macana@lfs-es.org> -->

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
					<table width="100%" summary="Navigation header">
						<tr>
							<th colspan="3" align="center">
								<h4>
									<xsl:apply-templates select="$home" mode="object.title.markup"/>
									<xsl:text> - </xsl:text>
                  <xsl:apply-templates select="$home" mode="object.subtitle.markup"/>
								</h4>
							</th>
						</tr>
						<xsl:if test="$up != $home">
							<tr>
								<th colspan="3" align="center">
									<h3>
										<xsl:apply-templates select="$up" mode="object.title.markup"/>
									</h3>
								</th>
							</tr>
						</xsl:if>
						<tr>
							<td width="33%" align="left">
								<a accesskey="p">
									<xsl:attribute name="href">
										<xsl:call-template name="href.target">
											<xsl:with-param name="object" select="$prev"/>
										</xsl:call-template>
									</xsl:attribute>
									<xsl:call-template name="navig.content">
										<xsl:with-param name="direction" select="'prev'"/>
									</xsl:call-template>
								</a>
								<xsl:text>&#160;</xsl:text>
							</td>
							<td width="34%" align="center">
								<a accesskey="h">
                	<xsl:attribute name="href">
										<xsl:call-template name="href.target">
											<xsl:with-param name="object" select="$home"/>
										</xsl:call-template>
									</xsl:attribute>
									<xsl:call-template name="navig.content">
										<xsl:with-param name="direction" select="'home'"/>
									</xsl:call-template>
								</a>
							</td>
							<td width="33%" align="right">
								<xsl:text>&#160;</xsl:text>
								<xsl:if test="count($next)&gt;0">
									<a accesskey="n">
										<xsl:attribute name="href">
											<xsl:call-template name="href.target">
												<xsl:with-param name="object" select="$next"/>
											</xsl:call-template>
										</xsl:attribute>
										<xsl:call-template name="navig.content">
											<xsl:with-param name="direction" select="'next'"/>
										</xsl:call-template>
									</a>
								</xsl:if>
							</td>
						</tr>
					</table>
					<hr/>
				</xsl:if>
			</div>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
