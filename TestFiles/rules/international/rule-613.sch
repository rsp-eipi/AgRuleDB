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
        <title>Rule 613</title>
        <doc:description>If isTradeItemAConsumerUnit is equal to 'true' then freeQuantityOfProduct must be less or equal to netContent</doc:description>
        <doc:attribute1>PromotionalItemInformation/freeQuantityOfProduct</doc:attribute1>
        <doc:attribute2>TradeItemMeasurements/netContent</doc:attribute2>
        <doc:attribute3>TradeItem/isTradeItemAConsumerUnit</doc:attribute3>
        <rule context="tradeItem">
            <assert test="if (isTradeItemAConsumerUnit = 'true') then (every $node in (tradeItemInformation/extension) satisfies (if($node/*:tradeItemMeasurementsModule/tradeItemMeasurements/netContent) then(every $node1 in ($node/*:promotionalItemInformationModule/promotionalItemInformation/freeQuantityOfProduct) satisfies  ( some $node2 in ($node/*:tradeItemMeasurementsModule/tradeItemMeasurements/netContent) satisfies (number($node1*$units/unit[@code=current()/$node1/@measurementUnitCode]/@coef) &lt;= number($node2 * $units/unit[@code=current()/$node2/@measurementUnitCode]/@coef)+0.000001))) else true()))
            
            			  else true()">
            			  
            			  		
            			  				   <errorMessage>The free quantity (freeQuantityOfProduct) in a promotional offer should not exceed the Content net (netContent) of the consumer unit</errorMessage>
				           
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
