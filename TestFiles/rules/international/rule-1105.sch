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
   <pattern>
      <title>Rule 1105</title>
      <doc:description>If targetMarketCountryCode equals  ('250' (France) or '246' (Finland)) and priceComparisonMeasurement is used, then priceComparisonMeasurement SHALL be greater than 0.</doc:description>
      <doc:avenant>Modif. 3.1.23  Changed Structured Rule, Error Message, Target Market Scope and Example of Data that will FAIL/PASS</doc:avenant>
      <doc:attribute1>targetMarketCountryCode,priceComparisonMeasurement</doc:attribute1>
      <doc:attribute2>priceComparisonMeasurement</doc:attribute2>
      <rule context="tradeItem">
          <assert test="if((targetMarket/targetMarketCountryCode =  ('250'(: France :) , '246'(: Finland :) )) 
        					and exists (tradeItemInformation/extension/*:salesInformationModule/salesInformation/priceComparisonMeasurement) 
        					and (tradeItemInformation/extension/*:salesInformationModule/salesInformation/priceComparisonMeasurement != '') )          					
          					then (every $node in (tradeItemInformation/extension/*:salesInformationModule/salesInformation/priceComparisonMeasurement) satisfies  ($node &gt; 0)) 
          					
				          		 else true()">
				          		 
				          		 	<targetMarketCountryCode><xsl:value-of select="targetMarket/targetMarketCountryCode"/></targetMarketCountryCode>		
				      		 		<errorMessage>For Country Of Sale Code (#targetMarketCountryCode#), if priceComparisonMeasurement is used, then priceComparisonMeasurement shall be greater than 0.</errorMessage>
				                
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
