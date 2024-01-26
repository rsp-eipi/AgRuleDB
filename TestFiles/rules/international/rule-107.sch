<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:doc="http://doc"
        queryBinding="xslt2">
    <ns uri="http://urn:gs1:gdsn:registry_catalogue_item:xsd:3"
        prefix="registry_catalogue_item"/>
    <ns uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
       prefix="sh"/>
   <ns uri="http://data" prefix="data"/>
   <let name="units" value="doc('../data/data.xml')//data:units"/>
   <pattern>
      <title>Rule 107</title>
       <doc:description>If discontinuedDateTime is not empty then cancelDateTime must be empty.</doc:description>
       <doc:attribute1>CatalogueItemDates/discontinuedDateTime</doc:attribute1>
       <doc:attribute2>CatalogueItemDates/cancelDateTime</doc:attribute2>
       <rule context="catalogueItemDates">
           <assert test="if (discontinuedDateTime) then (every $node in (cancelDateTime) satisfies (empty($node)))
           
           		 else true()">
           		 
           		 	
           		 	<errorMessage>The discontinuedDateTime and the cancelDateTime were both set for the same item or the CatalogueItem and TradeItem discontinuedDatesTime and cancelDateTime were not the same.</errorMessage> 
           		 	
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
							<gtin><xsl:value-of select="ancestor::tradeItem/gtin"/></gtin>
							<glnProvider><xsl:value-of select="ancestor::tradeItem/informationProviderOfTradeItem/gln"/></glnProvider>
							<targetMarket><xsl:value-of select="ancestor::tradeItem/targetMarket/targetMarketCountryCode"/></targetMarket>	
					
					</location>            		 	
				
	 	   </assert>
      </rule>
   </pattern>
</schema>
