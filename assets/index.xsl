<?xml version="1.0" encoding="UTF-8"?>
<!--
(The MIT License)

Copyright (c) 2024 Yegor Bugayenko

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the 'Software'), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" doctype-system="about:legacy-compat" encoding="UTF-8" indent="yes"/>
  <xsl:param name="title"/>
  <xsl:param name="date"/>
  <xsl:param name="version"/>
  <xsl:param name="columns"/>
  <xsl:param name="hidden"/>
  <xsl:template name="javascript">
    <xsl:param name="url"/>
    <script type="text/javascript" src="{$url}">
      <xsl:text> </xsl:text>
    </script>
  </xsl:template>
  <xsl:template match="/">
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <title>
          <xsl:choose>
            <xsl:when test="$title = ''">
              <xsl:text>factbase</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$title"/>
            </xsl:otherwise>
          </xsl:choose>
        </title>
        <meta charset="UTF-8"/>
        <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
        <link rel="icon" href="https://www.zerocracy.com/svg/logo.svg" type="image/svg"/>
        <link href="https://cdn.jsdelivr.net/gh/yegor256/tacit@gh-pages/tacit-css.min.css" rel="stylesheet"/>
        <link href="https://cdn.jsdelivr.net/gh/yegor256/drops@gh-pages/drops.min.css" rel="stylesheet"/>
        <xsl:call-template name="javascript">
          <xsl:with-param name="url">https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="javascript">
          <xsl:with-param name="url">https://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.31.3/js/jquery.tablesorter.min.js</xsl:with-param>
        </xsl:call-template>
        <style>
          * { font-family: monospace; }
          section { width: 100%; }
          article { border: none; }
          header img { width: 3em; height: 3em; }
          table { table-layout: fixed; }
          td { word-wrap: break-word; }
          .sorter { cursor: pointer; }
          .S { color: #4A5240; }
          .T { color: #2471A3; }
          .I { color: #61304B; }
          .F { color: #5C0029; }
          .BR { color: #B6C649; }
          .hidden { color: #C1C1C1; }
        </style>
        <script type="text/javascript">
          $(function() {
            $("#facts").tablesorter();
            function updateTime() {
              var now = new Date();
              var timeString = now.toLocaleTimeString();
              $("#currentTime").text(timeString);
            }
            setInterval(updateTime, 1000);
            updateTime();
          });
        </script>
      </head>
      <body>
        <section>
          <header>
            <p>
              <a href="https://www.zerocracy.com">
                <img src="https://www.zerocracy.com/svg/logo.svg" alt="Zerocracy"/>
              </a>
            </p>
          </header>
          <article>
            <xsl:apply-templates select="fb"/>
          </article>
          <footer class="smaller">
            <p>
              <xsl:text>The page was generated by the </xsl:text>
              <a href="https://github.com/yegor256/judges">
                <xsl:text>judges</xsl:text>
              </a>
              <xsl:text> tool (</xsl:text>
              <xsl:value-of select="$version"/>
              <xsl:text>) on </xsl:text>
              <xsl:value-of select="$date"/>
              <xsl:text>.</xsl:text>
              <br/>
              <xsl:text>Properties with columns: </xsl:text>
              <xsl:value-of select="$columns"/>
              <br/>
              <xsl:text>Hidden properties: </xsl:text>
              <xsl:value-of select="$hidden"/>
              <br/>
              <a href="https://github.com/yegor256/factbase">
                <xsl:text>Factbase</xsl:text>
              </a>
              <xsl:text>: </xsl:text>
              <xsl:value-of select="count(fb/f)"/>
              <xsl:text> fact</xsl:text>
              <xsl:if test="count(fb/f) != 1">
                <xsl:text>s</xsl:text>
              </xsl:if>
              <xsl:text>, </xsl:text>
              <xsl:value-of select="fb/@size"/>
              <xsl:text> bytes, version </xsl:text>
              <xsl:value-of select="fb/@version"/>
              <xsl:text>.</xsl:text>
              <br/>
              <xsl:text>Current Time:</xsl:text>
              <span id="currentTime"></span>
            </p>
          </footer>
        </section>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="fb">
    <table id="facts">
      <colgroup>
        <xsl:call-template name="col">
          <xsl:with-param name="cols" select="$columns"/>
        </xsl:call-template>
      </colgroup>
      <thead>
        <tr>
          <xsl:call-template name="th">
            <xsl:with-param name="cols" select="$columns"/>
          </xsl:call-template>
        </tr>
      </thead>
      <tbody>
        <xsl:apply-templates select="f"/>
      </tbody>
    </table>
  </xsl:template>
  <xsl:template match="f">
    <tr>
      <xsl:call-template name="td">
        <xsl:with-param name="cols" select="$columns"/>
        <xsl:with-param name="f" select="."/>
      </xsl:call-template>
    </tr>
  </xsl:template>
  <xsl:template name="col">
    <xsl:param name="cols"/>
    <xsl:choose>
      <xsl:when test="string-length($cols) &gt; 0">
        <col style=""/>
        <xsl:call-template name="col">
          <xsl:with-param name="cols" select="substring-after($cols, ',')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <col style="width: 50%;"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="th">
    <xsl:param name="cols"/>
    <xsl:choose>
      <xsl:when test="string-length($cols) &gt; 0">
        <th class="sorter">
          <xsl:value-of select="substring-before(concat($cols, ','), ',')"/>
        </th>
        <xsl:call-template name="th">
          <xsl:with-param name="cols" select="substring-after($cols, ',')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <th>
          <xsl:text>&nbsp;</xsl:text>
        </th>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="td">
    <xsl:param name="cols"/>
    <xsl:param name="f"/>
    <xsl:choose>
      <xsl:when test="string-length($cols) &gt; 0">
        <td>
          <xsl:variable name="c" select="substring-before(concat($cols, ','), ',')"/>
          <xsl:call-template name="value">
            <xsl:with-param name="v" select="$f/*[name()=$c]"/>
          </xsl:call-template>
        </td>
        <xsl:call-template name="td">
          <xsl:with-param name="cols" select="substring-after($cols, ',')"/>
          <xsl:with-param name="f" select="$f"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <td>
          <xsl:for-each select="$f/*">
            <xsl:text> </xsl:text>
            <xsl:variable name="visible" select="string-length(substring-before(concat(' ,', $hidden, ','), concat(',', name(), ','))) = 0"/>
            <xsl:if test="string-length(substring-before(concat(' ,', $columns, ','), concat(',', name(), ','))) = 0">
              <xsl:choose>
                <xsl:when test="$visible">
                  <xsl:value-of select="name()"/>
                </xsl:when>
                <xsl:otherwise>
                  <span class="hidden" title="{.}">
                    <xsl:value-of select="name()"/>
                  </span>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:if test="$visible">
                <xsl:text>:</xsl:text>
                <xsl:call-template name="value">
                  <xsl:with-param name="v" select="."/>
                </xsl:call-template>
              </xsl:if>
            </xsl:if>
          </xsl:for-each>
        </td>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="value">
    <xsl:param name="v"/>
    <xsl:choose>
      <xsl:when test="$v/v">
        <xsl:text>[</xsl:text>
        <xsl:for-each select="$v/v">
          <xsl:if test="position() &gt; 1">
            <xsl:text>, </xsl:text>
          </xsl:if>
          <xsl:call-template name="value">
            <xsl:with-param name="v" select="."/>
          </xsl:call-template>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <span>
          <xsl:attribute name="class">
            <xsl:value-of select="$v/@t"/>
          </xsl:attribute>
          <xsl:value-of select="$v"/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
