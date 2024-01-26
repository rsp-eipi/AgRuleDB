<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:doc="http://doc" queryBinding="xslt2">
    <ns uri="urn:gs1:gdsn:catalogue_item_confirmation:xsd:3" prefix="catalogue_item_confirmation"/>
    <ns uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" prefix="sh"/>
    <ns uri="http://data" prefix="data"/>
    <let name="units" value="doc('../data/data.xml')//data:units"/>
    <pattern>
        <title>Rule FR_048</title>
        <doc:description>If isTradeItemAConsumerUnit equal true and freeQuantityOfProduct is populated then (for each freeQuantityOfProduct,
            there must be at least one netContent element expressed in a Unit Of Measure that is
            sharing the same category than the one used to express this freeQuantityOfProduct) and
            (for all netContent expresssed in a Unit Of Measure sharing the same category that he
            one of freeQuantityOfProduct, freeQuantityOfProduct must be less or equal than
            netContent)</doc:description>
        <doc:attribute1>freeQuantityOfProduct, netContent</doc:attribute1>
        <rule context="tradeItem">
            <assert
                test="if((targetMarket/targetMarketCountryCode =  ('249'(: France :) , '250'(: France :) )) and (gdsnTradeItemClassification/gpcCategoryCode!='10005844') and (gdsnTradeItemClassification/gpcCategoryCode!='10005845') and (isTradeItemAConsumerUnit = 'true')) 
                then every $node in (tradeItemInformation/extension) satisfies(if($node/*:promotionalItemInformationModule/promotionalItemInformation/freeQuantityOfProduct) then (every $node1 in ($node/*:promotionalItemInformationModule/promotionalItemInformation/freeQuantityOfProduct) satisfies (every $node2 in (for $node3 in ($node/*:tradeItemMeasurementsModule/tradeItemMeasurements/netContent) return (if($units/unit[@code=current()/$node3/@measurementUnitCode]/@type = $units/unit[@code=current()/$node1/@measurementUnitCode]/@type) then ($node3 * $units/unit[@code = current()/$node3/@measurementUnitCode]/@coef) else())) satisfies (exists($node2) and (number($node2 + 0.000001) &gt;= number($node1 * $units/unit[@code = current()/$node1/@measurementUnitCode]/@coef)))))else true())
                
                	 else true()">
                	 
                
              		   <errorMessage>La quantité gratuite dans une offre promotionnelle ne doit pas dépasser la quantité totale de l'unité consommateur</errorMessage>
		           
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
