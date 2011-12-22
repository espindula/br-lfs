<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:dyn="http://exslt.org/dynamic"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="doc dyn saxon"
                version='1.0'>

<!-- ********************************************************************
     $Id: utility.xsl 7431 2008-05-09 13:00:42Z randy $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->
<doc:reference xmlns="" xml:id="utility">
  <info>
    <title>Common » Utility Template Reference</title>
    <releaseinfo role="meta">
      $Id: utility.xsl 7431 2008-05-09 13:00:42Z randy $
    </releaseinfo>
  </info>
  <!-- * yes, partintro is a valid child of a reference... -->
  <partintro xml:id="partintro">
    <title>Introduction</title>
    <para>This is technical reference documentation for the
      miscellaneous utility templates in the DocBook XSL
      Stylesheets.</para>
    <note>
      <para>These templates are defined in a separate file from the set
        of 