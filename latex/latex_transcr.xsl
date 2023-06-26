<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
                xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:teix="http://www.tei-c.org/ns/Examples"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="a rng tei teix"
                version="2.0">
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>
         <p>
    TEI stylesheet
    dealing  with elements from the
    transcr module, making LaTeX output.
      </p>
         <p>This software is dual-licensed:

1. Distributed under a Creative Commons Attribution-ShareAlike 3.0
Unported License http://creativecommons.org/licenses/by-sa/3.0/ 

2. http://www.opensource.org/licenses/BSD-2-Clause
		


Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

* Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

This software is provided by the copyright holders and contributors
"as is" and any express or implied warranties, including, but not
limited to, the implied warranties of merchantability and fitness for
a particular purpose are disclaimed. In no event shall the copyright
holder or contributors be liable for any direct, indirect, incidental,
special, exemplary, or consequential damages (including, but not
limited to, procurement of substitute goods or services; loss of use,
data, or profits; or business interruption) however caused and on any
theory of liability, whether in contract, strict liability, or tort
(including negligence or otherwise) arising in any way out of the use
of this software, even if advised of the possibility of such damage.
</p>
         <p>Author: See AUTHORS</p>
         
         <p>Copyright: 2013, TEI Consortium</p>
      </desc>
   </doc>

  <xsl:template match="tei:facsimile"/>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Handle abbr</desc>
  </doc>
  <xsl:template match="tei:abbr">
    <xsl:choose>
      <xsl:when test="ancestor::tei:app">
        <xsl:text> \textit{(orig. \textup{</xsl:text><xsl:apply-templates/><xsl:text>})}</xsl:text>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Handle choice</desc>
  </doc>
  <xsl:template match="tei:choice">
    <xsl:choose>
      <xsl:when test="ancestor::tei:app">
        <xsl:if test="child::tei:sic">
          <xsl:apply-templates select="child::tei:corr"/><xsl:text> \textit{(\textup{</xsl:text><xsl:apply-templates select="child::tei:sic"/><xsl:text>} a.c.)}</xsl:text>
        </xsl:if>
        <xsl:if test="child::tei:expan">
          <xsl:apply-templates select="child::tei:expan"/><xsl:apply-templates select="child::tei:abbr"/>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="child::tei:sic">
          <xsl:apply-templates select="child::tei:corr"/>
        </xsl:if>
        <xsl:if test="child::tei:expan">
          <xsl:apply-templates select="child::tei:expan"/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Handle corr</desc>
  </doc>
  <xsl:template match="tei:corr">
    <xsl:apply-templates/>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element del</desc>
  </doc>
  <xsl:template match="tei:dell[tei:match(@rend, 'strikethrough')]">
    <xsl:text>\sout{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Handle ex</desc>
  </doc>
  <xsl:template match="tei:ex">
    <xsl:text>\expan{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Handle expan</desc>
  </doc>
  <xsl:template match="tei:expan">
    <xsl:apply-templates/>
  </xsl:template>
   
  <!-- SJH: added templates for handling editorial symbols. -->
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>
      <p>Process gap</p>
    </desc>
  </doc>
  <xsl:template match="tei:gap">
    <xsl:text>\gap{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process tei:g to produce specific glyphs.</desc>
  </doc>
  <xsl:template match="//tei:g">
    <xsl:choose>
      <!-- Punctus elevatus -->
      <xsl:when test="@ref='#punctEl'">
        <xsl:text>⸵</xsl:text>
      </xsl:when>
      <!-- Siglum -->
      <xsl:when test="@ref='#sigillvm'">
        <xsl:text>✠</xsl:text>
      </xsl:when>
    </xsl:choose>  
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>
      <p>Process lacunaStart</p>
    </desc>
  </doc>
  <!-- Note: Logic needed here to distinguish between single (deest) and multiple (desunt) witnesses. -->
  <xsl:template match="tei:lacunaStart">
    <xsl:text>\textit{deest}</xsl:text>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>
      <p>Process lacunaEnd</p>
    </desc>
  </doc>
  <!-- Note: Logic needed here to distinguish between single (redit) and multiple (redeunt) witnesses. -->
  <xsl:template match="tei:lacunaEnd">
    <xsl:text>\textit{redit}</xsl:text>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Handle mentioned</desc>
  </doc>
  <xsl:template match="tei:mentioned">
    <xsl:text>\textit{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Handle sic</desc>
  </doc>
  <xsl:template match="//tei:sic">
    <xsl:text>\sic{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Handle supplied.</desc>
  </doc>
  <xsl:template match="//tei:supplied">
    <xsl:text>\supplied{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Handle surplus.</desc>
  </doc>
  <xsl:template match="//tei:surplus">
    <xsl:text>\surplus{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>

</xsl:stylesheet>
