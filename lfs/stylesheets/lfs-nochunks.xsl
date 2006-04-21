<?xml version='1.0' encoding='ISO-8859-1'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

    <!-- We use XHTML -->
  <xsl:import href="http://docbook.sourceforge.net/release/xsl/1.69.1/xhtml/profile-docbook.xsl"/>

    <!-- Fix encoding issues with default UTF-8 output of the xhtml stylesheet -->
  <xsl:output method="html" encoding="ISO-8859-1" indent="no" />

   <!-- Including our others customized templates -->
  <xsl:include href="xhtml/lfs-index.xsl"/>
  <xsl:include href="xhtml/lfs-mixed.xsl"/>
  <xsl:include href="xhtml/lfs-sections.xsl"/>
  <xsl:include href="xhtml/lfs-toc.xsl"/>
  <xsl:include href="xhtml/lfs-xref.xsl"/>

    <!-- This file contains our localization strings (for internationalization) -->
  <xsl:param name="local.l10n.xml" select="document('lfs-l10n.xml')"/>

    <!-- Dropping some unwanted style attributes -->
  <xsl:param name="ulink.target" select="''"></xsl:param>
  <xsl:param name="css.decoration" select="0"></xsl:param>

    <!-- Don't use graphics in admonitions -->
  <xsl:param name="admon.graphics" select="0"/>

    <!-- Changing the admonitions output tagging -->
  <xsl:template name="nongraphical.admonition">
    <div class="{name(.)}">
      <div class ="admonhead">
        <h3 class="admontitle">
          <xsl:apply-templates select="." mode="object.title.markup"/>
        </h3>
      </div>
      <div class="admonbody">
        <xsl:apply-templates/>
      </div>
    </div>
  </xsl:template>

    <!-- To drop the remainig dot when title is empty (from lfs-titles.xsl)-->
  <xsl:template name="sect2.titlepage">
    <xsl:choose>
      <xsl:when test="string-length(title) = 0"/>
      <xsl:otherwise>
        <div class="titlepage">
          <xsl:if test="@id">
            <a id="{@id}" name="{@id}"/>
          </xsl:if>
          <h3 class="{name(.)}">
            <xsl:apply-templates select="." mode="label.markup"/>
            <xsl:text>. </xsl:text>
            <xsl:value-of select="title"/>
          </h3>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

    <!-- Added the role param for proper punctuation in xref calls
            (from lfs-titles.xsl). -->
  <xsl:template match="*" mode="insert.title.markup">
    <xsl:param name="purpose"/>
    <xsl:param name="xrefstyle"/>
    <xsl:param name="title"/>
    <xsl:param name="role"/>
    <xsl:choose>
      <xsl:when test="$purpose = 'xref' and titleabbrev">
        <xsl:apply-templates select="." mode="titleabbrev.markup"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$title"/>
        <xsl:value-of select="$role"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

    <!-- The CSS Stylesheet -->
  <xsl:template name='user.head.content'>
    <style type="text/css">
      <xsl:text>
/* Global settings */
body {
  font-family: sans-serif;
  text-align: left;
  background: #fff;
  color: #333;
  margin: 1em;
  padding: 0;
  font-size: 1em;
  line-height: 1.2em
}

