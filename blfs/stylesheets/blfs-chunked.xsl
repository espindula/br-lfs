<?xml version='1.0' encoding='ISO-8859-1'?>

<!-- Version 0.9 - Manuel Canales Esparcia <macana@lfs-es.org>
Based on the original lfs-chunked.xsl created by Matthew Burgess -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

  	<!-- We use XHTML -->
  <xsl:import href="http://docbook.sourceforge.net/release/xsl/1.65.1/xhtml/chunk.xsl"/>
  <xsl:param name="chunker.output.encoding" select="'ISO-8859-1'"/>
  
  	<!-- Including our others customized templates -->
  <xsl:include href="xhtml/lfs-admon.xsl"/>
  <xsl:include href="xhtml/lfs-index.xsl"/>
  <xsl:include href="xhtml/lfs-legalnotice.xsl"/>
  <xsl:include href="xhtml/lfs-mixed.xsl"/> 
  <xsl:include href="xhtml/lfs-navigational.xsl"/>
  <xsl:include href="xhtml/lfs-titles.xsl"/>
  <xsl:include href="xhtml/lfs-toc.xsl"/>

  	<!-- The CSS Stylesheet -->
  <xsl:param name="html.stylesheet" select="'../stylesheets/blfs.css'"/>

  	<!-- Dropping some unwanted style attributes -->
  <xsl:param name="ulink.target" select="''"></xsl:param>
  <xsl:param name="css.decoration" select="0"></xsl:param>
  
    <!-- No XML declaration -->
  <xsl:param name="chunker.output.omit-xml-declaration" select="'yes'"/>
  
    <!-- Insert a stylesheet for printing -->
  <xsl:template name='user.head.content'>
     <link rel='stylesheet' href="../stylesheets/blfs-print.css" type="text/css" media='print'/>
  </xsl:template> 

<xsl:template match="userinput">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

</xsl:stylesheet>
