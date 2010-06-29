<?xml version='1.0' encoding='ISO-8859-1'?>

<!--
$LastChangedBy$
$Date$
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

   <!-- Second level chunked output template.
        Sets global params and include customized elements templates. -->

    <!-- Upstream XHTML presentation templates -->
  <xsl:import href="docbook-xsl-snapshot/xhtml/docbook.xsl"/>

    <!-- Use ISO-8859-1 for output instead of default UTF-8 -->
  <xsl:param name="chunker.output.encoding" select="'ISO-8859-1'"/>

    <!-- Including our customized elements templates -->
  <xsl:include href="common.xsl"/>
  <xsl:include href="xhtml/lfs-admon.xsl"/>
  <xsl:include href="xhtml/lfs-mixed.xsl"/>
  <xsl:include href="xhtml/lfs-sections.xsl"/>
  <xsl:include href="xhtml/lfs-titles.xsl"/>
  <xsl:include href="xhtml/lfs-toc.xsl"/>
  <xsl:include href="xhtml/lfs-xref.xsl"/>

    <!-- The CSS Stylesheets. We set here relative path from sub-dirs HTML files.
    The path from top-level HTML files (index.html, partX.html, etc) MUST be
    fixed via a sed in the Makefile-->
    <!-- Master CSS Stylesheet -->
  <xsl:param name="html.stylesheet" select="'../stylesheets/lfs.css'"/>
    <!-- Print CSS Stylesheet -->
    <!-- The original template is in {docbook-xsl}/xhtml/docbook.xsl -->
  <xsl:template name='user.head.content'>
     <link rel="stylesheet" href="../stylesheets/lfs-print.css" type="text/css" media="print"/>
  </xsl:template>

    <!-- Dropping some unwanted style attributes -->
  <xsl:param name="ulink.target" select="''"/>
  <xsl:param name="css.decoration" select="0"/>

    <!-- No XML declaration -->
  <xsl:param name="chunker.output.omit-xml-declaration" select="'yes'"/>

    <!-- Control generation of ToCs and LoTs -->
  <xsl:param name="generate.toc">
    book      toc,title
    preface   toc
    part      toc
    chapter   toc
    appendix  nop
    sect1     nop
    sect2     nop
    sect3     nop
    sect4     nop
    sect5     nop
    section   nop
  </xsl:param>

    <!-- How deep should recursive sections appear in the TOC? -->
  <xsl:param name="toc.section.depth">1</xsl:param>

    <!-- How maximaly deep should be each TOC? -->
  <xsl:param name="toc.max.depth">3</xsl:param>

</xsl:stylesheet>