a:link { color: #22b; }
a:visited { color: #7e4988; }
a:hover, a:focus { color: #d30e08; }
a:active { color: #6b77b1;}

/* Headers */
h1, h2, b, strong {
  color: #000;
  font-weight: bold;
}

h3, h4, h5, h6 {
  color: #222;
}

h1 { font-size: 173%; text-align: center; }
h2 { font-size: 144%; }
h2.subtitle { text-align: center; }
h3 { font-size: 120%; padding-top: 0.2em; margin-top: 0.3em; }
h4 { font-size: 110%;}
h5, h6 { font-size: 110%; font-style: italic; }

/* TOC and Index*/

div.toc ul, div.index ul, div.navheader ul, div.navfooter ul {
  list-style: none;
}

div.toc, div.dedication {
  padding-left: 1em;
}

li.preface {
  margin-left: 1em;
}

div.toc ul li h3, div.toc ul li h4 {
  margin: .4em;
}

.item {
    width: 15em;
    float: left;
}

.secitem {
    font-weight: normal;
    width: 14em;
    float: left;
}

/* Admonitions */
div.note, div.tip {
  background-color: #fffff6;
  border: 2px solid #dbddec;
  width: 90%;
  margin: .5em auto;
}

div.important, div.warning, div.caution {
  background-color: #fffff6;
  border: medium solid #400;
  width: 90%;
  margin: 1.5em auto;
  color: #600;
  font-size: larger;
}

div.important h3, div.warning h3, div.caution h3 {
  color: #900;
}

h3.admontitle {
  padding-left: 2.5em;
  padding-top: 1em;
}

div.admonbody {
  margin: .5em;
}

div.important em, div.warning em, div.caution em {
  color: #000;
  font-weight: bold;
}

div.important tt, div.warning tt, div.caution tt {
  font-weight: bold;
}

/* variablelist and segmentedlist */
dl {
  margin: 0;
  padding: 0;
}

dt {
  display: list-item;
  font-weight: bold;
  margin: .33em 0 0 1em;
  padding: 0;
}

div.content dt {
  list-style: none;
}

dd  {
  margin: 0 0 1em 3em;
  padding: 0;
}

div.variablelist dd {
  margin-bottom: 1em;
}

div.variablelist dd p {
  margin-top: 0px;
}

dl.materials dd {
  margin-left: 0px;
}

div.segmentedlist {
  margin-top: 1em;
}

div.segmentedlist p {
  margin: 0px auto;
}

/* itemizedlist */

div.itemizedlist {
  margin-left: 1em;
}

/* Indented blocks */
p, ul, dl, code, blockquote {
  padding-left: 1em;
}

/* Monospaced elements */
tt, code, kbd, pre, .command {
  font-family: monospace;
}

pre.userinput {
  color: #101310;
  background-color: #e5e5e5;
  border: 1px solid #050505;
  padding: .5em 1em;
  margin: 0 2em;
  font-weight: bold;
}

pre.screen {
  background-color: #e9e9e9;
  border: 1px solid #050505;
  padding: .5em 1em;
  margin: 0 2em;
}

/* Sections */
div.package {
  background: #f5f6f7;
  border-bottom: 0.2em solid #dbddec;
  padding: 0.5em 0.5em 0.3em 0.5em;
  margin: 0px auto;
}

div.installation {
  padding: 0 0.5em 0.3em 0.5em;
  margin: 0.5em 0 0.5em 0;
}

div.configuration {
  background:   #fefefe;
  border-top: 0.2em solid #dbddec;
  padding: 0.5em;
  margin: 0.5em 0 .5em 0;
}

div.content {
  background: #f5f6f7;
  border-top: 0.2em solid #dbddec;
  border-bottom: 0.2em solid #dbddec;
  padding: 0.5em 0.5em 1em 0.5em;
  margin: 0.5em 0 .5em 0;
}

div.installation h3.title, div.content h3.title {
  padding-top: 0.3em;
  margin: 0;
}

div.book, div.preface, div.part, div.chapter, div.sect1, div.index {
  padding-bottom: 0.5em;
}

div.preface h2, div.part h1, div.chapter h2.title, div.sect1 h2.title, div.index h1 {
  background: #f5f6f7;
  border-bottom: .2em solid #dbddec;
  border-top: .2em solid #dbddec;
  margin-top 1em;
  padding: .5em;
  text-align: center;
}

div.book h1 {
  background: #f5f6f7;
  margin: 0px auto;
  padding: 0.5em;
}

div.book h2.subtitle {
  background: #dbddec;
  margin: 0px auto;
  padding: 0.2em;
}
div.authorgroup, div p.copyright, div.abstract {
  background: #f5f6f7;
  margin: 0px auto;
  padding:  1em 0.5em;
}

hr {
  background: #dbddec;
  height: .3em;
  border: 0px;
  margin: 0px auto;
  padding: 0;
}
      </xsl:text>
    </style>
  </xsl:template>

</xsl:stylesheet>
