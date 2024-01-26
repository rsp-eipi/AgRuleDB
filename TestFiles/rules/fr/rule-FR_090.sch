<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" queryBinding="xslt2"
  xmlns:doc="http://doc"
  xmlns:data="http://data">
  <!-- define namespaces -->
  <ns uri="urn:gs1:gdsn:catalogue_item_confirmation:xsd:3" prefix="catalogue_item_confirmation"/>
  <ns uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" prefix="sh"/>
  <ns uri="http://data" prefix="data"/>
  <!-- defines contexts -->
  <let name="units" value="doc('../data/data.xml')//data:units"/>
  <pattern>
    <title>Rule FR_090</title>
    <doc:description>If isTradeItemAConsumerUnit equal true and priceComparisonContentTypeCode equal DRAINED_WEIGHT then if populated, drainedWeight must equal priceComparisonMeasurement (Be carreful to UOM)</doc:description>
    <doc:attribute1>targetMarket/targetMarketCountryCode</doc:attribute1>
    <doc:attribute2>priceComparisonContentTypeCode, drainedWeight, priceComparisonMeasurement</doc:attribute2>
    <rule context="tradeItem">
      <assert test="if((targetMarket/targetMarketCountryCode = ('249' (: France :), '250' (: France :))) and (gdsnTradeItemClassification/gpcCategoryCode!='10005844') and (gdsnTradeItemClassification/gpcCategoryCode!='10005845') and (isTradeItemAConsumerUnit = 'true'))
        then (every $node in (tradeItemInformation/extension) satisfies( if(($node/*:salesInformationModule/salesInformation/priceComparisonContentTypeCode = 'DRAINED_WEIGHT') and ($node/*:tradeItemMeasurementsModule/tradeItemMeasurements/tradeItemWeight/drainedWeight)) then(some $node2 in ($node/*:salesInformationModule/salesInformation/priceComparisonMeasurement) satisfies((number($node/*:tradeItemMeasurementsModule/tradeItemMeasurements/tradeItemWeight/drainedWeight * $units/unit[@code=current()/$node/*:tradeItemMeasurementsModule/tradeItemMeasurements/tradeItemWeight/drainedWeight/@measurementUnitCode]/@coef) &gt;= ($node2 * $units/unit[@code = current()/$node2/@measurementUnitCode]/@coef - 0.000001)) and (number($node/*:tradeItemMeasurementsModule/tradeItemMeasurements/tradeItemWeight/drainedWeight * $units/unit[@code=current()/$node/*:tradeItemMeasurementsModule/tradeItemMeasurements/tradeItemWeight/drainedWeight/@measurementUnitCode]/@coef) &lt;= ($node2 * $units/unit[@code = current()/$node2/@measurementUnitCode]/@coef + 0.000001)))) else true()))
        
        	else true()">
        	
        		
        		       <errorMessage>Si Type de Mesure / affichage du prix est DRAINED_WEIGHT alors le poids net égoutté est égal à « Mesure / affichage du prix» (ATTENTION à la conversion entre la quantité exprimé en kilogramme est le poids net égoutté)</errorMessage>
		           
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