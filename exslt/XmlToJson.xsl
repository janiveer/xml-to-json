<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet href="http://janiveer.github.io/PACBook/css/XSLT.css" type="text/css"?>

<!--
     Copyright © 2018 Simon Dew.

     This file is part of xml-to-json.

     xml-to-json is free software: you can redistribute it and/or modify
     it under the terms of the GNU Lesser General Public License as published by the Free
     Software Foundation, either version 3 of the License, or (at your option) any later
     version.

     xml-to-json is distributed in the hope that it will be useful, but
     WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
     FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
     more details.

     You should have received a copy of the GNU Lesser General Public License along with
     xml-to-json. If not, see http://www.gnu.org/licenses/.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:func="http://exslt.org/functions"
                xmlns:exsl="http://exslt.org/common"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns:json="http://www.w3.org/2005/xpath-functions"
                xmlns:my="urn:x-janiveer:local"
                extension-element-prefixes="func"
                exclude-result-prefixes="func exsl xd json my"
                version="1.0">

  <xd:doc type="stylesheet">
    <xd:short>XML to JSON</xd:short>
    <xd:detail>Library containing the my:xml-to-json function and associated stylesheets.</xd:detail>
    <xd:author>Simon Dew</xd:author>
  </xd:doc>

  <xd:doc type="string">Default line ending character(s)</xd:doc>
  <xsl:param name="eol" select="'&#10;'"/>

  <xd:doc type="string">Default space for each indent level</xd:doc>
  <xsl:param name="tab" select="'  '"/>

  <xd:doc>
    <xd:short>my:xml-to-json</xd:short>
    <xd:detail xmlns="http://www.w3.org/1999/xhtml">
      <p>Transforms XML to JSON. This is a partial implementation of the XSLT 3.0 <code>fn:xml-to-json</code> function, described here:</p>
      <p><a href="https://www.w3.org/TR/xslt-30/#func-xml-to-json">https://www.w3.org/TR/xslt-30/#func-xml-to-json</a></p>
    </xd:detail>
    <xd:param name="input" type="node">XML representation of JSON (see XSLT 3.0 spec).</xd:param>
    <xd:param name="indent" type="boolean">Whether JSON output should be indented.</xd:param>
  </xd:doc>
  <func:function name="my:xml-to-json">
    <xsl:param name="input"/>
    <xsl:param name="indent" select="false()"/>
    <func:result>
      <xsl:for-each select="$input">
        <xsl:apply-templates mode="xml-to-json">
          <xsl:with-param name="space" select="''"/>
          <xsl:with-param name="eol">
            <xsl:choose>
              <xsl:when test="$indent">
                <xsl:value-of select="$eol"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text></xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="tab">
            <xsl:choose>
              <xsl:when test="$indent">
                <xsl:value-of select="$tab"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text></xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:apply-templates>
      </xsl:for-each>
    </func:result>
  </func:function>

  <xd:doc>
    <xd:short>Objects</xd:short>
    <xd:detail xmlns="http://www.w3.org/1999/xhtml">
      <ul>
        <li>Mark up "maps" (objects) with braces {}</li>
        <li>Recursively mark up its contents.</li>
        <li>If it's not the last child of its parent, add a comma.</li>
      </ul>
    </xd:detail>
    <xd:param name="space">The current indentation depth, '' by default</xd:param>
    <xd:param name="tab">Space for each indent level, '' if not($indent).</xd:param>
    <xd:param name="eol">Line ending character, '' if not($indent).</xd:param>
  </xd:doc>
  <xsl:template match="json:map" mode="xml-to-json">
    <xsl:param name="space"/>
    <xsl:param name="tab"/>
    <xsl:param name="eol"/>
    <xsl:value-of select="$space"/>
    <xsl:apply-templates select="@key" mode="xml-to-json"/>
    <xsl:text>{</xsl:text>
    <xsl:value-of select="$eol"/>
    <xsl:apply-templates mode="xml-to-json">
      <xsl:with-param name="space" select="concat($tab, $space)"/>
      <xsl:with-param name="tab" select="$tab"/>
      <xsl:with-param name="eol" select="$eol"/>
    </xsl:apply-templates>
    <xsl:value-of select="$space"/>
    <xsl:text>}</xsl:text>
    <xsl:if test="position() != last()">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:value-of select="$eol"/>
  </xsl:template>

  <xd:doc>
    <xd:short>Arrays</xd:short>
    <xd:detail xmlns="http://www.w3.org/1999/xhtml">
      <ul>
        <li>Mark up arrays with square brackets []</li>
        <li>Recursively mark up its contents.</li>
        <li>If it's not the last child of its parent, add a comma.</li>
      </ul>
    </xd:detail>
    <xd:param name="space">The current indentation depth, '' by default.</xd:param>
    <xd:param name="tab">Space for each indent level, '' if not($indent).</xd:param>
    <xd:param name="eol">Line ending character, '' if not($indent).</xd:param>
  </xd:doc>
  <xsl:template match="json:array" mode="xml-to-json">
    <xsl:param name="space"/>
    <xsl:param name="tab"/>
    <xsl:param name="eol"/>
    <xsl:value-of select="$space"/>
    <xsl:apply-templates select="@key" mode="xml-to-json"/>
    <xsl:text>[</xsl:text>
    <xsl:value-of select="$eol"/>
    <xsl:apply-templates mode="xml-to-json">
      <xsl:with-param name="space" select="concat($tab, $space)"/>
      <xsl:with-param name="tab" select="$tab"/>
      <xsl:with-param name="eol" select="$eol"/>
    </xsl:apply-templates>
    <xsl:value-of select="$space"/>
    <xsl:text>]</xsl:text>
    <xsl:if test="position() != last()">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:value-of select="$eol"/>
  </xsl:template>

  <xd:doc>
    <xd:short>Strings</xd:short>
    <xd:detail xmlns="http://www.w3.org/1999/xhtml">
      <ul>
        <li>Mark up strings with quotation marks ""</li>
        <li>Call <a href="#xml-to-json-string">xml-to-json-string</a> to escape the text.</li>
        <li>If it's not the last child of its parent, add a comma.</li>
      </ul>
    </xd:detail>
    <xd:param name="space">The current indentation depth, '' by default.</xd:param>
    <xd:param name="eol">Line ending character, '' if not($indent).</xd:param>
  </xd:doc>
  <xsl:template match="json:string" mode="xml-to-json">
    <xsl:param name="space"/>
    <xsl:param name="eol"/>
    <xsl:value-of select="$space"/>
    <xsl:apply-templates select="@key" mode="xml-to-json"/>
    <xsl:text>"</xsl:text>
    <xsl:call-template name="xml-to-json-string">
      <xsl:with-param name="string" select="."/>
    </xsl:call-template>
    <xsl:text>"</xsl:text>
    <xsl:if test="position() != last()">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:value-of select="$eol"/>
  </xsl:template>

  <xd:doc>
    <xd:short>Numbers and Booleans</xd:short>
    <xd:detail xmlns="http://www.w3.org/1999/xhtml">
      <ul>
        <li>Mark up numbers and booleans.</li>
        <li>If it's not the last child of its parent, add a comma.</li>
      </ul>
    </xd:detail>
    <xd:param name="space">The current indentation depth, '' by default.</xd:param>
    <xd:param name="eol">Line ending character, '' if not($indent).</xd:param>
  </xd:doc>
  <xsl:template match="json:number|json:boolean" mode="xml-to-json">
    <xsl:param name="space"/>
    <xsl:param name="eol"/>
    <xsl:value-of select="$space"/>
    <xsl:apply-templates select="@key" mode="xml-to-json"/>
    <xsl:value-of select="."/>
    <xsl:if test="position() != last()">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:value-of select="$eol"/>
  </xsl:template>

  <xd:doc>
    <xd:short>Nulls</xd:short>
    <xd:detail xmlns="http://www.w3.org/1999/xhtml">
      <ul>
        <li>Mark up nulls.</li>
        <li>If it's not the last child of its parent, add a comma.</li>
      </ul>
    </xd:detail>
    <xd:param name="space">The current indentation depth, '' by default.</xd:param>
    <xd:param name="eol">Line ending character, '' if not($indent).</xd:param>
  </xd:doc>
  <xsl:template match="json:null" mode="xml-to-json">
    <xsl:param name="space"/>
    <xsl:param name="eol"/>
   <xsl:value-of select="$space"/>
    <xsl:apply-templates select="@key" mode="xml-to-json"/>
    <xsl:text>null</xsl:text>
    <xsl:if test="position() != last()">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:value-of select="$eol"/>
  </xsl:template>

  <xd:doc>
    <xd:short>Keys</xd:short>
    <xd:detail xmlns="http://www.w3.org/1999/xhtml">
      <ul>
        <li>Mark up keys with quotation marks "" and colon :</li>
        <li>Call <a href="#xml-to-json-string">xml-to-json-string</a> to escape the text.</li>
      </ul>
      <aside>Any map, array, string, number, boolean or null may have a key attribute when a child of a map.</aside>
    </xd:detail>
  </xd:doc>
  <xsl:template match="@key" mode="xml-to-json">
    <xsl:text>"</xsl:text>
    <xsl:call-template name="xml-to-json-string">
      <xsl:with-param name="string" select="."/>
    </xsl:call-template>
     <xsl:text>": </xsl:text>
  </xsl:template>

  <xd:doc>
    <xd:short>Text</xd:short>
    <xd:detail xmlns="http://www.w3.org/1999/xhtml">
      <a id="xml-to-json-string"/>
      <p>Escapes JSON text using DocBook string.subst template.</p>
    </xd:detail>
    <xd:param name="string">The text to escape.</xd:param>
  </xd:doc>
  <xsl:template name="xml-to-json-string">
    <xsl:param name="string"/>
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="$string"/>
      <xsl:with-param name="target" select="'/'"/>
      <xsl:with-param name="replacement" select="'\/'"/>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
