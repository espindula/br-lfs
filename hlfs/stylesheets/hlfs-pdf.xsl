<?xml version='1.0' encoding='ISO-8859-1'?>

<!--
$LastChangedBy: manuel $
$Date: 2008-08-27 20:14:25 $
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

    <!-- LFS top-level pdf templates. -->
  <xsl:import href="lfs-xsl/pdf.xsl"/>

    <!-- The LFS book type to be processed (lfs, blfs, clfs, or hlfs) -->
  <xsl:param name="book-type">hlfs</xsl:param>

</xsl:stylesheet>
