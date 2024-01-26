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
    <pattern>
        <title>Rule 446</title>
        <doc:description>If isTradeItemPackedIrregularly equals 'FALSE' and tradeItemCompositionWidth, tradeItemCompositionDepth and quantityOfCompleteLayersContainedInATradeItem are all supplied and tradeItemCompositionWidth/measurementUnitCode and tradeItemCompositionDepth/measurementUnitCode equal 'EA' then the product of the three attributes should equal the totalQuantityOfNextLowerLevelTradeItem.</doc:description>
        <doc:attribute1>TradeItemMeasurements/tradeItemCompositionDepth, TradeItemMeasurements/tradeItemCompositionWidth, TradeItemHierarchy/quantityOfCompleteLayersContainedInATradeItem</doc:attribute1>
        <doc:attribute2>NextLowerLevelTradeItemInformation/totalQuantityOfNextLowerLevelTradeItem</doc:attribute2>
        <rule context="tradeItem">
            <assert test="every $node in(tradeItemInformation/extension) satisfies (if(($node/*:tradeItemHierarchyModule/tradeItemHierarchy/isTradeItemPackedIrregularly='FALSE') and ($node/*:tradeItemHierarchyModule/tradeItemHierarchy/quantityOfCompleteLayersContainedInATradeItem) and ($node/*:tradeItemMeasurementsModule/tradeItemMeasurements/tradeItemCompositionDepth/@measurementUnitCode='EA') and ($node/*:tradeItemMeasurementsModule/tradeItemMeasurements/tradeItemCompositionWidth/@measurementUnitCode='EA')) then ( exists(nextLowerLevelTradeItemInformation/totalQuantityOfNextLowerLevelTradeItem) and (nextLowerLevelTradeItemInformation/totalQuantityOfNextLowerLevelTradeItem = ($node/*:tradeItemHierarchyModule/tradeItemHierarchy/quantityOfCompleteLayersContainedInATradeItem * $node/*:tradeItemMeasurementsModule/tradeItemMeasurements/tradeItemCompositionDepth * $node/*:tradeItemMeasurementsModule/tradeItemMeasurements/tradeItemCompositionWidth)))
            
            			  else true())">
            			  
            			  		<errorMessage>If isTradeItemPackedIrregularly equals 'FALSE' and tradeItemCompositionWidth, tradeItemCompositionDepth and quantityOfCompleteLayersContainedInATradeItem are all supplied and tradeItemCompositionWidth/measurementUnitCode and tradeItemCompositionDepth/measurementUnitCode equal 'EA' then the product of the three attributes should equal the totalQuantityOfNextLowerLevelTradeItem.</errorMessage>   
          	
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
