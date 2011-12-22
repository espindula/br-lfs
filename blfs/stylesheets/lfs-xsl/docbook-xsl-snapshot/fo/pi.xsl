<?xml version='1.0'?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  exclude-result-prefixes="doc"
  version='1.0'>

<!-- ********************************************************************
     $Id: pi.xsl 7431 2008-05-09 13:00:42Z randy $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<doc:reference xmlns=""><info><title>FO Processing Instruction Reference</title>
    <releaseinfo role="meta">
      $Id: pi.xsl 7431 2008-05-09 13:00:42Z randy $
    </releaseinfo>
  </info>

  <partintro id="partintro">
    <title>Introduction</title>

    <para>This is generated reference documentation for all
      user-specifiable processing instructions (PIs) in the DocBook
      XSL stylesheets for FO output.
      <note>
        <para>You add these PIs at particular points in a document to
          cause specific 