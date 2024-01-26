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
      <title>Rule 1286</title>
       <doc:description>There must be at most one iteration of minimumToleranceTemperature per value of temperatureQualifierCode</doc:description>
       <doc:attribute1>TradeItemTemperatureInformation/temperatureQualifierCode</doc:attribute1>
       <doc:attribute2>TradeItemTemperatureInformation/minimumToleranceTemperature</doc:attribute2>
       <rule context="tradeItem/tradeItemInformation/extension/*:tradeItemTemperatureInformationModule">
       
           <assert test="every $node in ('DELIVERY_TO_DISTRIBUTION_CENTRE','DELIVERY_TO_MARKET','INLET_TEMPERATURE','OPERATING_TEMPERATURE','STORAGE_AFTER_OPENING','STORAGE_AFTER_OVERWRAP','STORAGE_AFTER_RECONSTITUTION','STORAGE_HANDLING','TRANSPORTATION','WORKING_TEMPERATURE')
           				 satisfies (if (count(tradeItemTemperatureInformation/temperatureQualifierCode[.=$node]) &gt; 1)
           				 then (count(tradeItemTemperatureInformation[temperatureQualifierCode=$node]/minimumToleranceTemperature) &lt;= 1)
           				 
           				 		 else true())">
           				 		 
           				 		 
           				 			<errorMessage>There must be at most one iteration of minimumToleranceTemperature per value of temperatureQualifierCode</errorMessage> 
           	 	
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
