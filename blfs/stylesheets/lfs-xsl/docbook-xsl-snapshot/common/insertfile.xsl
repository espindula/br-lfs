<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                version='1.0'>

<!-- ********************************************************************
     $Id: insertfile.xsl 6840 2007-07-07 10:25:55Z manuel $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<xsl:param name="textdata.default.encoding"></xsl:param>

<!-- * This stylesheet makes a copy of a source tree, replacing all -->
<!-- * instances of the following with corresponding Xinclude instances -->
<!-- * in the result tree. -->
<!-- * -->
<!-- *   <textobject><textdata fileref="foo.txt"> -->
<!-- *   <imagedata format="linespecific" fileref="foo.txt"> -->
<!-- *   <inlinegraphic format="linespecific" fileref="foo.txt"> -->
<!-- * -->
<!-- * Those become: -->
<!-- * -->
<!-- *   <xi:include href="foo.txt" parse="text"/> -->
<!-- * -->
<!-- * It also works as expected with entityref in place of fileref, -->
<!-- * and copies over the value of the <textdata>