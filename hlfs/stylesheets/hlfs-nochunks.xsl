<?xml version='1.0' encoding='ISO-8859-1'?>

<!--
$LastChangedBy: manuel $
$Date: 2007-07-08 13:04:18 +0200 (dim, 08 jui 2007) $
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

    <!-- LFS top-level no-chunk templates. -->
  <xsl:import href="lfs-xsl/nochunks.xsl"/>

    <!-- The LFS book type to be processed (lfs, blfs, clfs, or hlfs) -->
  <xsl:param name="book-type">hlfs</xsl:param>

    <!-- List of strings used inside @role attributes for additional features.
         The list must start and end with a ","
         The features JavaScript code is not used on nochunk output, but the
         XSL and CSS code need this param. -->
  <xsl:param name="hlfs-features">,ssp,aslr,pax,hardened_tmp,warnings,misc,blowfish,</xsl:param>

</xsl:stylesheet>
