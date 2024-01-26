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
      <title>Rule 576</title>
       <doc:description>If isNonGTINLogisticsUnitPackedIrregularly is equal to 'false' then quantityOfTradeItemsPerPallet must equal quantityOfLayersPerPallet multipled by quantityOfTradeItemsPerPalletLayer.</doc:description>
       <doc:attribute1>TradeItemHierarchy/quantityOfTradeItemsPerPallet</doc:attribute1>
       <doc:attribute2>TradeItemHierarchy/quantityOfTradeItemsPerPalletLayer</doc:attribute2>
       <doc:attribute3>TradeItemHierarchy/isNonGTINLogisticsUnitPackedIrregularly</doc:attribute3>
       <rule context="tradeItem/tradeItemInformation/extension/*:tradeItemHierarchyModule/tradeItemHierarchy">
           <assert test="if (isNonGTINLogisticsUnitPackedIrregularly = 'FALSE') then (quantityOfTradeItemsPerPallet = (quantityOfTradeItemsPerPalletLayer*quantityOfLayersPerPallet))
           
           				 else true()">
           				            				 
           				 				
           				 				<errorMessage>If isNonGTINLogisticUnitPackedIrregularly is equal to 'false' then value in quantityOfTradeItemsPerPallet must be equal to value in quantityOfLayersPerPallet multiplied by value in quantityOfTradeItemsPerPalletLayer</errorMessage>
         		
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
