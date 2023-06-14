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
   <!--<xsl:if test="tei:head"> 
      <xsl:text>\vspace{1.5\baselineskip}</xsl:text>
      <xsl:text>&#10;</xsl:text>
      <xsl:text>\leftline{\large\uppercase{</xsl:text>
      <xsl:for-each select="tei:head">
        <xsl:apply-templates/>
      </xsl:for-each>
      <xsl:text>}} </xsl:text>
      <xsl:text>&#10;</xsl:text>
      <xsl:text>\vspace{0.5\baselineskip}</xsl:text>
    </xsl:if>-->
    <xsl:choose>
      <xsl:when test="//tei:listPerson[@type='characters']">
        <xsl:text>&#10;{\large \scshape{</xsl:text>
        <xsl:value-of select="tei:head"/>
        <xsl:text>}&#10;\begin{itemize}&#10;</xsl:text>
        <xsl:for-each select="tei:person">
          <xsl:text>\item[] </xsl:text><xsl:call-template name="person"/><xsl:text>&#10;</xsl:text>
        </xsl:for-each>
        <xsl:text>\end{itemize}</xsl:text>
      </xsl:when>
      <xsl:when test="ancestor::tei:div[@xml:id='bibliography']">
        <xsl:text>&#10;\begin{bibitemlist}{1}&#10;</xsl:text>
        <xsl:for-each select="tei:person">
          <xsl:text>&#10;\bibitem</xsl:text>
          <xsl:call-template name="person"/>      
        </xsl:for-each>
        <xsl:text>\end{bibitemlist}&#10;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>\begin{itemize}&#10;</xsl:text>
        <xsl:for-each select="tei:person">
          <xsl:text>&#10;\item</xsl:text><xsl:call-template name="person"/>          
        </xsl:for-each>
        <xsl:text>\end{itemize}</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="//tei:person" name="person">
    <xsl:choose>
      <xsl:when test="parent::tei:listPerson[@type='characters']">
        <xsl:text>\hypertarget{</xsl:text><xsl:value-of select="@xml:id"/><xsl:text>}{</xsl:text><xsl:value-of select="descendant::tei:persName/text()"/><xsl:text>}</xsl:text>
      </xsl:when>
      <xsl:when test="ancestor::tei:div[@xml:id='bibliography-list-of-people']">
        <xsl:text>[</xsl:text><xsl:value-of select="descendant::tei:persName/tei:abbr[@type='siglum']"/><xsl:text>]{</xsl:text><xsl:value-of select="@xml:id"/><xsl:text>}  </xsl:text>
        <xsl:value-of select="descendant::tei:persName/text()"/>
        <xsl:text>. </xsl:text><xsl:apply-templates select="descendant::tei:note"/>
        <xsl:text>&#10;</xsl:text>
      </xsl:when>
      <!-- When the listPerson is just a list of names (e.g., in the front or back mater) -->
      <xsl:when test="ancestor::tei:front or ancestor::tei:back">
        <xsl:text>[</xsl:text><xsl:value-of select="child::tei:persName/tei:abbr[@type='siglum']"/><xsl:text>]{</xsl:text><xsl:value-of select="@xml:id"/><xsl:text>}</xsl:text>
        <xsl:choose>
          <xsl:when test="child::tei:persName/(tei:surname or tei:forename or tei:addName)">
            <xsl:if test="child::tei:persName/tei:surname and child::tei:persName/tei:addname">
              <xsl:value-of select="child::tei:persName/tei:surname"/><xsl:text> </xsl:text><xsl:value-of select="child::tei:persName/tei:addName"/><xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:if test="child::tei:persName/tei:surname and not(child::tei:persName/tei:addName)">
              <xsl:value-of select="child::tei:persName/tei:surname"/><xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:if test="child::tei:persName/tei:addName and not(child::tei:persName/tei:surname)">
              <xsl:value-of select="child::tei:persName/tei:addName"/><xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:if test="child::tei:persName/tei:forename">
              <xsl:value-of select="child::tei:persName/tei:forename"/><xsl:text> </xsl:text>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="child::tei:persName/text()"/>
          </xsl:otherwise>
        </xsl:choose>     
        <xsl:text>&#10;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>[</xsl:text><xsl:value-of select="descendant::tei:persName/tei:abbr[@type='siglum']"/><xsl:text>]{</xsl:text><xsl:value-of select="@xml:id"/><xsl:text>}  </xsl:text>
        <xsl:value-of select="descendant::tei:persName/text()"/>
        <xsl:text>. </xsl:text><xsl:apply-templates select="descendant::tei:note"/>
        <xsl:text>&#10;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
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
        <xsl:text>\ref{</xsl:text>
        <xsl:value-of select="translate(@ref,'#','')"/>
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
