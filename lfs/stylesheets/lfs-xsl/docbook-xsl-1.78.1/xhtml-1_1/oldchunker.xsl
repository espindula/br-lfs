<?xml version="1.0" encoding="ASCII"?>
<!--This file was created automatically by html2xhtml-->
<!--from the HTML stylesheets.-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon" xmlns:lxslt="http://xml.apache.org/xslt" xmlns:redirect="http://xml.apache.org/xalan/redirect" xmlns:doc="http://nwalsh.com/xsl/documentation/1.0" xmlns="http://www.w3.org/1999/xhtml" version="1.1" exclude-result-prefixes="doc" extension-element-prefixes="saxon redirect lxslt">

<!-- ********************************************************************
     $Id: oldchunker.xsl 6910 2007-06-28 23:23:30Z xmldoc $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<!-- This stylesheet works with Saxon and Xalan; for XT use xtchunker.xsl -->

<!-- ==================================================================== -->

<xsl:param name="default.encoding" select="'utf-8'" doc:type="string"/>

<doc:param xmlns="" name="default.encoding">
<refpurpose xmlns="http://www.w3.org/1999/xhtml">Encoding used in generated HTML pages</refpurpose>
<refdescription xmlns="http://www.w3.org/1999/xhtml">
<para>This encoding is used in files generated by chunking stylesheet. Currently
only Saxon is able to change output encoding.
</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->

<xsl:param name="saxon.character.representation" select="'entity;decimal'" doc:type="string"/>

<doc:param xmlns="" name="saxon.character.representation">
<refpurpose xmlns="http://www.w3.org/1999/xhtml">Saxon character representation used in generated HTML pages</refpurpose>
<refdescription xmlns="http://www.w3.org/1999/xhtml">
<para>This character representation is used in files generated by chunking stylesheet. If
you want to suppress entity references for characters with direct representation 
in default.encoding, set this parameter to value <literal>native</literal>. 
</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->

<xsl:template name="make-relative-filename">
  <xsl:param name="base.dir" select="'./'"/>
  <xsl:param name="base.name" select="''"/>

  <xsl:variable name="vendor" select="system-property('xsl:vendor')"/>

  <xsl:choose>
    <xsl:when test="contains($vendor, 'SAXON')">
      <!-- Saxon doesn't make the chunks relative -->
      <xsl:value-of select="concat($base.dir,$base.name)"/>
    </xsl:when>
    <xsl:when test="contains($vendor, 'Apache')">
      <!-- Xalan doesn't make the chunks relative -->
      <xsl:value-of select="concat($base.dir,$base.name)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message terminate="yes">
        <xsl:text>Chunking isn't supported with </xsl:text>
        <xsl:value-of select="$vendor"/>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="write.chunk">
  <xsl:param name="filename" select="''"/>
  <xsl:param name="method" select="'html'"/>
  <xsl:param name="encoding" select="$default.encoding"/>
  <xsl:param name="indent" select="'no'"/>
  <xsl:param name="content" select="''"/>

  <xsl:message>
    <xsl:text>Writing </xsl:text>
    <xsl:value-of select="$filename"/>
    <xsl:if test="name(.) != ''">
      <xsl:text> for </xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:if test="@id">
        <xsl:text>(</xsl:text>
        <xsl:value-of select="@id"/>
        <xsl:text>)</xsl:text>
      </xsl:if>
    </xsl:if>
  </xsl:message>

  <xsl:variable name="vendor" select="system-property('xsl:vendor')"/>

  <xsl:choose>
    <xsl:when test="contains($vendor, 'SAXON 6.2')">
      <!-- Saxon 6.2.x uses xsl:document -->
      <xsl:document href="{$filename}" method="{$method}" encoding="{$encoding}" indent="{$indent}" saxon:character-representation="{$saxon.character.representation}">
        <xsl:copy-of select="$content"/>
      </xsl:document>
    </xsl:when>
    <xsl:when test="contains($vendor, 'SAXON')">
      <!-- Saxon uses saxon:output -->
      <saxon:output file="{$filename}" href="{$filename}" method="{$method}" encoding="{$encoding}" indent="{$indent}" saxon:character-representation="{$saxon.character.representation}">
        <xsl:copy-of select="$content"/>
      </saxon:output>
    </xsl:when>
    <xsl:when test="contains($vendor, 'Apache')">
      <!-- Xalan uses redirect -->
      <redirect:write file="{$filename}">
        <xsl:copy-of select="$content"/>
      </redirect:write>
    </xsl:when>
    <xsl:otherwise>
      <!-- it doesn't matter since we won't be making chunks... -->
      <xsl:message terminate="yes">
        <xsl:text>Can't make chunks with </xsl:text>
        <xsl:value-of select="$vendor"/>
        <xsl:text>'s processor.</xsl:text>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="write.chunk.with.doctype">
  <xsl:param name="filename" select="''"/>
  <xsl:param name="method" select="'html'"/>
  <xsl:param name="encoding" select="$default.encoding"/>
  <xsl:param name="indent" select="'no'"/>
  <xsl:param name="doctype-public" select="''"/>
  <xsl:param name="doctype-system" select="''"/>
  <xsl:param name="content" select="''"/>

  <xsl:message>
    <xsl:text>Writing </xsl:text>
    <xsl:value-of select="$filename"/>
    <xsl:if test="name(.) != ''">
      <xsl:text> for </xsl:text>
      <xsl:value-of select="name(.)"/>
    </xsl:if>
  </xsl:message>

  <xsl:variable name="vendor" select="system-property('xsl:vendor')"/>

  <xsl:choose>
    <xsl:when test="contains($vendor, 'SAXON 6.2')">
      <!-- Saxon 6.2.x uses xsl:document -->
      <xsl:document href="{$filename}" method="{$method}" encoding="{$encoding}" indent="{$indent}" doctype-public="{$doctype-public}" doctype-system="{$doctype-system}" saxon:character-representation="{$saxon.character.representation}">
        <xsl:copy-of select="$content"/>
      </xsl:document>
    </xsl:when>
    <xsl:when test="contains($vendor, 'SAXON')">
      <!-- Saxon uses saxon:output -->
      <saxon:output file="{$filename}" href="{$filename}" method="{$method}" encoding="{$encoding}" indent="{$indent}" doctype-public="{$doctype-public}" doctype-system="{$doctype-system}" saxon:character-representation="{$saxon.character.representation}">
        <xsl:copy-of select="$content"/>
      </saxon:output>
    </xsl:when>
    <xsl:when test="contains($vendor, 'Apache')">
      <!-- Xalan uses redirect -->
      <redirect:write file="{$filename}">
        <xsl:copy-of select="$content"/>
      </redirect:write>
    </xsl:when>
    <xsl:otherwise>
      <!-- it doesn't matter since we won't be making chunks... -->
      <xsl:message terminate="yes">
        <xsl:text>Can't make chunks with </xsl:text>
        <xsl:value-of select="$vendor"/>
        <xsl:text>'s processor.</xsl:text>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
