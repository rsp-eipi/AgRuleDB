<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:doc="http://doc"
        queryBinding="xslt2">
   <ns uri="urn:gs1:gdsn:catalogue_item_confirmation:xsd:3"
       prefix="catalogue_item_confirmation"/>
   <ns uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
       prefix="sh"/>
   <ns uri="http://data" prefix="data"/>
   <let name="units" value="doc('../data/data.xml')//data:units"/>
   <pattern>
      <title>Rule FR_083</title>
       <doc:description>If isTradeItemAConsumerUnit equal true and gpcCategoryCode not equal to "10000050","10000262'' and priceComparisonContentTypeCode equal PER_LITRE then priceComparisonMeasurement and netContent must be expressed using UOM whose category is VOLUME.</doc:description>
       <doc:attribute1>priceComparisonContentTypeCode, priceComparisonMeasurement, netContent</doc:attribute1>
      <rule context="tradeItem">
          <assert test="if((targetMarket/targetMarketCountryCode =  ('249'(: France :) , '250'(: France :) )) and (gdsnTradeItemClassification/gpcCategoryCode!='10005844') and (gdsnTradeItemClassification/gpcCategoryCode!='10005845') and (isTradeItemAConsumerUnit = 'true') and (gdsnTradeItemClassification/gpcCategoryCode != '10000050') and (gdsnTradeItemClassification/gpcCategoryCode != '10000262')) then (every $node in (tradeItemInformation/extension) satisfies (if($node/*:salesInformationModule/salesInformation/priceComparisonContentTypeCode = 'PER_LITRE') then every $node1 in ($node/*:salesInformationModule/salesInformation/priceComparisonMeasurement/@measurementUnitCode, $node/*:tradeItemMeasurementsModule/tradeItemMeasurements/netContent/@measurementUnitCode) satisfies  ( $units/unit[@code=$node1]/@type =  'Volume' ) else true())) 
          
          	 else true()">
          	 
          	 	
          	 	       <errorMessage>Si l’unité de mesure légale est exprimée en volume, l’affichage du prix à l’unité de mesure et le contenu net doivent être exprimés uniquement en unité de contenance : millilitre (ML), litre (LT), mètre cube (CR), centilitre (C3)</errorMessage>
		           
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
