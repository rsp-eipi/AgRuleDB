<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" queryBinding="xslt2" xmlns:doc="http://doc"
    xmlns:data="http://data">
    <!-- define namespaces -->
    <ns uri="urn:gs1:gdsn:catalogue_item_confirmation:xsd:3" prefix="catalogue_item_confirmation"/>
    <ns uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" prefix="sh"/>
    <ns uri="http://data" prefix="data"/>
    <!-- defines contexts -->
    <let name="units" value="doc('../data/data.xml')//data:units"/>
    <pattern>
        <title>Rule FR_053</title>
        <doc:description>If isTradeItemAConsumerUnit equal true and drainedWeight and netWeight are populated then drainedWeight must
            strictly less than netWeight.</doc:description>
        <doc:attribute1>tradeItemWeight/drainedWeight</doc:attribute1>
        <doc:attribute2>tradeItemWeight/netWeight</doc:attribute2>
        <rule context="tradeItem">
            <assert
                test="
                if ((targetMarket/targetMarketCountryCode = ('249' (: France :), '250' (: France :))) and (gdsnTradeItemClassification/gpcCategoryCode!='10005844') and (gdsnTradeItemClassification/gpcCategoryCode!='10005845') and (isTradeItemAConsumerUnit = 'true')) then
                (every $node in(tradeItemInformation/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/tradeItemWeight[exists(./drainedWeight) and exists(./netWeight)]) satisfies(($node/drainedWeight * $units/unit[@code = current()/$node/drainedWeight/@measurementUnitCode]/@coef) &lt;= ($node/netWeight * $units/unit[@code = current()/$node/netWeight/@measurementUnitCode]/@coef)))
                   
                    else true()">
                
                 		 
                 	   <errorMessage>Si renseigné, le poids net égoutté de l'unité commerciale déclarée doit être strictement inférieur à son poids net</errorMessage>
		           
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
