<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		queryBinding="xslt2"
  		xmlns:doc="http://doc">
  <!-- define namespaces -->
  <ns uri="urn:gs1:gdsn:catalogue_item_confirmation:xsd:3" prefix="catalogue_item_confirmation"/>
  <ns uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" prefix="sh"/>
  <!-- defines contexts -->
  <pattern>
    <title>Rule 96</title>
    <doc:description>If <tofix action="replace" value="tradeItemUnitDescriptorCode">tradeItemUnitDescriptor</tofix> is equal to 'BASE_UNIT_OR_EACH' then ChildTradeItem/gtin must be empty.</doc:description>
    <doc:attribute1><tofix action="lowercase">C</tofix>hildTradeItem<fix action="remove">/TradeItemIdentification</fix>/gtin</doc:attribute1>
    <doc:attribute2><tofix action="lowercase">T</tofix>radeItem/tradeItemUnitDescriptorCode</doc:attribute2>
    <rule context="tradeItem">      
	      <report test="if (tradeItemUnitDescriptorCode = 'BASE_UNIT_OR_EACH') then nextLowerLevelTradeItemInformation/childTradeItem/gtin else false()">
	      
	       					
	       					 			<errorMessage>A parent item with a tradeItemUnitDescriptorCode of BASE_UNIT_OR_EACH may not contain a child item.</errorMessage>
         		
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
	       					 
		  </report>
    </rule>
  </pattern>
</schema>