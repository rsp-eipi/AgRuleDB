<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:doc="http://doc"
        queryBinding="xslt2">
   <ns uri="urn:gs1:gdsn:catalogue_item_confirmation:xsd:3"
       prefix="catalogue_item_confirmation"/>
   <ns uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
       prefix="sh"/>
   <ns uri="http://data" prefix="data"/>
   <let name="units" value="doc('../data/data.xml')//data:units"/>
   <pattern>
      <title>Rule 1040</title>
      <doc:description>If additionalTradeItemIdentificationTypeCode is equal to 'GTIN_8' then associated additionTradeItemIdentification value must have 8 digits and must have a valid check digit</doc:description>
      <doc:attribute1>TradeItemIdentification/additionalTradeItemIdentification/additionalTradeItemIdentificationTypeCode</doc:attribute1>
      <doc:attribute2>TradeItemIdentification/additionalTradeItemIdentification</doc:attribute2>
      <rule context="tradeItem">
         <assert test="if (additionalTradeItemIdentification/@additionalTradeItemIdentificationTypeCode = 'GTIN_8') then  exists(additionalTradeItemIdentification) and (every $node in (additionalTradeItemIdentification) satisfies string-length($node) =  8  and  (2*sum((for $b in string-to-codepoints(substring($node, 1, 7))              return ($b - 48))[position() mod 2 = 1]) + sum(for $b in string-to-codepoints(substring($node, 1, 7))              return ($b - 48)) + number(substring($node, 8, 1))) mod 10 = 0 )
         
         	 else true()">
         	 
         	 	
         	 	<errorMessage>If additionalTradeItemIdentificationTypeCode equals 'GTIN_8' then associated additionTradeItemIdentification value must have 8 digits and must have a valid check digit.</errorMessage>
                
                <location>
						<!-- Fichier SDBH -->
						<messageId><xsl:value-of select="/*/sh:StandardBusinessDocumentHeader/sh:DocumentIdentification/sh:InstanceIdentifier"/></messageId>
						<messageOwner><xsl:value-of select="/*/sh:StandardBusinessDocumentHeader/sh:Sender/sh:Identifier"/></messageOwner>
											
						<transactionId><xsl:value-of select="ancestor::transaction/transactionIdentification/entityIdentification"/></transactionId>
						<transactionOwner><xsl:value-of select="ancestor::transaction/transactionIdentification/contentOwner/gln"/></transactionOwner>
						<commandId><xsl:value-of select="ancestor::documentCommand/documentCommandHeader/documentCommandIdentification/entityIdentification"/></commandId>
						<commandOwner><xsl:value-of select="ancestor::documentCommand/documentCommandHeader/documentCommandIdentification/contentOwner/gln"/></commandOwner>
						<!-- Fichier CIN -->
						<documentId><xsl:value-of select="ancestor::*:catalogueItemNotification/catalogueItemNotificationIdentification/entityIdentification"/></documentId>
						<documentOwner><xsl:value-of select="ancestor::*:catalogueItemNotification/catalogueItemNotificationIdentification/contentOwner/gln"/></documentOwner>
						<!--  Le 1er tradeItem . 1 seul car les autres sont imbriqués -->
						<gtinHigh><xsl:value-of select="ancestor::*:catalogueItemNotification/catalogueItem/tradeItem/gtin"/></gtinHigh>
						<!-- Context = TradeItem -->
						<gtin><xsl:value-of select="gtin"/></gtin>
						<glnProvider><xsl:value-of select="informationProviderOfTradeItem/gln"/></glnProvider>
						<targetMarket><xsl:value-of select="targetMarket/targetMarketCountryCode"/></targetMarket>	
						
				</location>
         	 	
 	 	 </assert>
      </rule>
   </pattern>
</schema>
