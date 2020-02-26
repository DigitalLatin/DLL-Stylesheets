<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:teix="http://www.tei-c.org/ns/Examples"
                
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="a rng tei teix"
                version="2.0">
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>
         <p> TEI stylesheet dealing with elements from the namesdates module,
      making LaTeX output. </p>
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
  <xsl:template match="tei:listPerson">
    \begin{enumerate}
      <xsl:apply-templates/>
      \end{enumerate}
  </xsl:template>

  <xsl:template match="tei:listPerson/tei:person">
    <xsl:text>\item \label{</xsl:text><xsl:value-of select="tei:persName/tei:abbr[@type='siglum']"/><xsl:text>} </xsl:text>
    <!-- SJH: This isn't quite doing the trick. Try applying the templates and excluding the abbr. --><xsl:value-of select="tei:persName[not(tei:persName/tei:abbr)]/text()"/>
    <xsl:if test="tei:note">
      <xsl:text> </xsl:text><xsl:value-of select="tei:note"/>
    </xsl:if>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="tei:affiliation|tei:email">
      <xsl:text>\mbox{}\\ </xsl:text>
      <xsl:apply-templates/>
  </xsl:template>
  
  <!-- SJH: Adding instructions for dealing with a persName or placeName element. -->
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process persName or placeName element.</desc>
  </doc>
  
  <xsl:template match="//tei:geogName|tei:persName|tei:placeName">
    <xsl:choose>
      <xsl:when test="@ref">
        <xsl:text>\href{</xsl:text>
        <xsl:value-of select="@ref"/>
        <xsl:text>}{</xsl:text>
        <xsl:choose>
          <xsl:when test="tei:app/tei:lem">
            <xsl:choose>
              <xsl:when test="*">
                <xsl:apply-templates/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="text()"/>
              </xsl:otherwise>
            </xsl:choose>            
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>}</xsl:text>  
      </xsl:when>
      <xsl:when test="*">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="text()"/>
      </xsl:otherwise></xsl:choose>
    
  </xsl:template>
</xsl:stylesheet>
