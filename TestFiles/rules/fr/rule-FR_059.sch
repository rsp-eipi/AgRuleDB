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
        <title>Rule FR_059</title>
        <doc:description>If isTradeItemADespatchUnit = 'true' and tradeItemUnitDescriptorCode equal PALLET | MIXED_MODULE and catalogueItemChildItemLink...tradeItemUnitDescriptorCode equal CASE | DISPLAY_SHIPPER then depth must be greater or equal than catalogueItemChildItemLink...depth</doc:description>
        <doc:attribute1>tradeItem/tradeItemUnitDescriptorCode, depth</doc:attribute1>
        <rule context="catalogueItem">
            <assert
                test="if ((tradeItem/targetMarket/targetMarketCountryCode =  ('249'(: France :) , '250'(: France :) )) and (tradeItem/gdsnTradeItemClassification/gpcCategoryCode!='10005844') and (tradeItem/gdsnTradeItemClassification/gpcCategoryCode!='10005845') and (tradeItem/isTradeItemADespatchUnit = 'true') and (tradeItem/tradeItemUnitDescriptorCode = ('PALLET','MIXED_MODULE')) and (catalogueItemChildItemLink/catalogueItem/tradeItem/tradeItemUnitDescriptorCode = ('CASE','DISPLAY_SHIPPER'))) 
                then(every $node in (catalogueItemChildItemLink/catalogueItem/tradeItem/tradeItemInformation[1]/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/depth) satisfies (number(tradeItem/tradeItemInformation[1]/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/depth * $units/unit[@code=current()/tradeItem/tradeItemInformation[1]/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/depth/@measurementUnitCode]/@coef + 0.000001) &gt;= number( $node * $units/unit[@code=current()/$node/@measurementUnitCode]/@coef))) 
                
                	else true()">
                	
                  		
                  	   <errorMessage>Pour les produits PGC, la profondeur d'un carton doit toujours être INFERIEUR ou égale à la profondeur de sa palette</errorMessage>
		           
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
