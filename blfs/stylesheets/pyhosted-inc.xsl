<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
  <xsl:variable name="part1"><![CDATA[<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE chapter PUBLIC "-//OASIS//DTD DocBook XML V4.5//EN"
  "http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd" [
<!ENTITY % general-entities SYSTEM "../../../general.ent">
 %general-entities;

  <!ENTITY pythonhosted-download-http "See Below">
  <!ENTITY pythonhosted-download-ftp  " ">
  <!ENTITY pythonhosted-md5sum        "See Below">
  <!ENTITY pythonhosted-size          "14 MB">
  <!ENTITY pythonhosted-buildsize     "2.2 MB">
  <!ENTITY pythonhosted-time          "TBD SBU)">
]>

<sect2 id="pythonhosted" xreflabel="pythonhosted files">
   <!--<?dbhtml filename="pythonhosted.html"?>-->

  <title>Building pythonhosted.org Files</title>

  <indexterm zone="pythonhosted">
     <primary sortas="a-pythonhosted">pythonhosted</primary>
  </indexterm>

  <sect3 role="package">
   <title>Introduction to pythonhosted.org Files</title>

  <para>
     This section is for user convenience and is optional. 
     It can be used to fetch and install all the pythonhosted.org module 
     packages below in two convenient scripts.
  </para>

  &lfs112_checked;

  <bridgehead renderas="sect4">Package Information</bridgehead>
  <itemizedlist spacing="compact">
    <listitem>
      <para>
        Download (HTTP): &pythonhosted-download-http;
      </para>
    </listitem>
    <listitem>
      <para>
        Download (FTP): <ulink url="&pythonhosted-download-ftp;"/>
      </para>
    </listitem>
    <listitem>
      <para>
        Download MD5 sum: &pythonhosted-md5sum;
      </para>
    </listitem>
    <listitem>
      <para>
        Download size: &pythonhosted-size;
      </para>
    </listitem>
    <listitem>
      <para>
        Estimated disk space required: &pythonhosted-buildsize;
      </para>
    </listitem>
    <listitem>
      <para>
        Estimated build time: &pythonhosted-time;
      </para>
    </listitem>
  </itemizedlist>

  <bridgehead renderas="sect4">Pythonhosted.org Dependencies</bridgehead>

  <bridgehead renderas="sect5">Required</bridgehead>
  <para role="required">
    TBD
    <!--<xref linkend="fontforge"/>,-->
    <!-- does not seem to be needed as of 5.22.4 <xref linkend="GConf"/>, -->
  </para>

  <bridgehead renderas="sect5">Recommended</bridgehead>
  <para role="recommended">
     TBD
     <!--<xref linkend="fftw"/>,-->
  </para>

  <bridgehead renderas="sect5">Optional</bridgehead>
  <para role="optional">
     TBD
     <!--
    <xref linkend="glu"/>,
    <ulink url="http://www.dest-unreach.org/socat/">socat</ulink> (for pam_kwallet)-->
  </para>
  <!--
  <para condition="html" role="usernotes">User Notes:
  <ulink url="&blfs-wiki;/pythonhosted"/></para>
  -->
  </sect3>

   <sect3>
    <title>Downloading All Pythonhosted Module Files</title>

    <para>
      The easiest way to install the modules from the files.pythonhosted.org site
      is to run a script to install them all at once. 
    </para>

    <para>
      The order of building files is important due to internal dependencies.
      First, create the list of files in the proper order as follows:
    </para>

<screen><userinput>cat &gt; pythonhosted-files.md5 &lt;&lt; "EOF"
<literal>]]></xsl:variable>
  <xsl:variable name="part2"><![CDATA[</literal>
EOF</userinput></screen>

    <para>
      Next, create a script to fetch the files:
    </para>

    <screen><userinput>cat &gt; get-pythonhosted-files.sh &lt;&lt; "EOF"
<literal>#! /bin/bash 

PYTHONHOSTED=https://files.pythonhosted.org/packages/source

mkdir -p pythonhosted
cd pythonhosted

for package in $(grep -v '^#' ../pythonhosted-files.md5 | awk '{print $2}')
do
  # Don't try to get a package that is already present
  [ -e $package ] &amp;&amp; continue
  basename=$(echo $package|sed 's/-[[:digit:]].*$//')
  basechar=$(echo $basename|cut -c 1)
  url=$PYTHONHOSTED/$basechar/$basename/$package
  wget $url
done
EOF</literal></userinput></screen>

    <para>
      Run the script and check the files:
    </para>

   <screen><userinput>bash get-pythonhosted-files.sh &amp;&amp;
   md5sum -c ../pythonhosted-files.md5</userinput></screen>

   </sect3>

  <sect3 role="installation">
    <title>Installation of Pythonhosted Modules</title>

    <para>
      Set up a script to install all of the packages:
    </para>

    <screen><userinput>cat &gt; install-pythonhosted-files.sh &lt;&lt; "EOF"
<literal>#! /bin/bash

cd pythonhosted

for package in $(grep -v '^#' ../pythonhosted-files.md5 | awk '{print $2}')
do
  name=$(echo $package|sed 's/-[[:digit:]].*$//')

  # Don't try to install the package if it already installed  
  installed=$(pip3 show $name 2&gt; /dev/null | grep Version:)
    
  unset version
  if [ -n $installed ]; then   
    version=$(echo $installed | awk '{print $2}') 
  fi

  if [ -n "$version" ]; then
    if [ ! $(echo $package | grep -q $version) ]; then
      echo $package is already installed
      continue
    fi
  fi

  # Now install the package
  packagedir=${package%.tar.?z*}
  rm -rf $packagedir
  tar -xf $package
  pushd $packagedir
    pip3 wheel -w dist --no-build-isolation --no-deps $PWD
    sudo pip3 install --no-index --find-links dist --no-cache-dir \
                      --no-user --upgrade $name
  popd
done</literal></userinput></screen> 

    <para>
       Now run the script to install the files.  If the script is run 
       multiple times, it will not try to reinstall the modules unless
       the version in the .md5 file has been changed.
    </para>

   <screen><userinput>bash install-pythonhosted-files.sh</userinput></screen>

   <para>Some of the packages have test procedures. See the individual 
   package sections below to run any desired tests.</para>

  </sect3>

  <sect3 role="content">
    <title>Contents</title>

    <para>
       See the contents of the individual package sections below.
    </para>

  </sect3>

</sect2>]]></xsl:variable>

</xsl:stylesheet>
