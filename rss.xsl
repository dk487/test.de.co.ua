<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">
  <xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>RSS: <xsl:value-of select="/rss/channel/title"/></title>
        <style type="text/css">
          body { max-width: 50em; padding: 1em; margin: 0 auto }
        </style>
      </head>
      <body>
        <main>
          <h1><xsl:value-of select="/rss/channel/title"/></h1>
          <p><xsl:value-of select="/rss/channel/description"/></p>
          <p>
            Це канал RSS.
            <a href="">
              <xsl:attribute name="href">
                <xsl:value-of select="/rss/channel/link"/>
              </xsl:attribute>
              Перейти до повної версії сайту.
            </a>
          </p>
          <ul>
            <xsl:for-each select="/rss/channel/item">
              <li>
                <p>
                  <a href="">
                    <xsl:attribute name="href">
                      <xsl:value-of select="link"/>
                    </xsl:attribute>
                    <xsl:value-of select="concat(
                      substring(pubDate,13,4), '-',
                      substring(pubDate,9,3), '-',
                      substring(pubDate,6,2))" />:
                    <xsl:value-of select="title"/>
                  </a>
                </p>
              </li>
            </xsl:for-each>
          </ul>
        </main>
        <footer>
          <copyright><xsl:value-of select="/rss/channel/copyright"/></copyright>
        </footer>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
