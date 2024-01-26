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
        <title>Rule 519</title>
        <doc:description>If targetMarketCountryCode is equal to '752' (Sweden) and layerHeight is not empty then value must equal child item width, depth or height.</doc:description>
        <doc:attribute1>TradeItemHierarchy/layerHeight</doc:attribute1>
        <doc:attribute2>TradeItemMeasurements/height</doc:attribute2>
        <doc:attribute3>TradeItemMeasurements/width</doc:attribute3>
        <doc:attribute4>TradeItemMeasurements/depth</doc:attribute4>
        <rule context="catalogueItem">
            <assert test="if ( (tradeItem/targetMarket/targetMarketCountryCode =  ('752' (:Sweden:) ) )  and  (tradeItem/tradeItemInformation/extension/*:tradeItemHierarchyModule/tradeItemHierarchy/layerHeight)) then  (some $node in (catalogueItemChildItemLink/catalogueItem/tradeItem/tradeItemInformation/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/width,catalogueItemChildItemLink/catalogueItem/tradeItem/tradeItemInformation/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/depth,catalogueItemChildItemLink/catalogueItem/tradeItem/tradeItemInformation/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/height) satisfies (($node*($units/unit[@code=current()/$node/@measurementUnitCode]/@coef)) = (tradeItem/tradeItemInformation/extension/*:tradeItemHierarchyModule/tradeItemHierarchy/layerHeight)*($units/unit[@code=current()/tradeItem/tradeItemInformation/extension/*:tradeItemHierarchyModule/tradeItemHierarchy/layerHeight/@measurementUnitCode]/@coef)) )
            
            			  else true()">
            			  
            			  			
            			  			<errorMessage>If targetMarketCountryCode is equal to '752' (Sweden) layerHeight must have the same value as one of the values in width, depth or height of the child item.</errorMessage> 
           	 	
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
