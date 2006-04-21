<?xml version='1.0' encoding='ISO-8859-1'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

    <!-- We use XHTML -->
  <!--
  <xsl:import href="http://docbook.sourceforge.net/release/xsl/1.69.1/xhtml/docbook.xsl"/>
  <xsl:param name="chunker.output.encoding" select="'ISO-8859-1'"/>
  -->
  <xsl:import href="/usr/share/sgml/docbook/stylesheet/xsl/nwalsh/xhtml/docbook.xsl"/>
  <xsl:param name="chunker.output.encoding" select="'ISO-8859-15'"/>


    <!-- Including our others customized elements templates -->
  <xsl:include href="xhtml/lfs-admon.xsl"/>
  <xsl:include href="xhtml/lfs-sections.xsl"/>
  <xsl:include href="xhtml/lfs-mixed.xsl"/>
  <xsl:include href="xhtml/lfs-titles.xsl"/>
  <xsl:include href="xhtml/lfs-toc.xsl"/>
  <xsl:include href="xhtml/lfs-xref.xsl"/>

    <!-- This file contains our localization strings (for internationalization) -->
  <xsl:param name="local.l10n.xml" select="document('lfs-l10n.xml')"/>

    <!-- The CSS Stylesheet -->
  <xsl:param name="html.stylesheet" select="'../stylesheets/lfs.css'"/>
  <xsl:template name='user.head.content'>
     <link rel="stylesheet" href="../stylesheets/lfs-print.css" type="text/css" media="print"/>
  </xsl:template>

    <!-- Dropping some unwanted style attributes -->
  <xsl:param name="ulink.target" select="''"></xsl:param>
  <xsl:param name="css.decoration" select="0"></xsl:param>

    <!-- No XML declaration -->
  <xsl:param name="chunker.output.omit-xml-declaration" select="'yes'"/>

</xsl:stylesheet>
