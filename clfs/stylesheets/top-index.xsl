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
          Cross-Compiled Linux From Scratch
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
.author, .copyright {
  background: #f5f6f7;
  margin: 0px auto;
  padding: 0.5em 1em;
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
      </head>
      <body>
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="bookinfo">
    <div class="book">
      <div class="titlepage">
        <xsl:apply-templates/>
        <hr/>
      </div>
      <div class="toc">
        <h3>
          <xsl:text>Native Build</xsl:text>
        </h3>
	<ul>
          <h3>
             <xsl:text>Work in Progress.</xsl:text>
          </h3>
          <li>
            <h4>
              <a href="native">
                <xsl:text>Native 32Bit</xsl:text>
              </a>
            </h4>
          </li>
          <li>
            <h4>
              <a href="native64">
                <xsl:text>Native Multilib</xsl:text>
              </a>
            </h4>
          </li>
        </ul>
        <h3>
          <xsl:text>32 Bit Builds</xsl:text>
        </h3>
        <ul>
	  <h3>
	    <xsl:text>Working. Testers and comments welcomed.</xsl:text>
          </h3>
          <li>
            <h4>
              <a href="x86">
                <xsl:text>Intel/AMD x86</xsl:text>
              </a>
            </h4>
          </li>
          <li>
            <h4>
              <a href="ppc">
                <xsl:text>PowerPC</xsl:text>
              </a>
            </h4>
          </li>
          <li>
            <h4>
              <a href="mips">
                <xsl:text>MIPS</xsl:text>
              </a>
            </h4>
          </li>
          <li>
            <h4>
              <a href="sparc">
                <xsl:text>Sparc v8</xsl:text>
              </a>
            </h4>
          </li>
	</ul>
        <h3>
          <xsl:text>64 Bit Builds</xsl:text>
        </h3>
	<ul>
          <h3>
            <xsl:text>Working. Testers and comments welcomed.</xsl:text>
          </h3>
          <li>
            <h4>
              <a href="x86_64-64">
                <xsl:text>x86_64</xsl:text>
              </a>
            </h4>
          </li>
          <li>
            <h4>
              <a href="mips64-64">
                <xsl:text>MIPS</xsl:text>
              </a>
            </h4>
          </li>
          <li>
            <h4>
             <a href="sparc64-64">
                <xsl:text>Sparc v9/Ultrasparc</xsl:text>
             </a>
            </h4>
          </li>
          <li>
            <h4>
             <a href="alpha">
                <xsl:text>Alpha</xsl:text>
             </a>
            </h4>
          </li>
	</ul>
        <h3>
          <xsl:text>Multilib Builds</xsl:text>
        </h3>
	<ul>
          <h3>
             <xsl:text>Working. Testers and comments welcomed.</xsl:text>
          </h3>
          <li>
            <h4>
              <a href="x86_64">
                <xsl:text>x86_64</xsl:text>
              </a>
            </h4>
          </li>
          <li>
            <h4>
              <a href="mips64">
                <xsl:text>MIPS</xsl:text>
              </a>
            </h4>
          </li>
          <li>
            <h4>
             <a href="sparc64">
                <xsl:text>Sparc v9/Ultrasparc</xsl:text>
             </a>
            </h4>
          </li>
          <li>
            <h4>
              <a href="ppc64">
                <xsl:text>PowerPC64</xsl:text>
              </a>
            </h4>
          </li>
        </ul>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="title">
    <h1 class="title">
      <xsl:value-of select="."/>
    </h1>
    <h2 class="subtitle">
      <xsl:text>Version &version;</xsl:text>
    </h2>
  </xsl:template>

  <xsl:template match="copyright">
    <p class="copyright">
      <xsl:text>Copyright ©</xsl:text>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="year">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="holder">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="bibliosource">
    <p class="copyright">
      <em>
        <xsl:apply-templates/>
      </em>
    </p>
  </xsl:template>

  <xsl:template match="subtitle|author|firstname|surname|legalnotice"/>

</xsl:stylesheet>
