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
      <title>Rule 1285</title>
       <doc:description>If TradeItemTemperatureInformation class is used, then minimumTemperature/@temperatureMeasurementUnitCode, if used, SHALL be unique for all iterations of the same temperatureQualifierCode.</doc:description>
       <doc:avenant>Modif. 3.1.23 Changed Structured Rule, Error Message and Example of Data that will FAIL/PASS</doc:avenant>
       <doc:attribute1>TradeItemTemperatureInformation/temperatureQualifierCode</doc:attribute1>
       <doc:attribute2>TradeItemTemperatureInformation/minimumTemperature/@temperatureMeasurementUnitCode</doc:attribute2>
       <rule context="tradeItem/tradeItemInformation/extension/*:tradeItemTemperatureInformationModule">
       
           <assert test="every $node in ('DELIVERY_TO_DISTRIBUTION_CENTRE','DELIVERY_TO_MARKET','INLET_TEMPERATURE','OPERATING_TEMPERATURE','STORAGE_AFTER_OPENING','STORAGE_AFTER_OVERWRAP','STORAGE_AFTER_RECONSTITUTION','STORAGE_HANDLING','TRANSPORTATION','WORKING_TEMPERATURE')
                         satisfies (if (count(tradeItemTemperatureInformation/temperatureQualifierCode[.=$node]) &gt; 1) 
                         then (count(distinct-values(tradeItemTemperatureInformation[temperatureQualifierCode=$node]/minimumTemperature/@temperatureMeasurementUnitCode)) = 
           			     count(tradeItemTemperatureInformation/temperatureQualifierCode[.=$node]))

                         
                         	 else true())">                         	 
                         	 		
                         	 		    <temperatureQualifierCode><xsl:value-of select="tradeItemTemperatureInformation/temperatureQualifierCode"/></temperatureQualifierCode>
           			     		 		<minimumTemperature><xsl:value-of select="tradeItemTemperatureInformation/minimumTemperature/@temperatureMeasurementUnitCode"/></minimumTemperature>
           			     		 		<errorMessage>minimum Temperature must be given using unique units of measurement, if multiple temperatures for Temperature Activity Code (#temperatureQualifierCode#), the (#minimumTemperature#) SHALL not be repeated.</errorMessage> 
           	 	
           	 	
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
												<gtin><xsl:value-of select="ancestor::tradeItem/gtin"/></gtin>
												<glnProvider><xsl:value-of select="ancestor::tradeItem/informationProviderOfTradeItem/gln"/></glnProvider>
												<targetMarket><xsl:value-of select="ancestor::tradeItem/targetMarket/targetMarketCountryCode"/></targetMarket>	
										
									</location>  
                         	 		
 		   </assert>
      </rule>
   </pattern>
</schema>
