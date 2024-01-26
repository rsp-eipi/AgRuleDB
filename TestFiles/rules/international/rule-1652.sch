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
   <let name="gpc" value="doc('../data/data.xml')//data:gpc"/>
   <pattern>
      <title>Rule 1652</title>
      <doc:description>If targetMarketCountryCode equals (208 (Denmark) or 826 (UK))
                       and contextIdentfication does not equal 'DP007' or 'DP008'
                       and temperatureQualifierCode equals 'STORAGE_HANDLING', 
                       then maximumTemperature SHALL be used.
      </doc:description>
      <doc:attribute1>targetMarketCountryCode,gpcCategoryCode,temperatureQualifierCode</doc:attribute1>
      <doc:attribute2>maximumTemperature</doc:attribute2>
      <rule context="tradeItem">
		  <assert test="if ((targetMarket/targetMarketCountryCode =  ('208', '826'))
		                and   (not (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP007/gpcDP007Code))                                                                          									 					
        				and (not (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP008/gpcDP008Code)) 
		                and (tradeItemInformation/extension/*:tradeItemTemperatureInformationModule/tradeItemTemperatureInformation/temperatureQualifierCode = 'STORAGE_HANDLING')) 		                
		                then exists(tradeItemInformation/extension/*:tradeItemTemperatureInformationModule/tradeItemTemperatureInformation/maximumTemperature)
         				and (every $node in (tradeItemInformation/extension/*:tradeItemTemperatureInformationModule/tradeItemTemperatureInformation/maximumTemperature)
         				  satisfies  $node!='')                   
           							        							
				          				 else true()">				          		 
				          		 		
							      		 		<errorMessage>If temperatureQualifierCode equals 'STORAGE_HANDLING',
							      		 		              then maximumTemperature SHALL be used  for any context other than 'DP007' or 'DP008'.
			      		 		                </errorMessage>
							                
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
