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
      <title>Rule FR_120</title>
       <doc:description>If isTradeItemAConsumerUnit equal true and regulatedProductName is populated and gpcCategoryCode equal 10005800 {Viande porc non préparé non transformé} 10006278 10006279 {viande ovine} 10005792 {viande caprine} 10006291 10005790 10005803 10005799 10006293 10006290 10005788 10005798 10006289 {volaille} then placeOfProductActivity/provenanceStatement must be populated</doc:description>
      <rule context="tradeItem">
          <assert test="if ((targetMarket/targetMarketCountryCode =  ('249'(: France :) , '250'(: France :) )) and (gdsnTradeItemClassification/gpcCategoryCode!='10005844') and (gdsnTradeItemClassification/gpcCategoryCode!='10005845') and (isTradeItemAConsumerUnit = 'true') and (tradeItemInformation/extension/*:tradeItemDescriptionModule/tradeItemDescriptionInformation/regulatedProductName)  and  (gdsnTradeItemClassification/gpcCategoryCode =  (10005800, 10006278, 10006279, 10005792, 10006291, 10005790, 10005803, 10005799, 10006293, 10006290, 10005788, 10005798, 10006289) ) ) then  exists(tradeItemInformation/extension/*:placeOfItemActivityModule/placeOfProductActivity/provenanceStatement) and (every $node in (tradeItemInformation/extension/*:placeOfItemActivityModule/placeOfProductActivity/provenanceStatement) satisfies  ( exists($node) ) )
          
          	 else true()">
          	 
          	 	
          	 	       <errorMessage>L'indication de la mention d'origine est obligatoire pour toutes les viandes porcines, ovines, caprines et volailles fraîches, congelées et réfrigérées à partir du 1er avril 2015.</errorMessage>
		           
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
