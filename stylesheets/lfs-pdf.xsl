<?xml version='1.0' encoding='ISO-8859-1'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">
    <!-- We use FO and FOP as the processor -->
  <xsl:import href="http://docbook.sourceforge.net/release/xsl/1.67.2/fo/docbook.xsl"/>
  <xsl:param name="fop.extensions" select="1"/>
  <xsl:param name="draft.mode" select="'no'"/>

    <!-- Including our others customized templates -->
  <xsl:include href="pdf/lfs-index.xsl"/>
  <xsl:include href="pdf/lfs-pagesetup.xsl"/>
  <xsl:include href="pdf/lfs-sections.xsl"/>
  <xsl:include href="pdf/lfs-admon.xsl"/>
  <xsl:include href="pdf/lfs-mixed.xsl"/>
  <xsl:include href="pdf/lfs-xref.xsl"/>

    <!-- This file contains our localization strings (for internationalization) -->
  <xsl:param name="local.l10n.xml" select="document('lfs-l10n.xml')"/>

    <!-- Paper size required by the publisher -->
  <xsl:param name="paper.type" select="'Customized'"/>
  <xsl:param name="page.width">7.25in</xsl:param>
  <xsl:param name="page.height">9.25in</xsl:param>

    <!-- Printing Style -->
  <xsl:param name="double.sided" select="1"/>
  <xsl:param name="hyphenate">false</xsl:param>
  <xsl:param name="alignment">justify</xsl:param>

    <!-- Font size -->
  <xsl:param name="body.font.master">9</xsl:param>
  <xsl:param name="body.font.size">12pt</xsl:param>

    <!-- TOC stuff -->
  <xsl:param name="generate.toc">
    book      toc
    part      nop
  </xsl:param>
  <xsl:param name="toc.section.depth">1</xsl:param>
  <xsl:param name="generate.section.toc.level" select="-1"></xsl:param>
  <xsl:param name="toc.indent.width" select="18"></xsl:param>

    <!-- Page number in Xref ?-->
  <xsl:param name="insert.xref.page.number">no</xsl:param>

    <!-- Prevent duplicate e-mails in the Acknowledgments pages-->
  <xsl:param name="ulink.show" select="0"/>

</xsl:stylesheet>
