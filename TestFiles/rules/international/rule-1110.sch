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
      <title>Rule 1110</title>
      <doc:description>If targetMarketCountryCode equals ('249' (France) or '250' (France)) and gpcCategoryCode is not equal to ('10000050' or '10000262') 
                       and priceComparisonContentTypeCode equals 'PER_LITRE' then the associated measurementUnitCode of priceComparisonMeasurement and of one iteration of netContent shall be from the Unit Of Measure Classification 'VOLUME'
      </doc:description>
      <doc:attribute1>targetMarketCountryCode,gpcCategoryCode,priceComparisonContentTypeCode</doc:attribute1>
      <doc:attribute2>priceComparisonMeasurement,netContent</doc:attribute2>
      <rule context="tradeItem">
          <assert test="if((targetMarket/targetMarketCountryCode =  ('249'(: France :) , '250'(: France :) )) 
        					and (gdsnTradeItemClassification/gpcCategoryCode=('10000050','10000262')) )  
        					then (every $node in (tradeItemInformation/extension) satisfies (
        					if($node/*:salesInformationModule/salesInformation/priceComparisonContentTypeCode = 'PER_LITRE')
        					then every $node1 in ($node/*:salesInformationModule/salesInformation/priceComparisonMeasurement/@measurementUnitCode, $node/*:tradeItemMeasurementsModule/tradeItemMeasurements/netContent/@measurementUnitCode) 
        					satisfies  ( $units/unit[@code=$node1]/@type =  'Volume' ) 
        					
        							else true())) 
        							
				          				 else true()">
				          		 
				          		 		
							      		 		<errorMessage>Associated measurementUnitCode of priceComparisonMeasurement and/or of one iteration of netContent is/are not from the Unit Of Measure Classification 'VOLUME'.
                                                              If targetMarketCountryCode equals ('249' (France) or '250' (France)) and and gpcCategoryCode is not equal to ('10000050' or '10000262') and priceComparisonContentTypeCode equals 'PER_LITRE'
                                                              then the associated measurementUnitCode of priceComparisonMeasurement and of one iteration of netContent shall be from the Unit Of Measure Classification 'VOLUME'.
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
