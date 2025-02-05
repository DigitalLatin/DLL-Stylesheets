<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
  xmlns:rng="http://relaxng.org/ns/structure/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:teix="http://www.tei-c.org/ns/Examples" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="a rng tei teix" version="2.0">
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
    <desc>
      <p> TEI stylesheet dealing with elements from the core module, making LaTeX output. </p>
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
    <desc>Process element ab</desc>
  </doc>
  <xsl:template match="tei:ab">
    <xsl:apply-templates/>
    <xsl:if test="following-sibling::tei:ab">\par </xsl:if>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element bibl in "cite" mode.</desc>
  </doc>
  <xsl:template match="tei:bibl" mode="cite">
    <xsl:apply-templates select="text()[1]"/>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element cit</desc>
  </doc>
  <xsl:template match="tei:cit">
    <!-- Apply templates to child nodes of <cit> with mode -->
    <xsl:apply-templates mode="quoteProcessing"/>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element quote when child of cit</desc>
  </doc>
  <xsl:template match="tei:quote" mode="quoteProcessing">
    <!-- Apply templates only to text and 'lem' that are not descendants of 'rdg' -->
    <xsl:if test="preceding-sibling::tei:bibl">
      <xsl:text>\edtext{\textzwnj}{\lemma{\textzwnj}\Afootnote[nosep]{</xsl:text>
        <xsl:for-each select="preceding-sibling::tei:bibl">
          <xsl:call-template name="citbibl">
            <xsl:with-param name="bibl-node" select="tei:bibl"/>
          </xsl:call-template>
        </xsl:for-each>
      <xsl:text>}}</xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@rend='blockquote'">
        <xsl:text>\begin{displayquote}</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>\end{displayquote}</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>``</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>''</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="following-sibling::tei:bibl">
      <xsl:text>\edtext{\textzwnj}{\lemma{\textzwnj}\Afootnote[nosep]{</xsl:text>
        <xsl:for-each select="following-sibling::tei:bibl">
          <xsl:call-template name="citbibl">
            <xsl:with-param name="bibl-node" select="tei:bibl"/>
          </xsl:call-template>
        </xsl:for-each>
      <xsl:text>}}</xsl:text>
    </xsl:if>
  </xsl:template>
  
  <!--<doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element lem when descendant of cit</desc>
  </doc>
  <xsl:template match="tei:lem[not(ancestor::tei:rdg)]" mode="quoteProcessing">
    <xsl:apply-templates />
  </xsl:template>
  -->
  <!--<doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process all children of lem except app when descendant of cit</desc>
  </doc>
  <xsl:template match="child::tei:lem[not(ancestor::tei:rdg)]/*[not(self::tei:app)]" mode="quoteProcessing">
    <xsl:apply-templates />
    <xsl:text> </xsl:text>
  </xsl:template>-->
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element bibl when child of cit</desc>
  </doc>
  <xsl:template name="citbibl">
    <xsl:param name="bibl-node"/>  
    <xsl:if test="tei:author">
        <xsl:for-each select="tei:author">
          <xsl:choose>
            <xsl:when test="@role='vertit'">
              <xsl:text>(</xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:text>)</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="normalize-space(.)"/>  
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text> </xsl:text>
        </xsl:for-each>
      </xsl:if>
      <xsl:if test="tei:title"><xsl:text>\textit{</xsl:text><xsl:value-of select="normalize-space(tei:title)"/><xsl:text>} </xsl:text></xsl:if>
      <xsl:if test="tei:biblScope">
        <xsl:for-each select="tei:biblScope">
          <xsl:value-of select="normalize-space(.)"/>
          <xsl:if test="position() != last()">.</xsl:if>
          <xsl:if test="position() = last()">. </xsl:if>
        </xsl:for-each>
      </xsl:if>
      <xsl:if test="tei:note">
        <xsl:apply-templates select="tei:note"/>     
      </xsl:if>
      <xsl:if test="not(position() = last())">
        <xsl:text>; </xsl:text>
      </xsl:if>
    <xsl:apply-templates select="$bibl-node"/>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Don't process element cit/bibl independently</desc>
  </doc>
  <xsl:template match="tei:cit/tei:bibl" mode="quoteProcessing"/>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element ref when child of cit</desc>
  </doc>
  <xsl:template match="tei:ref" mode="quoteProcessing">
    <xsl:apply-templates select="."/>
  </xsl:template>

  <!--<doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element bibl when child of cit</desc>
  </doc>
  <xsl:template match="tei:bibl" mode="quoteProcessing">
    <xsl:apply-templates/>
  </xsl:template>-->

  <!--<doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Part of the processing to get just the text of quote as child of cit</desc>
  </doc>
  <xsl:template match="text()" mode="quoteProcessing">
    <!-\- Output the text node -\->
    <xsl:value-of select="normalize-space(.)"/>
    <!-\- Add a space after the text, if it is not empty -\->
    <xsl:if test="normalize-space(.) != ''">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>-->
  
 <!-- <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process only the immediate child text nodes of lem in cit/quote</desc>
  </doc>
  <xsl:template match="tei:lem[not(ancestor::tei:rdg)]" mode="quoteProcessing">
    <!-\- Process only the immediate child text nodes of 'lem' -\->
    <xsl:for-each select="text()">
      <xsl:value-of select="normalize-space(.)"/>
      <xsl:if test="position() != last()">
        <xsl:text> </xsl:text>
      </xsl:if>
    </xsl:for-each>
    <!-\- Check if there are any text nodes to avoid adding extra space -\->
    <xsl:if test="text()">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>-->
  
  <!--<doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Ignore rdg, bibl, and ref in cit/quote in quoteProcessing mode</desc>
  </doc>
  <xsl:template match="tei:rdg|tei:bibl" mode="quoteProcessing"/>
  -->
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element code</desc>
  </doc>
  <xsl:template match="tei:code">
    <xsl:text>\texttt{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element eg|tei:q[tei:match(@rend,'eg')]</desc>
  </doc>
  <xsl:template match="tei:seg[tei:match(@rend, 'pre')] | tei:eg | tei:q[tei:match(@rend, 'eg')]">
    <xsl:variable name="stuff">
      <xsl:apply-templates mode="eg"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="ancestor::tei:cell and count(*) = 1 and string-length(.) &lt; 60">
        <xsl:text>\fbox{\ttfamily </xsl:text>
        <xsl:value-of select="tei:escapeCharsVerbatim($stuff)"/>
        <xsl:text>} </xsl:text>
      </xsl:when>
      <xsl:when test="ancestor::tei:cell and not(*) and string-length(.) &lt; 60">
        <xsl:text>\fbox{\ttfamily </xsl:text>
        <xsl:value-of select="tei:escapeCharsVerbatim($stuff)"/>
        <xsl:text>} </xsl:text>
      </xsl:when>
      <xsl:when test="ancestor::tei:cell or tei:match(@rend, 'pre')">
        <xsl:text>\mbox{}\hfill\\[-10pt]\begin{Verbatim}[fontsize=\small]
</xsl:text>
        <xsl:copy-of select="$stuff"/>
        <xsl:text>
\end{Verbatim}
</xsl:text>
      </xsl:when>
      <xsl:when test="ancestor::tei:list[@type = 'gloss']">
        <xsl:text>\hspace{1em}\hfill\linebreak</xsl:text>
        <xsl:text>\bgroup\exampleFont</xsl:text>
        <xsl:text>\vskip 10pt\begin{shaded}
\noindent\obeyspaces{}</xsl:text>
        <xsl:value-of select="tei:escapeCharsVerbatim($stuff)"/>
        <xsl:text>\end{shaded}
\egroup 
</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>\par\hfill\bgroup\exampleFont</xsl:text>
        <xsl:text>\vskip 10pt\begin{shaded}
\obeyspaces </xsl:text>
        <xsl:value-of select="tei:escapeCharsVerbatim($stuff)"/>
        <xsl:text>\end{shaded}
\par\egroup 
</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element emph</desc>
  </doc>
  <xsl:template match="tei:emph">
    <xsl:text>\textit{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Handle foreign.</desc>
  </doc>
  <xsl:template match="tei:foreign">
    <xsl:choose>
      <!-- If the text is in Greek, don't italicize it. -->
      <xsl:when test="@xml:lang='grc'">
        <xsl:apply-templates/>
      </xsl:when>
      <!-- Otherwise, do italicize it. -->
      <xsl:otherwise>
        <xsl:text>\textit{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process gloss</desc>
  </doc>
  <xsl:template match="tei:gloss">
    <xsl:text> \textit{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element hi</desc>
  </doc>
  <xsl:template match="tei:hi">
    <xsl:call-template name="rendering"/>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Rendering rules, turning @rend into LaTeX commands</desc>
  </doc>
  <xsl:template name="rendering">
    <xsl:variable name="decls">
      <xsl:if test="tei:render-italic(.)">\itshape</xsl:if>
      <xsl:if test="tei:render-bold(.)">\bfseries</xsl:if>
      <xsl:if test="tei:render-typewriter(.)">\ttfamily</xsl:if>
      <xsl:if test="tei:render-smallcaps(.)">\scshape</xsl:if>
      <xsl:for-each select="tokenize(normalize-space(@rend), ' ')">
        <xsl:if test=". = 'large'">\large</xsl:if>
        <xsl:if test=". = 'larger'">\larger</xsl:if>
        <xsl:if test=". = 'small'">\small</xsl:if>
        <xsl:if test=". = 'smaller'">\smaller</xsl:if>
        <xsl:if test="starts-with(., 'color')">
          <xsl:text>\color</xsl:text>
          <xsl:choose>
            <xsl:when test="starts-with(., 'color(')">
              <xsl:text>{</xsl:text>
              <xsl:value-of select="substring-before(substring-after(., 'color('), ')')"/>
              <xsl:text>}</xsl:text>
            </xsl:when>
            <xsl:when test="starts-with(., 'color')">
              <xsl:text>{</xsl:text>
              <xsl:value-of select="substring-after(., 'color')"/>
              <xsl:text>}</xsl:text>
            </xsl:when>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="cmd">
      <xsl:if test="tei:render-strike(.)">\sout </xsl:if>
      <xsl:for-each select="tokenize(normalize-space(@rend), ' ')">
        <xsl:choose>
          <xsl:when test=". = 'calligraphic'">\textcal </xsl:when>
          <xsl:when test=". = 'allcaps'">\uppercase </xsl:when>
          <xsl:when test=". = 'center'">\centerline </xsl:when>
          <xsl:when test=". = 'gothic'">\textgothic </xsl:when>
          <xsl:when test=". = 'noindex'">\textrm </xsl:when>
          <xsl:when test=". = 'overbar'">\textoverbar </xsl:when>
          <xsl:when test=". = 'plain'">\textrm </xsl:when>
          <xsl:when test=". = 'quoted'">\textquoted </xsl:when>
          <xsl:when test=". = 'sub'">\textsubscript </xsl:when>
          <xsl:when test=". = 'subscript'">\textsubscript </xsl:when>
          <xsl:when test=". = 'underline'">\uline </xsl:when>
          <xsl:when test=". = 'sup'">\textsuperscript </xsl:when>
          <xsl:when test=". = 'super'">\textsuperscript </xsl:when>
          <xsl:when test=". = 'superscript'">\textsuperscript </xsl:when>
          <xsl:when test=". = 'wavyunderline'">\uwave </xsl:when>
          <xsl:when test=". = 'doubleunderline'">\uuline </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    <xsl:for-each select="tokenize(normalize-space($cmd), ' ')">
      <xsl:value-of select="concat(., '{')"/>
    </xsl:for-each>
    <xsl:choose>
      <xsl:when test="$decls = ''">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$cmd = ''">
          <xsl:text>{</xsl:text>
        </xsl:if>
        <xsl:value-of select="$decls"/>
        <xsl:if test="matches($decls, '[a-z]$')">
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
        <xsl:if test="$cmd = ''">
          <xsl:text>}</xsl:text>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:for-each select="tokenize(normalize-space($cmd), ' ')">
      <xsl:text>}</xsl:text>
    </xsl:for-each>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element head</desc>
  </doc>
  <xsl:template match="tei:head" name="head">
    <xsl:choose>
      <xsl:when test="parent::tei:castList"/>
      <xsl:when test="parent::tei:figure"/>
      <xsl:when test="parent::tei:list"/>
      <!--<xsl:when test="parent::tei:lg">
        <xsl:text>&#10;\vspace{2\baselineskip} % Whitespace&#10;</xsl:text>
        <xsl:text>&#10;\subsection*{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
        <xsl:text>&#10;\vspace{1\baselineskip} % Whitespace&#10;</xsl:text>
      </xsl:when>-->
      <xsl:when test="parent::tei:table"/>
      <xsl:otherwise>
        <xsl:variable name="depth">
          <xsl:apply-templates mode="depth" select=".."/>
        </xsl:variable>
        <xsl:text>&#10;\</xsl:text>
        <xsl:choose>
          <xsl:when test="$documentclass = 'book'">
            <xsl:choose>
              <xsl:when test="$depth = 0">chapter</xsl:when>
              <xsl:when test="$depth = 1">section</xsl:when>
              <xsl:when test="$depth = 2">subsection</xsl:when>
              <xsl:when test="$depth = 3">subsubsection</xsl:when>
              <xsl:when test="$depth = 4">paragraph</xsl:when>
              <xsl:when test="$depth = 5">subparagraph</xsl:when>
              <xsl:otherwise>section</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="$depth = 0">newpage&#10;\thispagestyle{plain}&#10;\section</xsl:when>
              <xsl:when test="$depth = 1">subsection</xsl:when>
              <xsl:when test="$depth = 2">subsubsection</xsl:when>
              <xsl:when test="$depth = 3">paragraph</xsl:when>
              <xsl:when test="$depth = 4">subparagraph</xsl:when>
              <xsl:otherwise>section</xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:choose>
          <!-- First Order Heads -->
          <xsl:when test="$depth = '0'">
            <xsl:choose>
              <xsl:when test="ancestor::tei:body or tei:back">
                <xsl:text>[{</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>}]{\centering\uppercase{\so{</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>}}}\label{</xsl:text>
                <xsl:value-of select="parent::tei:div/@xml:id"/>
                <xsl:text>}</xsl:text>
                <xsl:text>&#10;\vspace{2\baselineskip} % Whitespace</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>{</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>}</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
              <xsl:when test="ancestor::tei:body">
                <xsl:text>&#10;&#10;\pagestyle{fancy}&#10;
                  &#10;\fancyhead[C]{</xsl:text>
                <xsl:value-of select="self::tei:head"/>
                <xsl:text>}</xsl:text>  
              </xsl:when>
              <!-- This is for the title of a commentary, with a reset of the fancyheader. -->
              <xsl:when test="ancestor::tei:back">
                <xsl:text>&#10;\vspace{2\baselineskip} % Whitespace</xsl:text>
                <xsl:text>&#10;&#10;\pagestyle{fancy}&#10;</xsl:text>
                <xsl:text>&#10;\fancyhead[LE]{\thepage}</xsl:text>
                <xsl:text>&#10;\fancyhead[CE]{</xsl:text>
                <xsl:value-of select="ancestor::tei:div/tei:head"/>
                <xsl:text>}</xsl:text>
                <xsl:text>&#10;\fancyhead[RO]{\thepage}</xsl:text>
                <xsl:text>&#10;\fancyhead[CO]{\rightmark}&#10;</xsl:text>  
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>&#10;&#10;\pagestyle{fancy}&#10;</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>

          <!-- Second Order Heads -->
          <xsl:when test="$depth = '1'">
            <xsl:choose>
              <xsl:when test="ancestor::tei:front">
                <xsl:text>{</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>}&#10;</xsl:text>
              </xsl:when>
              <!-- This is for the title of individual sections of the edition, so that the titles can be included in the apparatus. -->
              <xsl:when test="ancestor::tei:body and parent::tei:div[@type = 'textpart']">
                <xsl:choose>
                  <!-- If there is a child app element, process it -->
                  <xsl:when test="tei:app">
                    <!-- Output the subsection with the value of the descendant lem element -->
                    <xsl:if test="string-length(tei:app/tei:lem) > 20">
                      <xsl:text>[</xsl:text>
                      <xsl:variable name="words" select="tokenize(normalize-space(.), '\s+')"/>
                      <xsl:for-each select="$words[position() &lt;= 3]">
                        <xsl:value-of select="."/>
                        <xsl:if test="position() != last()">
                          <xsl:text> </xsl:text>
                        </xsl:if>
                      </xsl:for-each>
                      <xsl:text> … ]</xsl:text>
                    </xsl:if>
                    <xsl:text>{</xsl:text>
                    <xsl:value-of select="normalize-space(tei:app/tei:lem)"/>
                    <xsl:text>}</xsl:text>
                    <xsl:text>\label{</xsl:text>
                    <xsl:value-of select="parent::tei:div/@xml:id"/>
                    <xsl:text>}</xsl:text>
                    <xsl:text>&#10;\pstart&#10;</xsl:text>
                    <!-- Apply templates only for app and its children -->
                    <xsl:apply-templates select="tei:app"/>
                    <xsl:text>&#10;\pend&#10;</xsl:text>
                  </xsl:when>
                  <!-- Otherwise, just apply the templates -->
                  <xsl:otherwise>
                    <!-- If the value of head is greater than 20 characters, 
                  create a short optional label for the running header at 
                  the top of the page. -->
                    <xsl:if test="string-length(self::tei:head) > 20">
                      <xsl:text>[</xsl:text>
                      <xsl:variable name="words" select="tokenize(normalize-space(.), '\s+')"/>
                      <xsl:for-each select="$words[position() &lt;= 3]">
                        <xsl:value-of select="."/>
                        <xsl:if test="position() != last()">
                          <xsl:text> </xsl:text>
                        </xsl:if>
                      </xsl:for-each>
                      <xsl:text> … ]</xsl:text>
                    </xsl:if>
                    <xsl:text>{</xsl:text>
                    <xsl:apply-templates/>
                    <xsl:text>}</xsl:text>
                    <xsl:text>\label{</xsl:text>
                    <xsl:value-of select="parent::tei:div/@xml:id"/>
                    <xsl:text>}</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="ancestor::tei:back">
                <xsl:text>[{</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>}]{</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>}\label{</xsl:text>
                <xsl:value-of select="parent::tei:div/@xml:id"/>
                <xsl:text>}</xsl:text>
              </xsl:when>
            </xsl:choose>
          </xsl:when>

          <!-- Third Order Heads -->
          <xsl:when test="$depth = '2'">
            <xsl:choose>
                <xsl:when test="ancestor::tei:front">
                  <xsl:text>{</xsl:text>
                  <xsl:apply-templates/>
                  <xsl:text>}&#10;</xsl:text>
                </xsl:when>
                <xsl:when test="ancestor::tei:body and parent::tei:div[@type = 'textpart']">
                <xsl:choose>
                  <!-- If there is a child app element, process it -->
                  <xsl:when test="tei:app">
                    <!-- Output the subsection with the value of the descendant lem element -->
                    <xsl:if test="string-length(tei:app/tei:lem) > 20">
                      <xsl:text>[</xsl:text>
                      <xsl:variable name="words" select="tokenize(normalize-space(.), '\s+')"/>
                      <xsl:for-each select="$words[position() &lt;= 3]">
                        <xsl:value-of select="."/>
                        <xsl:if test="position() != last()">
                          <xsl:text> </xsl:text>
                        </xsl:if>
                      </xsl:for-each>
                      <xsl:text> … ]</xsl:text>
                    </xsl:if>
                    <xsl:text>{</xsl:text>
                    <xsl:value-of select="normalize-space(tei:app/tei:lem)"/>
                    <xsl:text>}</xsl:text>
                    <xsl:text>\label{</xsl:text>
                    <xsl:value-of select="parent::tei:div/@xml:id"/>
                    <xsl:text>}</xsl:text>
                    <xsl:text>&#10;\pstart&#10;</xsl:text>
                    <!-- Apply templates only for app and its children -->
                    <xsl:apply-templates select="tei:app"/>
                    <xsl:text>&#10;\pend&#10;</xsl:text>
                  </xsl:when>
                  <!-- Otherwise, just apply the templates -->
                  <xsl:otherwise>
                    <!-- If the value of head is greater than 20 characters, 
                    create a short optional label for the running header at 
                    the top of the page. -->
                    <xsl:if test="string-length(self::tei:head) > 20">
                      <xsl:text>[</xsl:text>
                      <xsl:variable name="words" select="tokenize(normalize-space(.), '\s+')"/>
                      <xsl:for-each select="$words[position() &lt;= 3]">
                        <xsl:value-of select="."/>
                        <xsl:if test="position() != last()">
                          <xsl:text> </xsl:text>
                        </xsl:if>
                      </xsl:for-each>
                      <xsl:text> … ]</xsl:text>
                    </xsl:if>
                    <xsl:text>{</xsl:text>
                    <xsl:apply-templates/>
                    <xsl:text>}</xsl:text>
                    <xsl:text>\label{</xsl:text>
                    <xsl:value-of select="parent::tei:div/@xml:id"/>
                    <xsl:text>}</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="ancestor::tei:back">
                <xsl:text>[{</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>}]{</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>}\label{</xsl:text>
                <xsl:value-of select="parent::tei:div/@xml:id"/>
                <xsl:text>}</xsl:text>
              </xsl:when>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>{</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>}\label{</xsl:text>
            <xsl:value-of select="parent::tei:div/@xml:id"/>
            <xsl:text>}</xsl:text>
            <xsl:text>&#10;</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>"First three words" template for tei:head above</desc>
  </doc>
  <xsl:template name="get-first-three-words">
    <xsl:param name="text"/>
    <xsl:param name="count" select="1"/>
    <xsl:param name="result" select="''"/>
    <xsl:choose>
      <xsl:when test="contains($text, ' ') and $count &lt;= 3">
        <xsl:variable name="word" select="substring-before($text, ' ')"/>
        <xsl:variable name="new-text" select="substring-after($text, ' ')"/>
        <xsl:call-template name="get-first-three-words">
          <xsl:with-param name="text" select="$new-text"/>
          <xsl:with-param name="count" select="$count + 1"/>
          <xsl:with-param name="result" select="concat($result, $word, ' ')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$result"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element head in heading mode</desc>
  </doc>
  <xsl:template match="tei:head" mode="makeheading">
    <xsl:apply-templates/>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element hr</desc>
  </doc>
  <xsl:template match="tei:hr"> \hline </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element ident</desc>
  </doc>
  <xsl:template match="tei:ident">
    <xsl:text>\textsf{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Handle interpGrp</desc>
  </doc>
  <xsl:template match="tei:interpGrp">
    <xsl:text>&#10;\begin{itemize}[label={}]&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#10;\end{itemize}&#10;</xsl:text>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Handle interp</desc>
  </doc>
  <xsl:template match="tei:interp">
    <xsl:text>\item[] {\hyperref[</xsl:text>
    <xsl:value-of select="translate(@corresp,'#','')"/>
    <xsl:text>]{</xsl:text>
    <xsl:value-of select="normalize-space(self::tei:interp/text())"/>
    <xsl:text>}}&#10;</xsl:text>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element item</desc>
  </doc>
  <xsl:template match="tei:item" mode="gloss">
    <xsl:text>
\item[{</xsl:text>
    <xsl:apply-templates select="preceding-sibling::tei:label[1]" mode="gloss"/>
    <xsl:text>}]</xsl:text>
    <xsl:if test="tei:list">\hspace{1em}\hfill\linebreak&#10;</xsl:if>
    <xsl:apply-templates/>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element label in normal mode when it is the child of a list.</desc>
  </doc>
  <xsl:template match="tei:list/tei:label"/>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element label in normal mode, inside an item</desc>
  </doc>
  <xsl:template match="tei:item/tei:label">
    <xsl:text>\textbf{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element label in gloss mode</desc>
  </doc>
  <xsl:template match="tei:label" mode="gloss">
    <xsl:apply-templates/>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>line break</desc>
  </doc>
  <xsl:template name="lineBreak">
    <xsl:text>{\hskip1pt}\\{}</xsl:text>
  </xsl:template>
  <xsl:template name="lineBreakAsPara">
    <xsl:text>\par  </xsl:text>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element list</desc>
  </doc>
  <xsl:template match="tei:list">
    <xsl:if test="tei:head">
      <xsl:text>&#10;\par&#10;\textbf{</xsl:text>
      <xsl:for-each select="tei:head">
        <xsl:apply-templates/>
      </xsl:for-each>
      <xsl:text>} </xsl:text>
    </xsl:if>
    <xsl:sequence select="tei:makeHyperTarget(@xml:id)"/>
    <xsl:choose>
      <xsl:when test="not(tei:item)"/>
      <xsl:when test="tei:isGlossList(.)">
        <xsl:text>\begin{description}&#10;</xsl:text>
        <xsl:apply-templates mode="gloss" select="tei:item"/>
        <xsl:text>&#10;\end{description} </xsl:text>
      </xsl:when>
      <xsl:when test="tei:isOrderedList(.)">
        <xsl:text>\begin{enumerate}</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#10;\end{enumerate}</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'runin' or tei:match(@rend, 'runon')">
        <xsl:apply-templates mode="runin" select="tei:item"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>&#10;\begin{itemize}</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#10;\end{itemize}&#10;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element listBibl</desc>
  </doc>
  <xsl:template match="tei:listBibl">
    <xsl:if test="tei:head">
      <xsl:text>\leftline{\textbf{</xsl:text>
      <xsl:for-each select="tei:head">
        <xsl:apply-templates/>
      </xsl:for-each>
      <xsl:text>}} </xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="tei:biblStruct and not(tei:bibl)">
        <xsl:text>&#10;\begin{bibitemlist}{1}&#10;</xsl:text>
        <xsl:for-each select="tei:biblStruct">
          <xsl:sort
            select="
              lower-case((
              tei:*/tei:author//tei:surname
              | tei:*/tei:author/tei:orgName
              | tei:*/tei:author/tei:name
              | tei:*/tei:editor//tei:surname
              | tei:*/tei:editor/tei:name
              | tei:*/tei:title)[1])"/>
          <xsl:sort select="tei:monogr/tei:imprint/tei:date"/>
          <xsl:text>&#10;\bibitem[</xsl:text>
          <xsl:apply-templates select="." mode="xref"/>
          <xsl:text>]{</xsl:text>
          <xsl:value-of select="@xml:id"/>
          <xsl:text>}</xsl:text>
          <xsl:sequence select="tei:makeHyperTarget(@xml:id)"/>
          <xsl:apply-templates select="."/>
        </xsl:for-each>
        <xsl:text>&#10;\end{bibitemlist}&#10;</xsl:text>
      </xsl:when>
      <xsl:when test="tei:msDesc">
        <xsl:apply-templates select="*[not(self::tei:head)]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>&#10;\begin{bibitemlist}{1}&#10;</xsl:text>
        <xsl:apply-templates select="*[not(self::tei:head)]"/>
        <xsl:text>&#10;\end{bibitemlist}&#10;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element listBibl/tei:bibl</desc>
  </doc>
  <xsl:template match="tei:listBibl/tei:bibl">
    <xsl:text>\bibitem </xsl:text>
    <xsl:choose>
      <xsl:when test="parent::tei:listBibl/@xml:lang = 'zh-TW' or @xml:lang = 'zh-TW'">
        <xsl:text>{\textChinese </xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
      </xsl:when>
      <xsl:when test="parent::tei:listBibl/@xml:lang = 'ja' or @xml:lang = 'ja'">
        <xsl:text>{\textJapanese </xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element tei:bibl within a tei:witness (for early editions)</desc>
  </doc>
  <xsl:template match="tei:listWit/tei:witness/tei:bibl">
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>
      <p>Process listWit. The big issue here is turning each witness into a \bibitem, so that cross
        references work as expected.</p>
    </desc>
  </doc>
  <xsl:template match="tei:listWit">
    <xsl:choose>
      <xsl:when test="parent::tei:div[@xml:id = 'bibliography-manuscripts']">
        <xsl:text>&#10;</xsl:text>
        <xsl:text>\vspace{1.5em}&#10;</xsl:text>
        <xsl:if test="child::tei:head">
          <xsl:text>&#10;</xsl:text>
          <xsl:text>{\large{</xsl:text>
          <xsl:value-of select="child::tei:head"/>
          <xsl:text>}}</xsl:text>
        </xsl:if>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>\begin{msitemlist}{1}&#10;</xsl:text>
        <xsl:for-each select="tei:witness">
          <xsl:text>\bibitem</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
        <xsl:text>\end{msitemlist}&#10;</xsl:text>
      </xsl:when>
      <xsl:when test="parent::tei:listWit">
        <xsl:if test="child::tei:head">
          <xsl:text>&#10;</xsl:text>
          <xsl:text>&#10;</xsl:text>
          <xsl:text>\vspace{1em}&#10;</xsl:text>
          <xsl:text>{\large{</xsl:text>
          <xsl:value-of select="child::tei:head"/>
          <xsl:text>}}</xsl:text>
        </xsl:if>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>\begin{msitemlist}{1}&#10;</xsl:text>
        <xsl:for-each select="tei:witness">
          <xsl:text>\bibitem</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
        <xsl:text>\end{msitemlist}&#10;</xsl:text>
      </xsl:when>
      <xsl:when test="parent::tei:witness">
        <xsl:if test="child::tei:head">
          <xsl:text>&#10;</xsl:text>
          <xsl:text>&#10;</xsl:text>
          <xsl:text>\vspace{1em}&#10;</xsl:text>
          <xsl:text>{\large{</xsl:text>
          <xsl:value-of select="child::tei:head"/>
          <xsl:text>}}</xsl:text>
        </xsl:if>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>\begin{msitemlist}{1}&#10;</xsl:text>
        <xsl:for-each select="tei:witness">
          <xsl:text> \bibitem</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
        <xsl:text>\end{msitemlist}&#10;</xsl:text>
      </xsl:when>
      <xsl:when test="parent::tei:div[@xml:id = 'bibliography-early-editions']">
        <xsl:if test="child::tei:head">
          <xsl:text>&#10;</xsl:text>
          <xsl:text>&#10;</xsl:text>
          <xsl:text>\textbf{</xsl:text>
          <xsl:value-of select="child::tei:head"/>
          <xsl:text>}</xsl:text>
        </xsl:if>
        <xsl:text>&#10;\begin{bibitemlist}{1}&#10;</xsl:text>
        <xsl:for-each select="tei:witness">
          <xsl:text>&#10;</xsl:text>
          <xsl:text> \bibitem</xsl:text>
          <xsl:apply-templates/>
        </xsl:for-each>
        <xsl:text>\end{bibitemlist}</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Don't process msIdentifier.</desc>
  </doc>
  <xsl:template match="tei:msIdentifier"/>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process num.</desc>
  </doc>
  <xsl:template match="tei:num">
    <xsl:apply-templates/>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process physDesc.</desc>
  </doc>
  <xsl:template match="tei:physDesc">
    <xsl:text>&#10;&#10;\textit{Hands}&#10;</xsl:text>
    <xsl:text>\begin{itemize}&#10;</xsl:text>
    <xsl:for-each select="descendant::tei:handNote">
      <xsl:text>\item </xsl:text><xsl:apply-templates/><xsl:text>&#10;</xsl:text>
    </xsl:for-each>
    <xsl:text>\end{itemize}</xsl:text>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process a note element which has a @place attribute pointing to margin</desc>
  </doc>
  <xsl:template name="marginalNote">
    <xsl:choose>
      <xsl:when
        test="
          @place = 'left' or
          @place = 'marginLeft' or
          @place = 'margin-left' or
          @place = 'margin_left'"
        > \reversemarginpar </xsl:when>
      <xsl:otherwise> \normalmarginpar </xsl:otherwise>
    </xsl:choose>
    <xsl:text>\marginnote{</xsl:text>
    <xsl:sequence select="tei:makeHyperTarget(@xml:id)"/>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process a note element which has a @place attribute for display style note</desc>
  </doc>
  <xsl:template name="displayNote">
    <xsl:text>&#10;\begin{</xsl:text>
    <xsl:value-of select="$quoteEnv"/>
    <xsl:text>}&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>\end{</xsl:text>
    <xsl:value-of select="$quoteEnv"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process a note element which has a @place attribute for endnote</desc>
  </doc>
  <xsl:template name="endNote">
    <xsl:text>\endnote{</xsl:text>
    <xsl:sequence select="tei:makeHyperTarget(@xml:id)"/>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process a plain note element</desc>
  </doc>
  <xsl:template name="plainNote">

    <xsl:choose>
      <xsl:when test="@n">
        <xsl:value-of select="@n"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- SJH: Removing this since "Note:" before everything is problematic. 
          <xsl:sequence select="tei:i18n('Note')"/>
        <xsl:text>: </xsl:text>-->
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates/>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process a note element which has a @place for footnote</desc>
  </doc>
  <xsl:template name="footNote">
    <xsl:sequence select="tei:makeHyperTarget(@xml:id)"/>
    <xsl:choose>
      <xsl:when test="@target">
        <xsl:text>\footnotetext{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
      </xsl:when>
      <xsl:when test="count(key('APP', 1)) &gt; 0">
        <xsl:text>\footnote{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>\footnote{</xsl:text>
        <xsl:sequence select="tei:makeHyperTarget(@xml:id)"/>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element note in commentary.</desc>
  </doc>
  <xsl:template match="//tei:div[@type = 'commentary']//tei:note">
    <xsl:text>\footnote{</xsl:text>
    <xsl:apply-templates/>
    <xsl:if test="@xml:id">
      <xsl:text>\label{</xsl:text>
      <xsl:value-of select="@xml:id"/>
      <xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:text>}</xsl:text>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element p</desc>
  </doc>
  <xsl:template match="tei:p">
    <xsl:choose>
      <xsl:when test="parent::tei:note and not(preceding-sibling::tei:p)"> </xsl:when>
      <xsl:when test="ancestor::tei:div[@type = 'edition']">
        <xsl:text>&#10;\pstart&#10;</xsl:text>
      </xsl:when>
      <xsl:when test="parent::tei:div[@xml:id = 'appendix-critica'] or ancestor::tei:div[@xml:id = 'commentary']">
        <xsl:text>&#10;\par\noindent </xsl:text>
      </xsl:when>
      <xsl:when test="preceding-sibling::*[1][self::tei:quote[@rend = 'blockquote']]">
        <xsl:text>&#10;\noindent </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>\par&#10;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:sequence select="tei:makeHyperTarget(@xml:id)"/>
    <xsl:if test="$numberParagraphs = 'true'">
      <xsl:call-template name="numberParagraph"/>
    </xsl:if>
    <!-- SJH: Removing superscript from paragraph numbers. -->
    <xsl:if test="@n and ancestor::tei:div[@type = 'edition']">
      <xsl:text>\textbf{</xsl:text>
      <xsl:value-of select="@n"/>
      <xsl:text>} </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:if test="ancestor::tei:div[@type = 'edition']">
      <xsl:text>&#10;\pend&#10;</xsl:text>
    </xsl:if>
    <xsl:if test="ancestor::tei:div[@xml:id = 'appendix-critica']">
      <xsl:text>\par&#10;</xsl:text>
    </xsl:if>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element p with tei:match(@rend,'display')</desc>
  </doc>
  <xsl:template match="tei:p[tei:match(@rend, 'display')]">
    <xsl:text>&#10;\begin{</xsl:text>
    <xsl:value-of select="$quoteEnv"/>
    <xsl:text>}&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>\end{</xsl:text>
    <xsl:value-of select="$quoteEnv"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:template>
  
  <!-- SJH: added to render bylines for commentary -->
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element p with tei:match(@rend,'byline')</desc>
  </doc>
  <xsl:template match="tei:p[@rend = 'byline']">
    <xsl:text>&#10;&#10;</xsl:text>
    <xsl:text>\begin{center}&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#10;\end{center}</xsl:text>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element p with tei:match(@rend,'center')</desc>
  </doc>
  <xsl:template match="tei:p[tei:match(@rend, 'center')]">
    <xsl:text>&#10;\begin{center}&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>\end{center}&#10;</xsl:text>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Number paragraphs</desc>
  </doc>
  <xsl:template name="numberParagraph">
    <xsl:text>\textit{\footnotesize[</xsl:text>
    <xsl:number/>
    <xsl:text>]} </xsl:text>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>
      <p>Process element pb</p>
      <p>Indication of a page break. Make it an anchor if it has an ID.</p>
    </desc>
  </doc>
  <xsl:template match="tei:pb">
    <!-- string " Page " is now managed through the i18n file -->
    <xsl:choose>
      <xsl:when test="$pagebreakStyle = 'active'">
        <xsl:text>\clearpage </xsl:text>
      </xsl:when>
      <xsl:when test="$pagebreakStyle = 'visible'">
        <xsl:text>✁[</xsl:text>
        <xsl:value-of select="@unit"/>
        <xsl:text> </xsl:text>
        <xsl:sequence select="tei:i18n('page')"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="@n"/>
        <xsl:text>]✁</xsl:text>
      </xsl:when>
      <xsl:when test="$pagebreakStyle = 'bracketsonly'">
        <!-- To avoid trouble with the scisssors character "✁" -->
        <xsl:text>[</xsl:text>
        <xsl:value-of select="@unit"/>
        <xsl:text> </xsl:text>
        <xsl:sequence select="tei:i18n('page')"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="@n"/>
        <xsl:text>]</xsl:text>
      </xsl:when>
      <xsl:when test="$pagebreakStyle = 'plain'">
        <xsl:text>\vspace{1ex}&#10;\par&#10;</xsl:text>
        <xsl:value-of select="@n"/>
        <xsl:text>\vspace{1ex}&#10;</xsl:text>
      </xsl:when>
      <xsl:when test="$pagebreakStyle = 'sidebyside'">
        <xsl:text>\cleartoleftpage&#10;</xsl:text> \begin{figure}[ht!]\makebox[\textwidth][c]{
          <xsl:text>\includegraphics[width=\textwidth]{</xsl:text><xsl:value-of
          select="tei:resolveURI(., @facs)"/><xsl:text>}</xsl:text> }\end{figure} <xsl:text>\cleardoublepage&#10;</xsl:text>
        <xsl:text>\vspace{1ex}&#10;\par&#10;</xsl:text>
        <xsl:value-of select="@n"/>
        <xsl:text>\vspace{1ex}&#10;</xsl:text>
      </xsl:when>
      <xsl:when test="@facs">
        <xsl:value-of select="concat('% image:', tei:resolveURI(., @facs), '&#10;')"/>
      </xsl:when>
      <xsl:otherwise> </xsl:otherwise>
    </xsl:choose>
    <xsl:sequence select="tei:makeHyperTarget(@xml:id)"/>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element q</desc>
  </doc>
  <xsl:template match="tei:q | tei:said">
    <xsl:choose>
      <xsl:when test="not(tei:isInline(.))">
        <xsl:text>&#10;\begin{</xsl:text>
        <xsl:value-of select="$quoteEnv"/>
        <xsl:text>}</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>\end{</xsl:text>
        <xsl:value-of select="$quoteEnv"/>
        <xsl:text>}&#10;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="makeQuote"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element quote</desc>
  </doc>
  <xsl:template match="tei:quote">
    <xsl:choose>
      <xsl:when test="@type = 'apparatus'">
        <xsl:text>&#10;\begingroup</xsl:text>
        <xsl:text>&#10;\fontsize{9pt}{10pt}\selectfont</xsl:text>
        <xsl:text>&#10;\begin{</xsl:text>
        <xsl:value-of select="$quoteEnv"/>
        <xsl:text>}</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>\end{</xsl:text>
        <xsl:value-of select="$quoteEnv"/>
        <xsl:text>}</xsl:text>
        <xsl:text>&#10;\endgroup&#10;</xsl:text>
      </xsl:when>
      <xsl:when test="@rend = 'inline'">
        <xsl:text>``</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>''</xsl:text>
      </xsl:when>
      <xsl:when test="@rend='blockquote'">
        <xsl:text>\begin{displayquote}</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>\end{displayquote}</xsl:text>
      </xsl:when>
      <xsl:when test="not(tei:isInline(.) and @type = 'apparatus')">
        <xsl:text>&#10;&#10;\begin{</xsl:text>
        <xsl:value-of select="$quoteEnv"/>
        <xsl:text>}</xsl:text>
        <xsl:sequence select="tei:makeHyperTarget(@xml:id)"/>
        <xsl:apply-templates/>
        <xsl:text>\end{</xsl:text>
        <xsl:value-of select="$quoteEnv"/>
        <xsl:text>}&#10;</xsl:text>
      </xsl:when>
      <!-- SJH: Avoid having line breaks interrupt the quotation. This was an issue in Dunning's text. -->
      <xsl:when test="child::tei:lb">
        <xsl:text>`</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>’</xsl:text>
      </xsl:when>
      <!-- SJH: Set quotation of a section of the apparatus in smaller type -->
      <xsl:otherwise>
        <xsl:call-template name="makeQuote"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Insert a number in superscript to indicate 
      the beginning of a seg, using value of @n</desc>
  </doc>
  <xsl:template match="tei:seg">
    <xsl:text>\textsuperscript{</xsl:text>
    <xsl:value-of select="attribute(n)"/>
    <xsl:text>}</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element signed</desc>
  </doc>
  <xsl:template match="tei:signed">
    <xsl:text>&#10;&#10;\begin{</xsl:text>
    <xsl:value-of select="$quoteEnv"/>
    <xsl:text>}&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>\end{</xsl:text>
    <xsl:value-of select="$quoteEnv"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element soCalled</desc>
  </doc>
  <xsl:template match="tei:soCalled">
    <xsl:value-of select="$preQuote"/>
    <xsl:apply-templates/>
    <xsl:value-of select="$postQuote"/>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element space</desc>
  </doc>
  <xsl:template match="tei:space">
    <xsl:variable name="unit">
      <xsl:choose>
        <xsl:when test="@unit">
          <xsl:value-of select="@unit"/>
        </xsl:when>
        <xsl:otherwise>em</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="quantity">
      <xsl:choose>
        <xsl:when test="@quantity">
          <xsl:value-of select="@quantity"/>
        </xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:text>\hspace{</xsl:text>
    <xsl:value-of select="$quantity"/>
    <xsl:value-of select="$unit"/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Omit any linebreak (lb) elements.</desc>
  </doc>
  <xsl:template match="//tei:lb"/>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Insert space around tei:title.</desc>
  </doc>
  <xsl:template match="tei:title">
      
        <xsl:if test="not(preceding-sibling::node()[1][self::text()[normalize-space()]])">
          <xsl:text> </xsl:text>
        </xsl:if>
      
      <!-- Apply templates to process the content of title -->
      <xsl:text>\textit{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
      
      
        <xsl:if test="not(following-sibling::node()[1][self::text()[normalize-space()]])">
          <xsl:text> </xsl:text>
        </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>
