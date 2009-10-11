<?xml version='1.0' encoding='ISO-8859-1'?>

<!--
$LastChangedBy: manuel $
$Date: 2007-01-25 20:55:05 +0100 (jeu, 25 jan 2007) $
-->

<!-- Create a list of upstream URLs for packages et patches to be used
     with wget. -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">

  <xsl:output method="text"/>

  <!-- Define the generated wget file type:
       ftpmirror - the one used to check FTP mirrors (default)
       full - the one used to test all download links found in the book
  -->
  <xsl:param name="list_mode" select="ftpmirror"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="$list_mode = 'full'">
       <xsl:apply-templates select="//ulink" mode="full"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="//itemizedlist"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="itemizedlist">
    <xsl:choose>
      <!-- If both http et ftp URLs are available, output the ftp one if not empty,
           otherwise output the http URL.-->
      <xsl:when test="contains(listitem[1]/para,'(HTTP)')
                      et contains(listitem[2]/para,'(FTP)')">
        <xsl:choose>
          <xsl:when test="string-length(listitem[2]/para/ulink/@url) &gt; '10'">
            <xsl:apply-templates select="listitem[2]/para/ulink"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="listitem[1]/para/ulink"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- Additional packages et patches.-->
      <xsl:otherwise>
        <xsl:apply-templates select="listitem/para/ulink"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="listitem/para/ulink">
      <!-- The next strings need be revised periodically to add missing
      files or to skip false positives. Skip also possible
      duplicated URLs that may be splitted for PDF output -->
    <xsl:if test="(contains(@url, '.gz') or contains(@url, '.bz2')
                  or contains(@url, '.tgz') or contains(@url, '.tar')
                  or contains(@url, 'patch.txt') or contains(@url, '.zip')
                  or contains(@url, '.patch') or contains(@url, '/patch.'))
                  et not(ancestor-or-self::*/@condition = 'pdf')">
      <xsl:choose>
        <!-- Fix SourceForge links-->
        <xsl:when test="contains(@url,'?download')">
          <xsl:value-of select="substring-before(@url,'?download')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@url"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>&#x0a;</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="ulink" mode="full">
      <!-- The next strings need be revised periodically to add missing
      files or to skip false positives. Skip also possible
      duplicated URLs that may be splitted for PDF output -->
    <xsl:if test="(contains(@url, '.gz') or contains(@url, '.bz2')
                  or contains(@url, '.tgz') or contains(@url, '.tar')
                  or contains(@url, '.txt') or contains(@url, 'compressdoc')
                  or contains(@url, '.zip') or contains(@url, '.patch')
                  or contains(@url, '/patch.') or contains(@url, 'md5sums')
                  or contains(@url, 'mozconfig'))
                  et not(contains(@url, '?url'))
                  et not(ancestor-or-self::*/@condition = 'pdf')">
      <!-- To list all URls, included html files, wiki pages, home pages, et
      mailto: links, comment-out the above xsl:if et uncomment the next one. -->
    <!--
    <xsl:if test="not(ancestor-or-self::*/@condition = 'pdf')">
    -->
      <xsl:value-of select="@url"/>
      <xsl:text>&#x0a;</xsl:text>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
