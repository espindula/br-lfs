<?xml version='1.0' encoding='ISO-8859-1'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

  	<!-- We use XHTML -->
  <xsl:import href="http://docbook.sourceforge.net/release/xsl/1.65.1/xhtml/docbook.xsl"/>

  <!-- Fix encoding issues with default UTF-8 output of the xhtml stylesheet -->
  <xsl:output method="html" encoding="ISO-8859-1" indent="no" />
  
 	<!-- Including our others customized templates -->
  <xsl:include href="xhtml/lfs-admon.xsl"/>
  <xsl:include href="xhtml/lfs-index.xsl"/>
  <xsl:include href="xhtml/lfs-mixed.xsl"/>
  <xsl:include href="xhtml/lfs-navigational.xsl"/>
  <!-- The following breaks hyperlinks in the TOC -->
  <!--  <xsl:include href="xhtml/lfs-titles.xsl"/> -->
  <xsl:include href="xhtml/lfs-toc.xsl"/>

  	<!-- The CSS Stylesheet -->
  <xsl:param name="html.stylesheet" select="'lfs.css'"/>

  	<!-- Dropping some unwanted style attributes -->
  <xsl:param name="ulink.target" select="''"></xsl:param>
  <xsl:param name="css.decoration" select="0"></xsl:param>
  
</xsl:stylesheet>
