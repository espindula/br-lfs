<?xml version='1.0' encoding='ISO-8859-1'?>

<!-- Created by Larry Lawrence <larry@linuxfromscratch.org> -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
version='1.0'>

<xsl:import href="http://db2latex.sourceforge.net/xsl/docbook.xsl"/>
<xsl:output method="text" encoding="ISO-8859-1" indent="yes"/>
<xsl:variable name="latex.override">

\documentclass[12pt]{book}

\usepackage{lfs}
\usepackage{fancyhdr}
\usepackage{fancyvrb}
\usepackage{makeidx}
\usepackage{hyperref}
\usepackage{fancybox}

\oddsidemargin -0.5in
\evensidemargin -0.625in
\textwidth 7in
\textheight 8.5in

%\ifx\pdfoutput\undefined
%\else
%\pdfpagewidth=7in
%\pdfpageheight=8.5in
%\fi

\pagestyle{fancy}
\newenvironment{admonition}[2] {
 \vspace{8mm}
 \hspace{0mm}\newline
 \noindent
}


\fancyhf{}
\fancyhead[LE,RO]{\bfseries\thepage}
\fancyhead[LO]{\bfseries\rightmark}
\fancyhead[RE]{\bfseries\leftmark}
\renewcommand{\headrulewidth}{0.5pt}
\renewcommand{\footrulewidth}{0pt}
\addtolength{\headheight}{3pt}
\fancypagestyle{plain}{%
	\fancyhead{}
	\renewcommand{\headrulewidth}{0pt}
}


\hyphenation{change-log cpp-flags ctrlaltdel ma-cros chil-ton}

<!-- adds \frontmatter to document -->

</xsl:variable>

<xsl:variable name="toc.section.depth">1</xsl:variable>

<xsl:variable name="latex.book.begindocument">
        <xsl:text>\begin{document}&#10;</xsl:text>
        <xsl:text>\frontmatter&#10;</xsl:text>
</xsl:variable>

<!-- This put each section on a new page in the preface section -->

<xsl:template match="preface/sect1">
        <xsl:text>&#10;</xsl:text>
        <xsl:text>\newpage&#10;</xsl:text>
        <xsl:text>\section*{</xsl:text><xsl:copy-of
select="normalize-space(title)"/><xsl:text>}&#10;</xsl:text>
        <xsl:apply-templates/>
</xsl:template>



</xsl:stylesheet>
