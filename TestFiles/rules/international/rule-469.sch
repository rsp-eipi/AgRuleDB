<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:doc="http://doc"
        queryBinding="xslt2">
   <ns uri="urn:gs1:gdsn:catalogue_item_confirmation:xsd:3"
       prefix="catalogue_item_confirmation"/>
   <ns uri="urn:gs1:gdsn:catalogue_item_subscription:xsd:3" 
       prefix="catalogue_item_subscription"/>
   <ns uri="urn:gs1:gdsn:registry_catalogue_item:xsd:3" prefix="registry_catalogue_item"/>
   <ns uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
       prefix="sh"/>
   <ns uri="http://data" prefix="data"/>
   <pattern>
      <title>Rule 469</title>
       <doc:description>If targetMarketCountryCode is equal to '528' (Netherlands) then gtin must not include the following company prefixes 0020 to 0029, 0040 to 0049 or 0200 to 0299.</doc:description>
       <doc:attribute1>targetMarketCountryCode, gtin</doc:attribute1>
      <rule context="tradeItem">
          <assert test="if (targetMarket/targetMarketCountryCode = '528' (:Netherlands:)) then every $node in (//gtin) satisfies (not(starts-with($node,'002') or starts-with($node,'004') or starts-with($node,'02')))
          
          				else true()">
          							
             					 
             				   <errorMessage>For Target Market '528' (Netherlands) codes starting with 0020-0029, 0040-0049, 0200-0299 are not allowed.</errorMessage>
				           
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
