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
        <title>Rule FR_058</title>
        <doc:description>If isTradeItemAConsumerUnit equal true and tradeItemUnitDescriptorCode equal PACK_OR_INNER_PACK and isTradeItemAConsumerUnit equal TRUE and netContent is populated and quantityOfChildren equal 1 then for at least one netContent instance, netContent.@measurementUnitCode must equal to @measurementUnitCode of one of the catalogueItemChildItemLink...netContent instance</doc:description>
        <doc:attribute1>tradeItemUnitDescriptorCode, isTradeItemAConsumerUnit, netContent, quantityOfChildren</doc:attribute1>
        <rule context="catalogueItem">
            <assert test="if ((tradeItem/targetMarket/targetMarketCountryCode =  ('249'(: France :) , '250'(: France :) )) and (gdsnTradeItemClassification/gpcCategoryCode!='10005844') and (gdsnTradeItemClassification/gpcCategoryCode!='10005845') and (isTradeItemAConsumerUnit = 'true') and (tradeItem/tradeItemUnitDescriptorCode = ('PACK_OR_INNER_PACK')) and (tradeItem/isTradeItemAConsumerUnit = 'true') and (tradeItem/tradeItemInformation/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/netContent) and (tradeItem/nextLowerLevelTradeItemInformation/quantityOfChildren = '1')) then (some $node in (tradeItem/tradeItemInformation/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/netContent/@measurementUnitCode) satisfies ($node = catalogueItemChildItemLink/catalogueItem/tradeItem/tradeItemInformation/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/netContent/@measurementUnitCode)) 
            
            	 else true()">
            	 
            	 	
            	 	   <errorMessage>Au moins un des contenus nets d'un lot homogène doit être déclaré dans la même unité de mesure que le contenu net de son composant</errorMessage>
		           
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
