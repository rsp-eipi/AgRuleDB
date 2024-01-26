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
      <title>Rule 520</title>
      <doc:description>If targetMarketCountryCode is equal to '752' (Sweden) and priceBasisQuantity is not empty then related unitOfMeasureCode must equal 'KGM' 'GRM' 'MTR''MLT' 'MMT' 'LTR' 'MTK' 'MTQ' or 'H87'</doc:description>
      <doc:attribute1>TradeItemPrice/priceBasisQuantity</doc:attribute1>
      <doc:attribute2>Measurement/unitOfMeasureCode</doc:attribute2>
      <rule context="tradeItem">
         <assert test="if ( (targetMarket/targetMarketCountryCode = '752'(: Sweden :) )  and  (tradeItemInformation/extension/*:salesInformationModule/tradeItemPriceInformation/additionalTradeItemPrice/priceBasisQuantity ) ) then  exists(tradeItemInformation/extension/*:salesInformationModule/tradeItemPriceInformation/additionalTradeItemPrice/priceBasisQuantity/@measurementUnitCode) and (every $node in (tradeItemInformation/extension/*:salesInformationModule/tradeItemPriceInformation/additionalTradeItemPrice/priceBasisQuantity/@measurementUnitCode) satisfies $node =  ('KGM', 'GRM', 'MTR', 'MLT', 'MMT', 'LTR', 'MTK', 'MTQ', 'H87') )
         
         			   else true()">
         			   
         			   			
         			   		   <errorMessage>If targetMarketCountryCode is equal to '752' (Sweden) priceBasisQuantity may be specified with the following units of measures: kilogram, gram , metre, millimetre, millilitre, litre, square metre, cubic metres,piece.</errorMessage>
				           
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
