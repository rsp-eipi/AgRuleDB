<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:doc="http://doc" 
		queryBinding="xslt2">
    <ns uri="urn:gs1:gdsn:catalogue_item_confirmation:xsd:3" prefix="catalogue_item_confirmation"/>
    <ns uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" prefix="sh"/>
    <ns uri="http://data" prefix="data"/>
    <let name="units" value="doc('../data/data.xml')//data:units"/>
    <pattern>
        <title>Rule 98</title>
        <doc:description>If specialItemCode does not equal 'DYNAMIC_ASSORTMENT' and parent trade item netWeight and child trade item netWeight are not empty then parent netWeight must be greater than or equal to the sum of (netweight multiplied by quantityOfNextLowerLevelTradeItem) of each child item.</doc:description>
        <doc:attribute1>TradeItemWeight/netWeight</doc:attribute1>
        <doc:attribute2>MarketingInformation/specialItemCode</doc:attribute2>
        <doc:attribute3>ChildTradeItem/quantityOfNextLowerLevelTradeItem</doc:attribute3>
        <rule context="catalogueItem">
            <assert
                test="
                if ((not(tradeItem/tradeItemInformation/extension/*:marketingInformationModule/marketingInformation/specialItemCode = 'DYNAMIC_ASSORTMENT')) and (tradeItem/tradeItemInformation/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/tradeItemWeight/netWeight) and(catalogueItemChildItemLink/catalogueItem/tradeItem/tradeItemInformation/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/tradeItemWeight/netWeight)) then
                (sum(for $node in (catalogueItemChildItemLink/catalogueItem/tradeItem) return ($node/tradeItemInformation[1]/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/tradeItemWeight/netWeight) *($units/unit[@code=current()/$node/tradeItemInformation[1]/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/tradeItemWeight/netWeight/@measurementUnitCode]/@coef)* (current()/tradeItem/nextLowerLevelTradeItemInformation/childTradeItem[gtin=$node/gtin]/quantityOfNextLowerLevelTradeItem))) &lt;= number(tradeItem/tradeItemInformation[1]/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/tradeItemWeight/netWeight * $units/unit[@code=current()/tradeItem/tradeItemInformation[1]/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/tradeItemWeight/netWeight/@measurementUnitCode]/@coef + 0.000001)
                    else true()">
                    
                    
                			
                			<errorMessage>If net weight is populated on both parent and child items, then net weight of the parent must be greater than or equal to the sum of the net weight of all the children except when special item code = DYNAMIC_ASSORTMENT".</errorMessage> 
           	 	
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
											<gtin><xsl:value-of select="tradeItem/gtin"/></gtin>
											<glnProvider><xsl:value-of select="tradeItem/informationProviderOfTradeItem/gln"/></glnProvider>
											<targetMarket><xsl:value-of select="tradeItem/targetMarket/targetMarketCountryCode"/></targetMarket>	
											
						  	 </location>       	
            </assert>
        </rule>
    </pattern>
</schema>
