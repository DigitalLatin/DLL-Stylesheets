<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
    xmlns:rng="http://relaxng.org/ns/structure/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:teix="http://www.tei-c.org/ns/Examples" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="a rng tei teix" version="2.0">
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
        <desc>
            <p> TEI stylesheet dealing with elements from the drama module, making LaTeX output. </p>
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
        <desc>Process element actor</desc>
    </doc>
    <xsl:template match="tei:actor">
        <xsl:text>\textit{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process element camera</desc>
    </doc>
    <xsl:template match="tei:camera">
        <xsl:text>\textit{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process element caption</desc>
    </doc>
    <xsl:template match="tei:caption">
        <xsl:text>\textit{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process element castGroup</desc>
    </doc>
    <xsl:template match="tei:castGroup">
        <xsl:text>\begin{itemize} </xsl:text>
        <xsl:apply-templates/>
        <xsl:text>\end{itemize}</xsl:text>
    </xsl:template>
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process element castItem</desc>
    </doc>
    <xsl:template match="tei:castItem">
        <xsl:text>&#10;\item </xsl:text>
        <xsl:apply-templates/>
    </xsl:template>
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process element castList</desc>
    </doc>
    <xsl:template match="tei:castList">
        <xsl:if test="tei:head">
            <xsl:text> \par\textit{</xsl:text>
            <xsl:for-each select="tei:head">
                <xsl:apply-templates/>
            </xsl:for-each>
            <xsl:text>}&#10;</xsl:text>
        </xsl:if>
        <xsl:text>\begin{itemize} </xsl:text>
        <xsl:apply-templates/>
        <xsl:text>\end{itemize} </xsl:text>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process element role</desc>
    </doc>
    <xsl:template match="tei:role">
        <xsl:text>\textbf{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process element roleDesc</desc>
    </doc>
    <xsl:template match="tei:roleDesc">
        <xsl:text>\begin{quote}</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>\end{quote}</xsl:text>
    </xsl:template>
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process element set</desc>
    </doc>
    <xsl:template match="tei:set">
        <xsl:text>\textit{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process element sound</desc>
    </doc>
    <xsl:template match="tei:sound">
        <xsl:text>\textit{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
    </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process element sp.</desc>
    </doc>
    <xsl:template match="tei:sp">
        <xsl:choose>
            <!-- If there's @who, use thalie's features to create the speaker label -->
            <xsl:when test="@who">
                <xsl:choose>
                    <!-- Logic for antilabe: Look for @part="F" -->
                    <xsl:when test="child::tei:l[@part='F'][1]">
                        <xsl:text>&#10;{\vspace{1\baselineskip}}&#10;</xsl:text>
                        <xsl:text>\stanza&#10;</xsl:text>
                        <xsl:text>\antilabe\</xsl:text><xsl:value-of select="translate(@who,'#''-','')"/><xsl:text> </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>\stanza</xsl:text>
                        <!-- If the second child is a stage element, insert it into the optional space-before location for \stanza -->
                        <xsl:if test="child::*[2][self::tei:stage]">
                            <xsl:text>[\textit{</xsl:text><xsl:value-of select="child::*[2][self::tei:stage]"/><xsl:text>}]&#10;</xsl:text>
                        </xsl:if>
                        <xsl:text>&#10;\</xsl:text><xsl:value-of select="translate(@who,'#''-','')"/><xsl:text> </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <!-- In the absence of @who, create a disposable character -->
                <xsl:choose>
                    <!-- Logic for antilabe: Look for @part="F" -->
                    <xsl:when test="child::tei:l[@part='F'][1]">
                        <xsl:text>&#10;{\vspace{1\baselineskip}}&#10;</xsl:text>
                        <xsl:text>\stanza&#10;</xsl:text>
                        <xsl:text>\antilabe{\disposablecharacter{</xsl:text><xsl:value-of select="tei:speaker"/><xsl:text>}~} </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>\stanza</xsl:text>
                        <!-- If the second child is a stage element, insert it into the optional space-before location for \stanza -->
                        <xsl:if test="child::tei:stage[2]">
                            <xsl:text>[\textit{</xsl:text><xsl:value-of select="child::*[2][self::tei:stage]"/><xsl:text>}]&#10;</xsl:text>
                        </xsl:if>
                        <xsl:text>&#10;\disposablecharacter{</xsl:text><xsl:value-of select="tei:speaker"/><xsl:text>} </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates/>
        <xsl:text>\&amp;&#10;</xsl:text>
    </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process element tei:sp/tei:l</desc>
    </doc>
    <xsl:template match="tei:sp/tei:l">
        <xsl:choose>
            <!-- Logic for antilabe: Look for @part="I" or @part="M" -->
            <xsl:when test="@part='I' or @part='M'">
                <xsl:text>\skipnumbering </xsl:text><xsl:apply-templates/><xsl:text> &#10;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <!-- Insert \linenumannotation with value of @n to preserve the line numbering of the original edition's XML. -->
                <xsl:text>\linenumannotation{</xsl:text><xsl:value-of select="@n"/><xsl:text>} </xsl:text><xsl:apply-templates/><xsl:text> &amp;&#10;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process element sp/tei:p</desc>
    </doc>
    <xsl:template match="tei:sp/tei:p">
        <xsl:text>&#10;&#10;</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process element sp/tei:speaker</desc>
    </doc>
    <xsl:template match="tei:sp/tei:speaker">
        <!-- Don't process this here, since it's handled in tei:sp -->
    </xsl:template>
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process element stage</desc>
    </doc>
    <xsl:template match="tei:stage">
        <xsl:choose>
            <xsl:when test="parent::tei:div">
                <xsl:text>\textit{</xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:text>}\\&#10;</xsl:text>
            </xsl:when>
            <xsl:when test="preceding-sibling::*[1][self::tei:speaker]">
                <!-- Do nothing because it's handled above in tei:sp -->
            </xsl:when>
            <!-- If there's a stage element before an l in the middle of the stanza, use \stanza[] to insert the value. -->
            <xsl:when test="preceding-sibling::*[1][self::tei:l]">
                <xsl:text>\&amp;&#10;</xsl:text>
                <xsl:text>\stanza[\textit{</xsl:text><xsl:apply-templates/><xsl:text>}]&#10;</xsl:text>
            </xsl:when>
            <!-- If stage occurs within a l or p, use Thalie package's \did{} -->
            <xsl:when test="parent::tei:l or parent::tei:p">
                <xsl:text>\did{</xsl:text>
                <xsl:value-of select="normalize-space(translate(., '()', ''))"/>
                <xsl:text>}</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>\textit{</xsl:text><xsl:apply-templates/><xsl:text>}&#10;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process element tech</desc>
    </doc>
    <xsl:template match="tei:tech">
        <xsl:text>\textit{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process element view</desc>
    </doc>
    <xsl:template match="tei:view">
        <xsl:text>\textit{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
    </xsl:template>
</xsl:stylesheet>
