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
      <title>Rule 1713</title>
      <doc:description>If packagingRawMaterialContentPercentage is used then the value SHALL be greater than or equal to 0 and less than or equal to 100</doc:description>
      <doc:attribute1>packaging/packagingMaterial/packagingRawMaterialInformation/packagingRawMaterialContentPercentage</doc:attribute1>
      <rule context="tradeItem">
         <assert test="if (tradeItemInformation/extension/*:packagingInformationModule/packaging/packagingMaterial/packagingRawMaterialInformation/packagingRawMaterialContentPercentage)
         			   then  exists(tradeItemInformation/extension/*:packagingInformationModule/packaging/packagingMaterial/packagingRawMaterialInformation/packagingRawMaterialContentPercentage) 
         			   and (every $node in (tradeItemInformation/extension/*:packagingInformationModule/packaging/packagingMaterial/packagingRawMaterialInformation/packagingRawMaterialContentPercentage) 
         			   satisfies  ( $node   &gt;= 0 and  $node   &lt;= 100) ) 
         
         	else true()">         	
         		
         		<errorMessage>If packagingRawMaterialContentPercentage is used then the value SHALL be greater than or equal to 0 and less than or equal to 100</errorMessage>
                
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
