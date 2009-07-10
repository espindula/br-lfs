<?xml version='1.0' encoding='ISO-8859-1'?>
<!DOCTYPE xsl:stylesheet [
 <!ENTITY % general-entities SYSTEM "../general.ent">
  %general-entities;
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

  <xsl:output method="html" encoding="iso-8859-1"/>

  <xsl:template match="/">
    <html>
      <head>
        <title>
          Hardened Linux From Scratch
        </title>
        <style type="text/css">
          <xsl:text>
/* Global settings */
body {
  font-family: verdana, tahoma, helvetica, arial, sans-serif;
  text-align: left;
  background: #fff;
  color: #222;
  margin: 1em;
  padding: 0;
  font-size: 1em;
  line-height: 1.2em
}

a:link { color: #22b; }
a.ulink:link { font-weight: bold; color: #55f; }
a:visited { color: #7e4988 ! important; }
a:hover, a:focus { color: #d30e08 ! important; }
a:active { color: #6b77b1 ! important;}

h1, h2 h3, h4 {
  color: #000;
  font-weight: bold;
  line-height: 1em;
}

h1 { font-size: 173%; text-align: center; }
h2 { font-size: 144%; text-align: center; }
h3 { font-size: 120%; }
h4 { font-size: 110%; }

.toc {
  padding-left: 1em;
}

.toc ul li h3, .toc ul li h4 {
  margin: .4em;
}

.book h1 {
  background: #f5f6f7;
  margin: 0px auto;
  padding: 0.5em;
}

.book h2 {
  background: #dbddec;
  margin: 0px auto;
  padding: 0.2em;
}
.authorgroup, .copyright {
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

.intro {
  background:   #fefefe;
  padding: 0.5em;
  margin: 0.5em 0 .5em 0;
}

div.admon img {
  padding: .3em;
}

div.admon h3 {
  display: inline;
  margin-left: 2em;
}

div.admon p {
  margin-left: .5em;
}

div.admon pre {
  margin: 0.5em 3em;
}

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
  margin: .5em auto;
  color: #600;
}

div.important h3, div.warning h3, div.caution h3 {
  color: #900;
}

div.important em, div.warning em, div.caution em {
  color: #000;
  font-weight: bold;
}
          </xsl:text>
        </style>
      </head>
      <body>
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="bookinfo">
    <div class="book">
      <xsl:apply-templates/>
      <hr/>
      <div class="toc">
        <h3>
          <xsl:text>Choisissez votre implémentation Libc et votre série du noyau
          Linux préférées comme base de la construction de votre système</xsl:text>
        </h3>
        <noscript>
          <ul>
            <li>
              <h4>
                <a href="glibc-2.4/index.html">
                  <xsl:text>Basé sur Glibc + Linux-2.4</xsl:text>
                </a>
              </h4>
            </li>
            <li>
              <h4>
                <a href="glibc-2.6/index.html">
                  <xsl:text>Basé sur Glibc + Linux-2.6</xsl:text>
                </a>
              </h4>
            </li>
            <li>
              <h4>
                <a href="uclibc-2.4/index.html">
                  <xsl:text>Basé sur uClibc + Linux-2.4</xsl:text>
                </a>
              </h4>
            </li>
            <li>
              <h4>
                <a href="uclibc-2.6/index.html">
                  <xsl:text>Basé sur uClibc + Linux-2.6</xsl:text>
                </a>
              </h4>
            </li>
          </ul>
        </noscript>
        <script type="text/javascript" src="features.js"/>
        <script type="text/javascript">
<![CDATA[
document.write("<form id=\"setup_ftrs\" onsubmit=\"javascript: return featuresSetup(this);\" ");
document.write("      style=\"width: 23em; margin-left: 10em; margin-bottom: 5em\">");
document.write(" <fieldset style=\"margin-bottom: 2em\">");
document.write("  <legend style=\"font-size: 1.3em; margin-left: 5em;\">Book variant</legend>");
document.write("  <table class=\"form\" style=\"margin-left: auto; margin-right: auto;\">");
document.write("   <tr>");
document.write("    <th style=\"padding-right: 1em;\">Kernel version:</th>");
document.write("    <td style=\"padding-right: 1em;\">");
document.write("     <input type=\"radio\" name=\"kernel\" id=\"kernel_26\" value=\"2.6\"");
document.write("            checked=\"checked\" />");
document.write("     <label for=\"kernel_26\">2.6</label>");
document.write("    </td>");
document.write("    <td>");
document.write("     <input type=\"radio\" name=\"kernel\" id=\"kernel_24\" value=\"2.4\" />");
document.write("     <label for=\"kernel_24\">2.4</label>");
document.write("    </td>");
document.write("   </tr>");
document.write("   <tr>");
document.write("    <th style=\"padding-right: 1em;\">C library used:</th>");
document.write("    <td style=\"padding-right: 1em;\">");
document.write("     <input type=\"radio\" name=\"libc\" id=\"glibc\" value=\"glibc\"");
document.write("            checked=\"checked\" />");
document.write("     <label for=\"glibc\">Glibc</label>");
document.write("    </td>");
document.write("    <td>");
document.write("     <input type=\"radio\" name=\"libc\" id=\"uclibc\" value=\"uclibc\" />");
document.write("     <label for=\"uclibc\">uClibc</label>");
document.write("    </td>");
document.write("   </tr>");
document.write("  </table>");
document.write(" </fieldset>");
/* Disabled for now
document.write(" <fieldset style=\"margin-bottom: 2em; line-height: 1.5em\">");
document.write("  <legend style=\"font-size: 1.3em; margin-left: 5em;\">Build features</legend>");
document.write("  <p style=\"margin: 0; text-align: center;\">Click on links for descriptions</p>");
document.write("  <div>");
document.write("   <input type=\"checkbox\" checked=\"checked\"");
document.write("          name=\"pax\" id=\"pax\" value=\"pax\" />");
document.write("   <label for=\"pax\">");
document.write("    <a href=\"features.html#ch-technotes-pax\">PaX-aware ELF executables and kernel</a>");
document.write("   </label>");
document.write("  </div>");
document.write("  <div>");
document.write("   <input type=\"checkbox\" checked=\"checked\"");
document.write("          name=\"ssp\" id=\"ssp\" value=\"ssp\" />");
document.write("   <label for=\"ssp\">");
document.write("    <a href=\"features.html#ch-technotes-ssp\">Stack-smashing protector</a>");
document.write("   </label>");
document.write("  </div>");
document.write("  <div>");
document.write("   <input type=\"checkbox\" checked=\"checked\"");
document.write("          name=\"aslr\" id=\"aslr\" value=\"aslr\" />");
document.write("   <label for=\"aslr\">");
document.write("    <a href=\"features.html#ch-technotes-aslr\">Address-space layout randomization</a>");
document.write("   </label>");
document.write("  </div>");
document.write("  <div>");
document.write("   <input type=\"checkbox\" checked=\"checked\"");
document.write("          name=\"warnigs\" id=\"warnings\" value=\"warnings\" />");
document.write("   <label for=\"warnings\">");
document.write("    <a href=\"features.html#ch-technotes-warnings\">Additional warnings</a>");
document.write("   </label>");
document.write("  </div>");
document.write("  <div>");
document.write("   <input type=\"checkbox\" checked=\"checked\"");
document.write("          name=\"hardened_tmp\" id=\"hardened_tmp\" value=\"hardened_tmp\" />");
document.write("   <label for=\"hardened_tmp\">");
document.write("    <a href=\"features.html#ch-technotes-hardened_tmp\">Hardened temporary files creation</a>");
document.write("   </label>");
document.write("  </div>");
document.write("  <div>");
document.write("   <input type=\"checkbox\" checked=\"checked\"");
document.write("          name=\"blowfish\" id=\"blowfish\" value=\"blowfish\" />");
document.write("   <label for=\"blowfish\">");
document.write("    <a href=\"features.html#ch-technotes-blowfish\">Blowfish passwords</a>");
document.write("   </label>");
document.write("  </div>");
document.write("  <div>");
document.write("   <input type=\"checkbox\" checked=\"checked\"");
document.write("          name=\"misc\" id=\"misc\" value=\"misc\" />");
document.write("   <label for=\"misc\">");
document.write("    <a href=\"features.html#ch-technotes-misc\">Miscellaneous features</a>");
document.write("   </label>");
document.write("  </div>");
document.write(" </fieldset>");
*/
document.write(" <input type=\"submit\" value=\"Go to the book\" style=\"font-size: 1.3em; margin-left: 4em;\"/>");
document.write("</form>");

/* Restore features according to cookie, if we have it. */
featuresRestoreForm("setup_ftrs");
]]>
        </script>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="title">
    <h1 class="title">
      <xsl:value-of select="."/>
    </h1>
  </xsl:template>

  <xsl:template match="subtitle">
    <h2 class="subtitle">
      <xsl:value-of select="."/>
    </h2>
  </xsl:template>

  <xsl:template match="authorgroup">
    <h3 class="authorgroup">
      <xsl:value-of select="corpauthor"/>
    </h3>
  </xsl:template>

  <xsl:template match="copyright">
    <p class="copyright">
      <xsl:text>Copyright (c)</xsl:text>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="year">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="holder">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="legalnotice"/>

  <xsl:template match="abstract">
    <xsl:if test="@condition='intro'">
      <hr/>
      <div class="intro">
        <xsl:apply-templates/>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="para">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="literallayout">
    <pre>
      <xsl:apply-templates/>
    </pre>
  </xsl:template>

  <xsl:template match="itemizedlist">
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match="listitem">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:template>

  <xsl:template match="ulink">
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="@url"/>
      </xsl:attribute>
      <i>
        <xsl:value-of select="@url"/>
      </i>
    </a>
  </xsl:template>

  <xsl:template match="command">
    <strong class="command">
      <xsl:apply-templates/>
    </strong>
  </xsl:template>

  <xsl:template match="filename">
    <tt class="filename">
      <xsl:apply-templates/>
    </tt>
  </xsl:template>

  <xsl:template match="parameter">
    <tt class="parameter">
      <xsl:apply-templates/>
    </tt>
  </xsl:template>

  <xsl:template match="note">
    <div class="admon note">
      <img alt="note" src="images/note.png"/>
      <h3 class="admontitle">Remarque:</h3>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="warning">
    <div class="admon warning">
      <img alt="note" src="images/warning.png"/>
      <h3 class="admontitle">Avertissement:</h3>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

</xsl:stylesheet>
