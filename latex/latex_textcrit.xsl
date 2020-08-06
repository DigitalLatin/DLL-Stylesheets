<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
  xmlns:rng="http://relaxng.org/ns/structure/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:teix="http://www.tei-c.org/ns/Examples" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="a rng tei teix" version="2.0">
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
    <desc>
      <p> TEI stylesheet dealing with elements from the textcrit module, making LaTeX output. </p>
      <p>This software is dual-licensed: 1. Distributed under a Creative Commons
        Attribution-ShareAlike 3.0 Unported License http://creativecommons.org/licenses/by-sa/3.0/
        2. http://www.opensource.org/licenses/BSD-2-Clause Redistribution and use in source and
        binary forms, with or without modification, are permitted provided that the following
        conditions are met: * Redistributions of source code must retain the above copyright notice,
        this list of conditions and the following disclaimer. * Redistributions in binary form must
        reproduce the above copyright notice, this list of conditions and the following disclaimer
        in the documentation and/or other materials provided with the distribution. This software is
        provided by the copyright holders and contributors "as is" and any express or implied
        warranties, including, but not limited to, the implied warranties of merchantability and
        fitness for a particular purpose are disclaimed. In no event shall the copyright holder or
        contributors be liable for any direct, indirect, incidental, special, exemplary, or
        consequential damages (including, but not limited to, procurement of substitute goods or
        services; loss of use, data, or profits; or business interruption) however caused and on any
        theory of liability, whether in contract, strict liability, or tort (including negligence or
        otherwise) arising in any way out of the use of this software, even if advised of the
        possibility of such damage. </p>
      <p>Author: See AUTHORS</p>
      <p>Copyright: 2013, TEI Consortium</p>
    </desc>
  </doc>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>
      <p>Override common_textcrit.xsl's template for tei:app.</p>
      <p>This is needed especially to avoid rendering tei:app with @type="transposition", since PDF
        output can't render dynamic swapping of readings.</p>
    </desc>
  </doc>
  <xsl:template match="tei:app">
    <!-- If the lem or rdg contains l, p, ab, or div, just apply templates-->
    <xsl:choose>
      <xsl:when test="@type = 'split-entry'">
        <xsl:value-of select="child::tei:lem"/>
      </xsl:when>
      <xsl:when test="tei:app[not(tei:lem) and not(@type = 'transposition')]">
        <xsl:variable name="appnote">
          <xsl:copy>
            <tei:lem rend="none"> </tei:lem>
            <xsl:copy-of select="*"/>
          </xsl:copy>
        </xsl:variable>
        <xsl:apply-templates select="$appnote"/>
      </xsl:when>
      <xsl:when
        test="
          (tei:lem | tei:rdg)/(tei:l | tei:p | tei:ab | tei:div)
          or tei:rdgGrp/(tei:lem | tei:rdg)/(tei:l | tei:p | tei:ab | tei:div)
          or not(tei:lem)">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <!-- If the app has @type='transposition', don't render it, since PDF can't do dynamic swapping. -->
        <xsl:if test="not(@from) or not(@type = 'transposition')">
          <xsl:call-template name="makeAppEntry">
            <xsl:with-param name="lemma">
              <xsl:call-template name="appLemma"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>
      <p>Assemble the lemma, its witnesses and sources, and any notes or witDetails associated with
        it.</p>
    </desc>
    <param name="lemma">The parameter 'lemma' is used in the "makeAppEntry" template in
      common/common_textcrit.xsl.</param>
  </doc>
  <xsl:template name="appLemma">
    <xsl:param name="lemma"/>
    <xsl:for-each select="tei:lem">
      <xsl:text>\edtext</xsl:text>
      <xsl:text>{</xsl:text>
      <!-- If a lemma is split across xml tags, join the previous one to the current one. -->
      <xsl:if test="contains(@prev, ancestor::tei:seg/preceding-sibling::tei:seg[1]/tei:app[@type = 'split-entry']/tei:lem/@xml:id)">
        <xsl:apply-templates select="ancestor::tei:seg/preceding-sibling::tei:seg[1]/tei:app[last()]/tei:lem"/>
        <xsl:text> </xsl:text>
      </xsl:if>
      <!-- The lemma -->
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
      <!-- Logic for handling various scenarios where the lemma in the app is different from the lemma in the text. -->
        <xsl:choose>
          <xsl:when test="following-sibling::tei:note[@type='commentary']">
            <!-- If there is a note with a pointer to the commentary, there needs to be a link to it and the symbol ◊, then the lemma -->
            <xsl:text>{\lemma{{\hyperref[</xsl:text>
            <xsl:value-of select="translate(following-sibling::tei:note[@type='commentary']/tei:ptr/@target, '#', '')"/>
            <xsl:text>]{◊}} </xsl:text>
            <xsl:apply-templates select="self::tei:lem"/>
            <xsl:text>}</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <!-- Otherwise, just open the bracket for the Afootnote string. -->
            <xsl:text>{</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      <!-- \Afootnote{} is where a note should be placed. -->
      <xsl:text>\Afootnote</xsl:text>
      <!-- Logic for handling a lemma with or without witness or source -->
      <xsl:choose>
        <!-- If the lemma doesn't have a witness or a source, just insert the lemma, followed by ]. -->
        <xsl:when test="not(@wit) and not(@source)">
          <xsl:if test="tei:lem[@rend = 'none']">
            <xsl:text/>
          </xsl:if>
          <xsl:text>{</xsl:text>
        </xsl:when>
        <!-- Otherwise, print the lemma without ], followed by witnesses and sources -->
        <xsl:otherwise>
          <xsl:text>[nosep]</xsl:text>
          <xsl:if test="tei:lem[@rend = 'none']">
            <xsl:text>\Xlemmaseparator[ | ]</xsl:text>
          </xsl:if>
          <xsl:text>{</xsl:text>
          <!-- Get the witnesses and sources and format them. -->
          <xsl:text>\textit{</xsl:text>
          <xsl:value-of select="tei:getWitness(@wit, .)"/>
          <xsl:if test="@wit and @source">
            <xsl:text> </xsl:text>
          </xsl:if>
          <xsl:value-of select="tei:getWitness(@source, ., ' ')"/>
          <xsl:text>}</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
        <!-- If a note is associated with the lemma, render it. -->
        <!-- There are two scenarios: witDetail is the next sibling to lem, and note is the one after that: -->
        <xsl:if
          test="following-sibling::*[1][self::tei:witDetail] and following-sibling::*[2][self::tei:note]">
          <!-- If the note begins with a comma, don't leave a space in front of it. If it doesn't, don't insert an extra space. -->
          <xsl:choose>
            <xsl:when test="starts-with(following-sibling::*[2][self::tei:note], ',')">
              <xsl:text>\textit{</xsl:text>
              <xsl:apply-templates select="following-sibling::*[2][self::tei:note]"/>
              <xsl:text>}</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text> \textit{</xsl:text>
              <xsl:apply-templates select="following-sibling::*[2][self::tei:note]"/>
              <xsl:text>}</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        <!-- … or note is the immediately following sibling to lem. -->
      <xsl:if test="following-sibling::*[1][self::tei:note] and not(following-sibling::*[1][self::tei:note/@type='commentary'])">
          <xsl:choose>
            <xsl:when test="starts-with(following-sibling::*[1][self::tei:note], ',')">
              <xsl:text>\textit{</xsl:text>
              <xsl:apply-templates select="following-sibling::*[1][self::tei:note]"/>
              <xsl:text>}</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text> \textit{</xsl:text>
              <xsl:apply-templates select="following-sibling::*[1][self::tei:note]"/>
              <xsl:text>}</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        <!-- If a reading follows the lemma, insert a vertical bar separator to indicate the end of the lemma data. -->
        <xsl:if test="following-sibling::tei:rdg">
          <xsl:text> | </xsl:text>
        </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
    <xsldoc:desc>Insert a symbol and a hyperlink to a note in the commentary.</xsldoc:desc>
  </xsldoc:doc>
  <!--<xsl:template match="tei:lem/tei:ptr">
    <xsl:value-of select=".."/>
    <xsl:text>}</xsl:text>
    <xsl:text>{\lemma{{\hyperref[</xsl:text>
    <xsl:value-of select="translate(@target, '#', '')"/>
    <xsl:text>]{◊}} </xsl:text>
  </xsl:template>-->

  <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
    <xsldoc:desc>
      <p>Process each rdg, along with its witnesses, sources, notes, etc.</p>
    </xsldoc:desc>
  </xsldoc:doc>
  <xsl:template name="appReadings">
    <!-- Start by selecting just the rdg … -->
    <xsl:for-each select="tei:rdg">
      <!-- If a note precedes the reading and its @target points to the reading, render it first. -->
      <xsl:if test="preceding-sibling::tei:note[substring(@target,2) = current()/@xml:id]">
        <xsl:text>\textit{</xsl:text>
        <xsl:apply-templates select="preceding-sibling::tei:note[1]"/>
        <xsl:text>} </xsl:text>
      </xsl:if>
      <xsl:choose>
        <!-- If the reading is empty, insert "om." -->
        <xsl:when test="not(node())">
          <xsl:text>om.</xsl:text>
        </xsl:when>
        <!-- Otherwise, render the reading -->
        <xsl:otherwise>
          <xsl:apply-templates select="."/>
        </xsl:otherwise>
      </xsl:choose>
      <!-- Get the witnesses and sources and format them. -->
      <xsl:if test="@wit">
        <xsl:text> \textit{</xsl:text>
        <xsl:value-of select="tei:getWitness(@wit, .)"/>
        <xsl:text>}</xsl:text>
      </xsl:if>
      <xsl:if test="@source">
        <xsl:text> \textit{</xsl:text>
        <xsl:value-of select="tei:getWitness(@source, ., ' ')"/>
        <xsl:text>}</xsl:text>
      </xsl:if>
      <!-- Now look for a note that follows the reading. If there is one, render it. -->
      
      <!-- Test to account for situations where there is a witDetail following the rdg before the note. -->
      <xsl:if test="preceding-sibling::tei:note[substring(@target,2) = current()/@xml:id]">
        <!-- If a witDetail precedes the note, process it. -->
        <xsl:choose>
          <xsl:when test="following-sibling::*[1][self::tei:witDetail] and following-sibling::*[2][self::tei:note]">
            <xsl:choose>
              <!-- If the note begins with a comma, don't leave a space in front of it. If it doesn't, don't insert an extra space. -->
              <xsl:when test="starts-with(following-sibling::*[2][self::tei:note], ',')">
                <xsl:text>\textit{</xsl:text>
                <xsl:apply-templates select="following-sibling::*[2][self::tei:note]"/>
                <xsl:text>}</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text> \textit{</xsl:text>
                <xsl:apply-templates select="following-sibling::*[2][self::tei:note]"/>
                <xsl:text>}</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <!-- If note is the immediately following sibling to rdg, process it. -->
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="starts-with(following-sibling::*[1][self::tei:note], ',')">
                <xsl:text>\textit{</xsl:text>
                <xsl:apply-templates select="following-sibling::*[1][self::tei:note]"/>
                <xsl:text>}</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text> \textit{</xsl:text>
                <xsl:apply-templates select="following-sibling::*[1][self::tei:note]"/>
                <xsl:text>}</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <!-- If the combination of rdg and note is not the last one, put a separator before the next one. -->
      <xsl:choose>
        <xsl:when test="not(position() = last())">
          <!-- If the last two rdgs are part of a list of conjectures,
            and therefore shouldn't be separated by a vertical bar,
            don't insert a vertical bar. -->
          <xsl:choose>
            <xsl:when test="self::tei:rdg[@type='conjecture'] and following-sibling::tei:rdg[@type='conjecture']">
              <xsl:text> </xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text> | </xsl:text>
            </xsl:otherwise></xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <!-- If there's a note of the type "alii alia" that should really count as a reading, insert a separator followed by the note. -->
          <xsl:if test="following-sibling::tei:note[last() and not(@target)]">
            <xsl:text> | \textit{</xsl:text>
            <xsl:apply-templates select="following-sibling::tei:note[last() and not(@target)]"/>
            <xsl:text>}</xsl:text>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
    <xsldoc:desc>
      <p>Assemble the apparatus entry (lem, readings, notes, etc.)</p>
    </xsldoc:desc>
    <xsldoc:param name="lemma">The parameter 'lemma' occurs in the appLemma template
      above.</xsldoc:param>
  </xsldoc:doc>
  <!-- The goal: \edtext{lemma}{ \Afootnote {\textit{witnesses} \textit{sources} \textit{note} | reading \textit{witness} \textit{source} \textit{note} | reading \textit{witness} \textit{source} \textit{note}}} -->
  <xsl:template name="makeAppEntry">
    <xsl:param name="lemma"/>
    <xsl:call-template name="appLemma"/>
    <xsl:if test="tei:rdg">
      <xsl:call-template name="appReadings"/>
    </xsl:if>
    <!-- Close the apparatus note. -->
    <xsl:text>}}</xsl:text>
  </xsl:template>

  <xsl:template match="tei:div[@type = 'edition']/tei:div">
    <xsl:apply-templates select="tei:head"/>
    <xsl:choose>
      <!-- poetry -->
      <xsl:when test="tei:l | tei:lg">&#10; \beginnumbering &#10;\pstart <xsl:apply-templates
          select="*[not(self::tei:head)]"/> \pend \endnumbering </xsl:when>
      <!-- prose -->
      <xsl:when test="tei:p | tei:ab"> \beginnumbering <xsl:apply-templates
          select="*[not(self::tei:head)]"/> \endnumbering </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Don't render these elements. -->
  <xsl:template match="tei:note[parent::tei:app//(tei:l | tei:p)]"/>
  <xsl:template match="tei:witDetail[parent::tei:app//(tei:l | tei:p)]"/>
  <xsl:template match="tei:wit[parent::tei:app//(tei:l | tei:p)]"/>
  <xsl:template match="tei:rdg[parent::tei:app//(tei:l | tei:p)]"/>
  <xsl:template match="tei:rdgGrp[parent::tei:app//(tei:l | tei:p)]"/>

  <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
    <xsldoc:desc>
      <p>One part of dealing with generating a siglum from an item in the bibliography.</p>
    </xsldoc:desc>
  </xsldoc:doc>
  <xsl:template match="tei:abbr[@type = 'siglum']">
    <xsl:apply-templates/>
  </xsl:template>

  <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
    <xsldoc:desc>
      <p>Another part of dealing with generating a siglum from an item in the bibliography.</p>
    </xsldoc:desc>
  </xsldoc:doc>
  <xsl:template match="tei:bibl/tei:abbr[@type = 'siglum'] | tei:witness/tei:abbr[@type = 'siglum']"
    > [<xsl:apply-templates/>]<xsl:text>{</xsl:text><xsl:value-of select="../@xml:id"
    /><xsl:text>} </xsl:text>
  </xsl:template>

  <xsl:template match="tei:l[ancestor::tei:app and not(@processed)]">
    <xsl:variable name="self" select="."/>
    <xsl:if test="parent::tei:lem">
      <xsl:variable name="elt">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:attribute name="processed">yes</xsl:attribute>
          <xsl:for-each select="ancestor::tei:app">
            <xsl:if test=".//tei:l[1] = $self">
              <app xmlns="http://www.tei-c.org/ns/1.0">
                <xsl:copy-of select="@*"/>
                <lem rend="none">
                  <xsl:choose>
                    <xsl:when test="count(tei:lem/tei:l) gt 1">
                      <xsl:text>ll. </xsl:text><xsl:value-of select="$self/@n"/>–<xsl:value-of
                        select="tei:lem/tei:l[last()]/@n"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>l. </xsl:text>
                      <xsl:value-of select="$self/@n"/>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:if test="tei:lem[not((* | text()))]">
                    <xsl:text> om.</xsl:text>
                  </xsl:if>
                </lem>
                <xsl:for-each select="*">
                  <xsl:choose>
                    <xsl:when test="self::tei:rdg and not((* | text()))">
                      <xsl:copy><xsl:copy-of select="@*"/>om. </xsl:copy>
                    </xsl:when>
                    <xsl:when test="self::tei:lem"/>
                    <xsl:when test="self::tei:rdg[not(tei:l)]">
                      <xsl:copy-of select="."/>
                    </xsl:when>
                    <xsl:when test="self::tei:rdg"/>
                    <xsl:when test="self::tei:rdgGrp"/>
                    <xsl:otherwise>
                      <xsl:copy-of select="."/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </app>
            </xsl:if>
          </xsl:for-each>
          <xsl:copy-of select="* | text()"/>
        </xsl:copy>
      </xsl:variable>
      <xsl:apply-templates select="$elt"/>
    </xsl:if>
  </xsl:template>


  <!--<xsl:template match="tei:lg">
    <xsl:choose>
      <xsl:when test="count(key('APP',1))&gt;0">
        <xsl:variable name="c" select="(count(tei:l)+1) div 2"/>
        <xsl:text>\setstanzaindents{1,1,0}</xsl:text>
        <xsl:text>\setcounter{stanzaindentsrepetition}{</xsl:text>
        <xsl:value-of select="$c"/>
        <xsl:text>}</xsl:text>
        <xsl:text>\stanza&#10;</xsl:text>
        <xsl:for-each select="tei:l">
          <xsl:if test="parent::tei:lg/@xml:lang='Av'">{\itshape </xsl:if>
          <xsl:apply-templates/>
          <xsl:if test="parent::tei:lg/@xml:lang='Av'">}</xsl:if>
          <xsl:if test="following-sibling::tei:l">
            <xsl:text>&amp;</xsl:text>
          </xsl:if>
        </xsl:for-each>
        <xsl:text>\&amp;&#10;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>-->

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>
      <p>Handle text within a note in the apparatus that must be rendered in a roman font (e.g.,
        Latin text).</p>
    </desc>
  </doc>
  <xsl:template
    match="tei:app/tei:note/tei:hi[@rend = 'normal'] | tei:app/tei:witDetail/tei:hi[@rend = 'normal']">
    <xsl:text>{\normalfont </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>
      <p>Process with witStart</p>
    </desc>
  </doc>
  <xsl:template match="tei:witStart">
    <xsl:text>\textit{hinc adest} </xsl:text>
    <xsl:value-of select="translate(ancestor::rdg[1]/@wit, '#', '')"/>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>
      <p>Process with witEnd</p>
    </desc>
  </doc>
  <xsl:template match="tei:witEnd">
    <xsl:text>\textit{hinc deest} </xsl:text>
    <xsl:value-of select="translate(ancestor::rdg[1]/@wit, '#', '')"/>
  </xsl:template>
</xsl:stylesheet>
