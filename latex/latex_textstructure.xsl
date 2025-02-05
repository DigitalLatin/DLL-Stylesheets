<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
    xmlns:rng="http://relaxng.org/ns/structure/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:teix="http://www.tei-c.org/ns/Examples" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="#all" version="2.0">
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
        <desc>
            <p> TEI stylesheet dealing with elements from the textstructure module, making LaTeX
                output. </p>
            <p>This software is dual-licensed: 1. Distributed under a Creative Commons
                Attribution-ShareAlike 3.0 Unported License
                http://creativecommons.org/licenses/by-sa/3.0/ 2.
                http://www.opensource.org/licenses/BSD-2-Clause Redistribution and use in source and
                binary forms, with or without modification, are permitted provided that the
                following conditions are met: * Redistributions of source code must retain the above
                copyright notice, this list of conditions and the following disclaimer. *
                Redistributions in binary form must reproduce the above copyright notice, this list
                of conditions and the following disclaimer in the documentation and/or other
                materials provided with the distribution. This software is provided by the copyright
                holders and contributors "as is" and any express or implied warranties, including,
                but not limited to, the implied warranties of merchantability and fitness for a
                particular purpose are disclaimed. In no event shall the copyright holder or
                contributors be liable for any direct, indirect, incidental, special, exemplary, or
                consequential damages (including, but not limited to, procurement of substitute
                goods or services; loss of use, data, or profits; or business interruption) however
                caused and on any theory of liability, whether in contract, strict liability, or
                tort (including negligence or otherwise) arising in any way out of the use of this
                software, even if advised of the possibility of such damage. </p>
            <p>Author: See AUTHORS</p>

            <p>Copyright: 2013, TEI Consortium</p>
        </desc>
    </doc>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process elements * in inner mode</desc>
    </doc>
    <xsl:template match="*" mode="innertext">
        <xsl:apply-templates select="."/>
    </xsl:template>
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Root template</desc>
    </doc>


    <xsl:template match="/tei:TEI | /tei:teiCorpus">
        <xsl:call-template name="mainDocument"/>
    </xsl:template>

    <xsl:template match="tei:teiCorpus/tei:TEI">
        <xsl:apply-templates/>
        <xsl:text>&#10;\par\noindent\rule{\textwidth}{2pt}&#10;\par </xsl:text>
    </xsl:template>

    <xsl:template name="mainDocument">
        <xsl:text>\documentclass[</xsl:text>
        <xsl:value-of select="$classParameters"/>
        <xsl:text>]{</xsl:text>
        <xsl:value-of select="$documentclass"/>
        <xsl:text>}</xsl:text>
        <xsl:text>\makeatletter&#10;</xsl:text>
        <xsl:call-template name="latexSetup"/>
        <xsl:call-template name="latexPackages"/>
        <xsl:call-template name="latexLayout"/>
        <xsl:call-template name="latexOther"/>
        <xsl:text>&#10;\begin{document}&#10;</xsl:text>
        <!-- Taking this out because the LDLT has its own title page.
          <xsl:if test="not(tei:text/tei:front/tei:titlePage)">
         <xsl:call-template name="printTitleAndLogo"/>
      </xsl:if>-->
        <xsl:call-template name="beginDocumentHook"/>
        <!-- certainly don't touch this line -->
        <xsl:text disable-output-escaping="yes">\let\tabcellsep&amp;</xsl:text>
        <xsl:call-template name="titlePage"/>
        <xsl:apply-templates/>
        <xsl:call-template name="latexEnd"/>
        <xsl:if test="key('ENDNOTES', 1)">
            <xsl:text>&#10;\theendnotes</xsl:text>
        </xsl:if>
        <xsl:text>&#10;\end{document}&#10;</xsl:text>
    </xsl:template>

    <xsl:template name="latexOther">
        <xsl:text>\def\TheFullDate{</xsl:text>
        <xsl:sequence select="tei:generateDate(.)"/>
        <xsl:if test="not($useFixedDate = 'true')">
            <xsl:variable name="revdate">
                <xsl:sequence select="tei:generateRevDate(.)"/>
            </xsl:variable>
            <xsl:if test="not($revdate = '')">
                <xsl:text> (</xsl:text>
                <xsl:sequence select="tei:i18n('revisedWord')"/>
                <xsl:text>: </xsl:text>
                <xsl:value-of select="$revdate"/>
                <xsl:text>)</xsl:text>
            </xsl:if>
        </xsl:if>
        <xsl:text>}&#10;</xsl:text>
        <xsl:text>\def\TheID{</xsl:text>
        <xsl:choose>
            <xsl:when test="not($REQUEST = '')">
                <xsl:value-of select="not($REQUEST = '')"/>
            </xsl:when>
            <xsl:when
                test="ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno">
                <xsl:value-of
                    select="ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[1]"
                />
            </xsl:when>
        </xsl:choose>
        <xsl:text>\makeatother </xsl:text>
        <xsl:text>}&#10;\def\TheDate{</xsl:text>
        <xsl:sequence select="tei:generateDate(/*)"/>
        <xsl:text>}&#10;\title{</xsl:text>
        <xsl:sequence select="tei:generateSimpleTitle(/*)"/>
        <xsl:text>}&#10;\author{</xsl:text>
        <xsl:sequence select="tei:generateAuthor(/*)"/>
        <xsl:text>}</xsl:text>
        <xsl:text>\makeatletter </xsl:text>
        <xsl:call-template name="latexBegin"/>
        <xsl:text>\makeatother </xsl:text>
    </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Processing teiHeader elements</desc>
    </doc>
    <xsl:template match="tei:teiHeader"/>

  <!--  <xsl:template match="tei:front">
        <xsl:text>\frontmatter </xsl:text>
        <xsl:apply-templates/>
    </xsl:template>-->

    <!-- SJH: Added -->
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Make the title page</desc>
    </doc>
    <xsl:template name="titlePage">
        <xsl:text>
