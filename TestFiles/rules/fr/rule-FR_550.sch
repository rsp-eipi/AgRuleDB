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
        <title>Rule FR_550</title>
        <doc:description>IF specialItemCode does not equal 'DYNAMIC_ASSORTMENT' and grossWeight is not empty then grossWeight must be greater than or equal to the sum of the grossWeight of the child items.</doc:description>
        <doc:attribute1>catalogueItem[1]/tradeItem[1]/targetMarket[1]/targetMarketCountryCode[1]</doc:attribute1>
        <doc:attribute2> grossWeight</doc:attribute2>
        <rule context="catalogueItem">
            <assert
                test="
                if ((tradeItem/targetMarket/targetMarketCountryCode = ('249' (: France :), '250' (: France :))) and (tradeItem/gdsnTradeItemClassification/gpcCategoryCode!='10005844') and (tradeItem/gdsnTradeItemClassification/gpcCategoryCode!='10005845') and (not(tradeItem/tradeItemInformation/extension/*:marketingInformationModule/marketingInformation/specialItemCode = 'DYNAMIC_ASSORTMENT')) and (tradeItem/tradeItemInformation/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/tradeItemWeight/grossWeight) and(catalogueItemChildItemLink/catalogueItem/tradeItem/tradeItemInformation/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/tradeItemWeight/grossWeight)) then
                (sum(for $node in (catalogueItemChildItemLink/catalogueItem/tradeItem) return ($node/tradeItemInformation[1]/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/tradeItemWeight/grossWeight) *($units/unit[@code=current()/$node/tradeItemInformation[1]/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/tradeItemWeight/grossWeight/@measurementUnitCode]/@coef)* (current()/tradeItem/nextLowerLevelTradeItemInformation/childTradeItem[gtin=$node/gtin]/quantityOfNextLowerLevelTradeItem))) &lt;= number(tradeItem/tradeItemInformation[1]/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/tradeItemWeight/grossWeight * $units/unit[@code=current()/tradeItem/tradeItemInformation[1]/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/tradeItemWeight/grossWeight/@measurementUnitCode]/@coef + 0.000001)
                else
                true()">
                
               	 <errorMessage>Si le poids brut (grossWeight) est indiqué pour une unité commerciale parente et ses fils directs, le poids brut de l'unité commercial parente doit être supérieur ou égal à la somme des poids bruts des fils, (excepté si special item code = dynamic_assortment)</errorMessage>	 
               	 
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
