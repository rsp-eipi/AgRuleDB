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
        <title>Rule FR_016</title>
        <doc:description>If catalogueItemChildItemLink is populated and endAvailabilityDateTime is populated then catalogueItem/tradeItem/tradeItemInformation/extension/deliveryPurchasingInformationModule/deliveryPurchasingInformation/endAvailabilityDateTime must be anterior or equal of catalogueItem/catalogueItemChildItemLink/catalogueItem/tradeItem/tradeItemInformation/extension/deliveryPurchasingInformationModule/deliveryPurchasingInformation/endAvailabilityDateTime</doc:description>
        <doc:attribute1>endAvailabilityDateTime</doc:attribute1>
        <rule context="catalogueItem">
            <assert test="if ((tradeItem/targetMarket/targetMarketCountryCode =  ('249'(: France :) , '250'(: France :) )) and (tradeItem/gdsnTradeItemClassification/gpcCategoryCode!='10005844') and (tradeItem/gdsnTradeItemClassification/gpcCategoryCode!='10005845') and  (tradeItem/tradeItemInformation/extension/*:deliveryPurchasingInformationModule/deliveryPurchasingInformation/endAvailabilityDateTime) and (catalogueItemChildItemLink/catalogueItem/tradeItem/tradeItemInformation/extension/*:deliveryPurchasingInformationModule/deliveryPurchasingInformation/endAvailabilityDateTime)) then (every $node in (catalogueItemChildItemLink/catalogueItem/tradeItem/tradeItemInformation/extension/*:deliveryPurchasingInformationModule/deliveryPurchasingInformation/endAvailabilityDateTime) satisfies (every $node1 in (tradeItem/tradeItemInformation/extension/*:deliveryPurchasingInformationModule/deliveryPurchasingInformation/endAvailabilityDateTime) satisfies($node ge $node1)))
            
            	 else true()">
            	 
            	 	
            	   <errorMessage>la date de fin de disponibilité à la commande (endAvailabilityDateTime) d'une unité commerciale doit toujours être postérieure ou égale à la date de fin de disponibilité des unités commerciales de rang supérieur dans la hiérarchie logistique.</errorMessage>
	           
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