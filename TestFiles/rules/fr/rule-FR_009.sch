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
      <title>Rule FR_009</title>
       <doc:description>If isTradeItemADespatchUnit = 'true' and (tradeItemUnitDescriptorCode equal 'PALLET' or 'MIXED_MODULE') or (tradeItemUnitDescriptorCode equal 'CASE' or 'DISPLAY_SHIPPER' and packagingTypeCode equal 'PX') then platformTypeCode must be populated</doc:description>
      <doc:attribute1>platformTypeCode, tradeItemUnitDescriptorCode, packagingTypeCode</doc:attribute1>
      <rule context="tradeItem">
          <assert test="if ((targetMarket/targetMarketCountryCode =  ('249'(: France :) , '250'(: France :) )) and (gdsnTradeItemClassification/gpcCategoryCode!='10005844') and (gdsnTradeItemClassification/gpcCategoryCode!='10005845') and (isTradeItemADespatchUnit = 'true') and ((tradeItemUnitDescriptorCode =  ('PALLET', 'MIXED_MODULE') )  or  ( (tradeItemUnitDescriptorCode =  ('CASE', 'DISPLAY_SHIPPER') )  and  (tradeItemInformation/extension/*:packagingInformationModule/packaging/packagingTypeCode = 'PX')) ) ) then  exists(tradeItemInformation/extension/*:packagingInformationModule/packaging/platformTypeCode) and (every $node in (tradeItemInformation/extension/*:packagingInformationModule/packaging/platformTypeCode) satisfies  ( exists($node) ) )
          	 else true()">
          	 	
          	   <errorMessage>Il est obligatoire d'indiquer un type de support (platformTypeCode) pour les unités logistiques palette ou box palette (tradeItemUnitDescriptorCode equal PL ou MX) et les 1/2, 1/4,… de palette ou box palette (tradeItemUnitDescriptorCode equal CA ou DS avec packagingTypeCode equal PLT (palette) ou X2 (box palette)).</errorMessage>
           
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
