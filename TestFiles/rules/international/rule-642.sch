<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:doc="http://doc"
        queryBinding="xslt2">
   <ns uri="urn:gs1:gdsn:catalogue_item_confirmation:xsd:3"
       prefix="catalogue_item_confirmation"/>
   <ns uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
       prefix="sh"/>
   <ns uri="http://data" prefix="data"/>
   <let name="units" value="doc('../data/data.xml')//data:units"/>
   <pattern>
      <title>Rule 642</title>
      <doc:description>If isTradeItemAConsumerUnit is equal to 'true' and targetMarketCountryCode is equal to '840'(United States) then dataCarrierTypeCode must not be empty</doc:description>
      <doc:attribute1>DataCarrier/dataCarrierTypeCode</doc:attribute1>
      <doc:attribute2>TradeItem/isTradeItemAConsumerUnit</doc:attribute2>
      <rule context="tradeItem">
         <assert test="if ( (isTradeItemAConsumerUnit = 'true')  and  (targetMarket/targetMarketCountryCode = '840'(: United States :) ) ) then  exists(tradeItemInformation/extension/*:tradeItemDataCarrierAndIdentificationModule/dataCarrier/dataCarrierTypeCode) and (every $node in (tradeItemInformation/extension/*:tradeItemDataCarrierAndIdentificationModule/dataCarrier/dataCarrierTypeCode) satisfies not ( (empty($node)) ) )
         
         			   else true()">
         			   
         			   			
         			   					<errorMessage>If the Trade Item is a consumer unit, and the target market country code is '840' (US), the type of bar code [dataCarrierTypeCode] is mandatory</errorMessage>
         		
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
