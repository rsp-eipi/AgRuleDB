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
      <title>Rule FR_038</title>
       <doc:description>If tradeItemUnitDescriptorCode equal MIXED_MODULE|PALLET then catalogueItemChildItemLink/catalogueItem/tradeItem/tradeItemUnitDescriptorCode must not equal MIXED_MODULE|PALLET</doc:description>
       <rule context="catalogueItem">
           <assert test="if((tradeItem/targetMarket/targetMarketCountryCode =  ('249'(: France :) , '250'(: France :) )) and (gdsnTradeItemClassification/gpcCategoryCode!='10005844') and (gdsnTradeItemClassification/gpcCategoryCode!='10005845') and (tradeItem/tradeItemUnitDescriptorCode = ('MIXED_MODULE','PALLET'))) then  exists(catalogueItemChildItemLink/catalogueItem/tradeItem/tradeItemUnitDescriptorCode) and (every $node in (catalogueItemChildItemLink/catalogueItem/tradeItem/tradeItemUnitDescriptorCode) satisfies ($node != 'MIXED_MODULE' and $node != 'PALLET') )
           
           	 else true()">
           	 
           	 	
           	 	   <errorMessage>Une palette / box palette homogène standard ou une palette / box palette hétérogène standard ne peut pas avoir pour fils une palette / box palette homogène standard ou une palette / box palette hétérogène standard (Si le type d’unité logistique est PALLET ou MIXED_MODULE alors son gtin fils doit avoir un type d’unité logistique tradeItemUnitDescriptorCode différent de MIXED_MODULE ou PALLET).</errorMessage>
	           
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
