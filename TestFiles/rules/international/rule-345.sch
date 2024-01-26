<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:doc="http://doc"
        queryBinding="xslt2">
   <ns uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
       prefix="sh"/>
    <ns uri="urn:gs1:gdsn:catalogue_item_notification:xsd:3"
        prefix="catalogue_item_notification"/>
   <ns uri="http://data" prefix="data"/>
    
   <pattern>
      <title>Rule 345</title>
      <doc:description>Sender/authority must equal 'GS1'</doc:description>
      <doc:attribute1> Sender/Authority</doc:attribute1>
      <doc:attribute2> Receiver/Authority</doc:attribute2>
       <rule context="tradeItem">
           <assert test="(every $node in (//*:StandardBusinessDocumentHeader/*:Sender/*:Identifier/@Authority, //*:StandardBusinessDocumentHeader/*:Receiver/*:Identifier/@Authority) satisfies $node = 'GS1')">
           
           				 
           						<errorMessage>The 'Authority' value in Sender and Receiver must be set to GS1.</errorMessage>   
          	
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
