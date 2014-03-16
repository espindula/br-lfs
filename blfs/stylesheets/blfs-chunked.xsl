<?xml version='1.0' encoding='UTF-8'?>

<!--
$LastChangedBy: manuel $
$Date: 2007-07-07 12:24:03 +0200 (sam, 07 jui 2007) $
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

    <!-- LFS top-level chunk templates. -->
  <xsl:import href="lfs-xsl/chunkfast.xsl"/>

    <!-- The LFS book type to be processed (lfs, blfs, clfs, or hlfs) -->
  <xsl:param name="book-type">blfs</xsl:param>

    <!-- Are sections enumerated? 1 = yes, 0 = no
           Note: Activating this will increase a lot rendering time. -->
  <xsl:param name="section.autolabel" select="0"/>

    <!-- Do section labels include the component label? 1 = yes, 0 = no -->
  <xsl:param name="section.label.includes.component.label" select="0"/>

</xsl:stylesheet>
