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
      <title>Rule 1703</title>      
      <doc:description>IF targetMarketCountryCode equals '752' (Sweden) and handlingInstructionsCodeReference equals ‘OTC’ (Temperature Controlled), then temperatureQualifierCode SHALL be used and equal  ('STORAGE_HANDLING' or 'TRANSPORTATION') AND maximumTemperature and minimumTemperature SHALL be used per temperatureQualifierCode.</doc:description>
      <doc:attribute1>targetMarketCountryCode,handlingInstructionsCodeReference </doc:attribute1>
      <doc:attribute2>temperatureQualifierCode,maximumTemperature,minimumTemperature</doc:attribute2>
    
     <rule context="tradeItem">
		  <assert test="if(targetMarket/targetMarketCountryCode =  ('752'(: Sweden :) ) 
		                and (tradeItemInformation/extension/*:tradeItemHandlingModule/tradeItemHandlingInformation/handlingInstructionsCodeReference  =  'OTC'))	                                
		                then exists(tradeItemInformation/extension/*:tradeItemTemperatureInformationModule/tradeItemTemperatureInformation/temperatureQualifierCode)
		                and exists(tradeItemInformation/extension/*:tradeItemTemperatureInformationModule/tradeItemTemperatureInformation/minimumTemperature)
		                and exists(tradeItemInformation/extension/*:tradeItemTemperatureInformationModule/tradeItemTemperatureInformation/maximumTemperature)
         				and (every $node in (tradeItemInformation/extension/*:tradeItemTemperatureInformationModule/tradeItemTemperatureInformation)
         				satisfies  ( $node/temperatureQualifierCode = ('STORAGE_HANDLING' , 'TRANSPORTATION')     
				        and  $node/minimumTemperature != ''  and  $node/maximumTemperature != '') )  				 
				          				 	else true()">				          		 
				          		 		
							      		 		<errorMessage>In Sweden for items both maximumTemperature and minimumTemperature are required.</errorMessage>
							                
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
