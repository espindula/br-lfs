<?xml version='1.0' encoding='ISO-8859-1'?>

<!-- Version 0.9 - Manuel Canales Esparcia <macana@lfs-es.org>
Based on the original lfs-chunked.xsl created by Matthew Burgess -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

  	<!-- We use XHTML -->
  <xsl:import href="http://docbook.sourceforge.net/release/xsl/1.65.1/xhtml/docbook.xsl"/>
  
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