\thispagestyle{empty}
\vspace*{\fill} 

\begin{center}
This PDF is formatted to accommodate printing two pages per sheet in landscape mode.
\end{center}

\vspace*{\fill}
\frontmatter 
\thispagestyle{empty}
\begin{titlepage} % Suppresses headers and footers on the title page
\centering % Center everything on the title page
        
%------------------------------------------------
%	Title
%------------------------------------------------
        
\rule{\textwidth}{1.6pt}\vspace*{-\baselineskip}\vspace*{2pt} % Thick horizontal rule
\rule{\textwidth}{0.4pt} % Thin horizontal rule
        
\vfill
\begin{spacing}{1.5}        
{\LARGE\uppercase{</xsl:text>
        <xsl:value-of select="//tei:titleStmt/tei:title"/>
        <xsl:text>}} % Title
\end{spacing}
\vfill 

%------------------------------------------------
%	Editor(s)
%------------------------------------------------

Edited By

\vfill

{\Large </xsl:text>
        <xsl:value-of select="//tei:titleStmt/tei:editor"/>
        <xsl:text>} % Editor list
        
\vfill
\rule{\textwidth}{0.4pt}\vspace*{-\baselineskip}\vspace{3.2pt} % Thin horizontal rule
\rule{\textwidth}{1.6pt} % Thick horizontal rule

%------------------------------------------------
%	Series
%------------------------------------------------
\vfill

{\Large </xsl:text>
        <xsl:value-of select="//tei:titleStmt/tei:sponsor"/>
        <xsl:text>}\\
\vfill
{\large </xsl:text>
        <xsl:value-of select="//tei:seriesStmt/tei:title"/>
        <xsl:text>}\\                      
\vfill
{\large Volume </xsl:text>
        <xsl:value-of select="//tei:seriesStmt/tei:biblScope"/>
        <xsl:text>}\\
\vfill % Whitespace between editor names and publisher logo
        
%------------------------------------------------
%	Publisher
%------------------------------------------------


\begin{figure}[h] % Position the logo here on the page.
\includegraphics[scale=0.50]{../images/DLL.eps} % Logo of DLL
\centering % Center the logo.
\end{figure}

{\normalsize </xsl:text>
        <xsl:value-of select="//tei:publicationStmt/tei:date"/>
        <xsl:text>}        
