<?xml version='1.0' encoding='ISO-8859-1'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">
    <!-- We use FO and FOP as the processor -->
  <xsl:import href="http://docbook.sourceforge.net/release/xsl/1.65.1/fo/docbook.xsl"/>
  <xsl:param name="fop.extensions" select="1"/>
  <xsl:param name="draft.mode" select="'no'"/>

    <!-- Including our others customized templates -->
  <xsl:include href="print/lfs-index.xsl"/>
  <xsl:include href="print/lfs-pagesetup.xsl"/>

    <!-- Probably want to make the paper size configurable -->
  <xsl:param name="paper.type" select="'A4'"/>

    <!-- Printing Style -->
  <xsl:param name="double.sided" select="1"/>
  <xsl:param name="hyphenate">true</xsl:param>
  <xsl:param name="alignment">justify</xsl:param>
  
    <!-- Hyphenate links -->
  <xsl:param name="ulink.hyphenate" select="' '"></xsl:param>

    <!-- Font size -->
  <xsl:param name="body.font.master">8</xsl:param>
  <xsl:param name="body.font.size">10pt</xsl:param>

    <!-- TOC stuff -->
  <xsl:param name="generate.toc">
    book      toc
    part      nop
  </xsl:param>
  <xsl:param name="toc.section.depth">1</xsl:param>
  <xsl:param name="generate.section.toc.level" select="-1"></xsl:param>
  <xsl:param name="toc.indent.width" select="18"></xsl:param>

    <!-- Page number in Xref-->
  <xsl:param name="insert.xref.page.number">yes</xsl:param> <xsl:template match="*" mode="page.citation">
    <xsl:param name="id" select="'???'"/>
    <fo:inline keep-together.within-line="always">
      <xsl:text>[p</xsl:text>
      <fo:page-number-citation ref-id="{$id}"/>
      <xsl:text>]</xsl:text>
    </fo:inline>
  </xsl:template>

    <!-- Prevent duplicate e-mails in the Acknowledgments pages-->
  <xsl:param name="ulink.show" select="0"/>

</xsl:stylesheet>
