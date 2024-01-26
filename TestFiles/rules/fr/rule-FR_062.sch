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
        <title>Rule FR_062</title>
        <doc:description>If isTradeItemADespatchUnit equal TRUE and for each
            catalogueItemChildItemLink...isTradeItemADespatchUnit equal TRUE and isTradeItemAService
            equal FALSE then width*depth*height must be greater or equal to the sum of
            catalogueItemChildItemLink.quantity*catalogueItemChildItemLink..width*catalogueItemChildItemLink..depth*catalogueItemChildItemLink..height
            for each catalogueItemChildItemLink</doc:description>
        <doc:attribute1>startAvailabilityDatetime</doc:attribute1>
        <rule context="catalogueItem">
            <assert
                test="
                if ((tradeItem/targetMarket/targetMarketCountryCode = ('249' (: France :), '250' (: France :)))and (tradeItem/gdsnTradeItemClassification/gpcCategoryCode!='10005844') and (tradeItem/gdsnTradeItemClassification/gpcCategoryCode!='10005845') and (tradeItem/isTradeItemADespatchUnit = 'true') and (every $node3 in(catalogueItemChildItemLink/catalogueItem/tradeItem) satisfies(($node3/isTradeItemADespatchUnit = 'true') and ($node3/isTradeItemAService = 'false')))) then
                        (every $node in (tradeItem/tradeItemInformation[1]/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements)
                        satisfies(number(($node/width * $units/unit[@code = current()/$node/width/@measurementUnitCode]/@coef) * ($node/depth * $units/unit[@code = current()/$node/depth/@measurementUnitCode]/@coef) * ($node/height * $units/unit[@code = current()/$node/height/@measurementUnitCode]/@coef) +0.000001) &gt;= sum(for $node2 in (catalogueItemChildItemLink/catalogueItem/tradeItem) return ($node2/tradeItemInformation[1]/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/width * $units/unit[@code = current()/$node2/tradeItemInformation[1]/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/width/@measurementUnitCode]/@coef) * ($node2/tradeItemInformation[1]/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/depth * $units/unit[@code = current()/$node2/tradeItemInformation[1]/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/depth/@measurementUnitCode]/@coef) * ($node2/tradeItemInformation[1]/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/height * $units/unit[@code = current()/$node2/tradeItemInformation[1]/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/height/@measurementUnitCode]/@coef) * (current()/tradeItem/nextLowerLevelTradeItemInformation/childTradeItem[gtin=$node2/gtin]/quantityOfNextLowerLevelTradeItem))
                            ))
                    else true()">
                    
                    
			                
	                   <errorMessage>Le volume d'une unité logistique doit être supérieure ou égale à la somme des volumes des unités logistiques fils (si ces unités commerciales fils existent). Cette règle ne s'applique que pour les unités logistiques. Le volume étant calculé comme le produit de la hauteur, largeur et profondeur. Exemple: volume de la palette >equal volume du carton * nombre de cartons</errorMessage>
		           
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