\end{titlepage}
%----------------------------------------------------------------------------------------
% Copyright Page
%----------------------------------------------------------------------------------------
\begin{copyrightPage}
\thispagestyle{empty}
\vfill
\begin{figure}[h] % Position the logo here on the page.
\includegraphics[scale=0.50]{../images/DLL.eps} % Logo of DLL
\centering % Center the logo.
\end{figure}
\vfill
\centering
{\LARGE </xsl:text>
        <xsl:value-of select="//tei:publicationStmt/tei:publisher"/>
        <xsl:text>}\\</xsl:text>
        <xsl:value-of select="//tei:publicationStmt/tei:address/tei:street"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="//tei:publicationStmt/tei:address/tei:addrLine"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="//tei:publicationStmt/tei:address/tei:settlement"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="//tei:publicationStmt/tei:address/tei:name"/>
        <xsl:text>  </xsl:text>
        <xsl:value-of select="//tei:publicationStmt/tei:address/tei:postCode"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="//tei:publicationStmt/tei:address/tei:country"/>
        <xsl:text>
\vfill

\flushleft
\small
{</xsl:text>
        <xsl:value-of select="//tei:publicationStmt/tei:publisher"/>
        <xsl:text>} publishes the \textit{</xsl:text>
        <xsl:value-of select="//tei:seriesStmt/tei:title"/>
        <xsl:text>} under the authority of </xsl:text>
        <xsl:value-of select="//tei:publicationStmt/tei:authority"/>
        <xsl:text>. Individual volumes are reviewed and sponsored by the Society for Classical Studies, the Medieval Academy of America, or the Renaissance Society of America, depending on the era of the text(s).

\vfill

Volumes are published under the </xsl:text> 
            <xsl:value-of select="normalize-space(//tei:publicationStmt/tei:availability/tei:licence)"/><xsl:text>: \url{</xsl:text>
        <xsl:value-of select="//tei:publicationStmt/tei:availability/tei:licence/@target"/><xsl:text>}.

\vfill

\textcopyright \thinspace </xsl:text>
        <xsl:value-of select="//tei:titleStmt/tei:editor"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="//tei:publicationStmt/tei:date"/>
        <xsl:text>.

\vfill
\end{copyrightPage}
\cleardoublepage
</xsl:text>
    <xsl:if test="//tei:titleStmt/tei:respStmt | //tei:editionStmt/tei:respStmt">
    <xsl:text>&#10;\blankpage
    &#10;\begin{acknowledgmentsPage}
    &#10;{\LARGE Acknowledgments}
    &#10;\begin{itemize}&#10;</xsl:text>
        <xsl:for-each select="//tei:titleStmt/tei:respStmt | //tei:editionStmt/tei:respStmt">
            <xsl:text>\item </xsl:text>
            <xsl:value-of select="normalize-space(tei:resp)"/><xsl:text>: </xsl:text>
            <xsl:choose>
                <xsl:when test="count(tei:name) = 1">
                    <xsl:value-of select="normalize-space(tei:name)"/><xsl:text>.</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="tei:name">
                        <xsl:value-of select="."/>
                        <xsl:choose>
                            <xsl:when test="position() != last() ">
                                <xsl:text>, </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>.</xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
        <xsl:text>
\end{itemize}&#10;
\end{acknowledgmentsPage}&#10;
        </xsl:text>
    </xsl:if>
    </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc/>
    </doc>
    <xsl:template match="tei:back">
        <xsl:if test="not(preceding::tei:back)">
            <xsl:text>&#10;\newpage             % 1. Force new page</xsl:text>
            <xsl:text>&#10;\pagestyle{empty}    % 2. Set empty style</xsl:text>
            <xsl:text>&#10;\clearpage           % 3. Clear current page</xsl:text>
            <xsl:text>&#10;\cleardoublepage    % 4. Force even page</xsl:text>
            <xsl:text>&#10;\blankpage          % 5. Add blank page</xsl:text>
            <xsl:text>&#10;&#10;\backmatter </xsl:text>
            <xsl:text>% Reformat subsubheadings and paragraphs</xsl:text>
            <xsl:text>&#10;&#10;\makeatletter</xsl:text>
            <xsl:text>&#10;\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%</xsl:text>
            <xsl:text>&#10;  {3.25ex\@plus 1ex \@minus .2ex}%</xsl:text>
            <xsl:text>&#10;  {0.2ex \@plus .2ex}%</xsl:text>
            <xsl:text>&#10;  {\reset@font\large}}</xsl:text>
            <xsl:text>&#10;\setlength\parskip{0.75em plus 0.1em minus 0.2em}</xsl:text>
            <xsl:text>&#10;\makeatother</xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc/>
    </doc>
    <xsl:template match="tei:body">
        <xsl:if
            test="not(ancestor::tei:floatingText) and not(preceding::tei:body) and preceding::tei:front">
            <xsl:text>&#10;\mainmatter
