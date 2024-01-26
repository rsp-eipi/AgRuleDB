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
        <title>Rule FR_068</title>
        <doc:description>If isTradeItemAConsumerUnit equal true and freeQuantityOfNextLowerLevelTradeItem is populated and
            catalogueItemChildItemLink is populated then for each promotionalItemInformation, one
            catalogueItemChildItemLink...gtin must equal
            promotionalItemInformation...nonPromotionalTradeItem...gtin and one of this
            catalogueItemChildItemLink...netContent...@measurementUnitCode must equal this
            promotionalItemInformation...freeQuantityOfNextLowerLevelTradeItem...@measurementUnitCode</doc:description>
        <doc:attribute1>catalogueItem[1]/tradeItem[1]/targetMarket[1]/targetMarketCountryCode[1]</doc:attribute1>
        <doc:attribute2>freeQuantityOfNextLowerLevelTradeItem, netContent,
            nonPromotionalTradeItem</doc:attribute2>
        <rule context="catalogueItem">
            <assert
                test="
                if ((tradeItem/targetMarket/targetMarketCountryCode = ('249' (: France :), '250' (: France :))) and (tradeItem/gdsnTradeItemClassification/gpcCategoryCode!='10005844') and (tradeItem/gdsnTradeItemClassification/gpcCategoryCode!='10005845') and (tradeItem/isTradeItemAConsumerUnit = 'true') and (tradeItem/tradeItemInformation/extension/*:promotionalItemInformationModule/promotionalItemInformation/freeQuantityOfNextLowerLevelTradeItem) and (catalogueItemChildItemLink)) then
                (every $node in (tradeItem/tradeItemInformation/extension/*:promotionalItemInformationModule/promotionalItemInformation[exists(freeQuantityOfNextLowerLevelTradeItem)])
                            satisfies (some $node2 in (catalogueItemChildItemLink/catalogueItem/tradeItem)
                                satisfies (($node/nonPromotionalTradeItem/gtin = $node2/gtin) and (some $node3 in ($node2/tradeItemInformation/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/netContent/@measurementUnitCode) satisfies ($node3 = $node/freeQuantityOfNextLowerLevelTradeItem/@measurementUnitCode)))))
                    else true()">
                    
                 
             		   <errorMessage>Si un lot consommateur promotionnel offre une quantité gratuite sur un des ces composants (Type: "Plus gratuit" ou "dont gratuit") alors cette quantité gratuite doit s'exprimer dans la même unité de mesure que le contenu net du composant concerné.</errorMessage>
		           
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