\cleardoublepage
\pagenumbering{arabic}
</xsl:text>
        </xsl:if>
        <xsl:text>&#10;\def\endstanzaextra{\pstart\centering-\-\-\-\-\-\-\-\-\skipnumbering\pend}</xsl:text>
        <xsl:text>&#10;\thispagestyle{plain}&#10;</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc/>
    </doc>
    <xsl:template match="tei:body | tei:back | tei:front" mode="innertext">
        <xsl:apply-templates/>
    </xsl:template>
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc/>
    </doc>
    <xsl:template match="tei:closer">
        <xsl:text>&#10;&#10;\begin{quote}</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>\end{quote}&#10;</xsl:text>
    </xsl:template>
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc/>
    </doc>
    <xsl:template match="tei:dateline">
        <xsl:text>\rightline{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}&#10;</xsl:text>
    </xsl:template>
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process the tei:div elements</desc>
    </doc>
    <xsl:template match="tei:div | tei:div1 | tei:div2 | tei:div3 | tei:div4 | tei:div5">
        <xsl:choose>
            <xsl:when test="parent::tei:div[@type = 'commentary']">
                <!-- SJH: Handling back matter (commentary, etc.) -->
                <xsl:apply-templates/>
                <xsl:if test="not(position() = last())">
                    <xsl:text>&#10;\setcounter{footnote}{0}</xsl:text>
                    <xsl:text>&#10;\newpage</xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:when test="self::tei:div[@type = 'edition']">
                <xsl:text>&#10;\beginnumbering&#10;</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>&#10;\endnumbering</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Table of contents</desc>
    </doc>
    <xsl:template match="tei:divGen[@type = 'toc']"> \tableofcontents </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Bibliography</desc>
    </doc>
    <xsl:template match="tei:divGen[@type = 'bibliography']">
        <xsl:text>&#10;\begin{thebibliography}{1}&#10;</xsl:text>
        <xsl:call-template name="bibliography"/>
        <xsl:text>&#10;\end{thebibliography}&#10;</xsl:text>
    </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process front</desc>
    </doc>
    <xsl:template match="tei:front">
        <xsl:text>&#10;\blankpage

\frontmatter
\pagenumbering{roman}

\cleardoublepage
\tableofcontents
\blankpage
\cleardoublepage        
\thispagestyle{plain}

\setcounter{page}{5}
        </xsl:text>
        <!-- SJH: This keeps the header from showing up on the first page of the preface. -->
            <xsl:text>&#10;\thispagestyle{plain}&#10;</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc/>
    </doc>
    <xsl:template match="tei:opener">
        <xsl:text>&#10;&#10;\begin{quote}</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>\end{quote}&#10;</xsl:text>
    </xsl:template>
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>the main TEI text</desc>
    </doc>
    <xsl:template match="tei:text">
        <xsl:choose>
            <xsl:when test="parent::tei:TEI">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="parent::tei:group">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise> \par \hrule \begin{quote} \begin{small} <xsl:apply-templates
                    mode="innertext"/> \end{small} \end{quote} \hrule \par </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process titlePage</desc>
    </doc>
    <xsl:template match="tei:titlePage">&#10;\begin{titlepage}&#10;
        <xsl:apply-templates/> 
        &#10;\end{titlepage}
        &#10;\cleardoublepage 
    </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process trailer</desc>
    </doc>
    <xsl:template match="tei:trailer">
        <xsl:text>&#10;&#10;\begin{raggedleft}</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>\end{raggedleft}&#10;</xsl:text>
    </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>[latex] make a bibliography</desc>
    </doc>
    <xsl:template name="bibliography">
        <xsl:apply-templates mode="biblio"
            select="//tei:ref[@type = 'cite'] | //tei:ptr[@type = 'cite']"/>
    </xsl:template>
    
    <!-- SJH: Handling back matter (commentary, etc.) -->
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Back matter.</desc>
    </doc>
    <xsl:template match="tei:div[@type = 'commentary']">
        <xsl:text>\setcounter{footnote}{0}</xsl:text>
        <xsl:text>\newpage</xsl:text>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Make a title for the back matter.</desc>
    </doc>
    <xsl:template match="tei:back/tei:div">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="/tei:text" priority="999">
        <xsl:call-template name="wrapRootText"/>
    </xsl:template>

    <xsl:template match="tei:milestone"/>


</xsl:stylesheet>
