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
   <let name="gpc" value="doc('../data/data.xml')//data:gpc"/>
   <pattern>
      <title>Rule 1162</title>
      <doc:description>If targetMarketCountryCode equals '250' (France) or '752' (Sweden) and isTradeItemAConsumerUnit equals 'true' and isTradeItemNonphysical does not equal 'true' then both priceComparisonContentTypeCode and priceComparisonMeasurement SHALL be used.</doc:description>
      <doc:avenant>Modif. 3.1.13 exclude the 4 GPC bricks for Medical Devices, Veterinary Medical Devices, Pharmaceutical Drugs and Veterinary Pharmaceuticals</doc:avenant>
      <doc:avenant1>Modif. 3.1.23 Changed Structured Rule, Error Message and Target Market Scope</doc:avenant1>
      <doc:attribute1>targetMarketCountryCode,tradeItemTradeChannelCode, isTradeItemAConsumerUnit,isTradeItemNonPhysical</doc:attribute1>
      <doc:attribute2>priceComparisonContentTypeCode,priceComparisonMeasurement</doc:attribute2>      
      <rule context="tradeItem">
          <assert test="if((targetMarket/targetMarketCountryCode =  ('250'(: France :) , '752'(: Sweden :) )) 
       						and (not (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP007/gpcDP007Code))                                                                          									 					
        					and (not (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP008/gpcDP008Code)) 
                            and (isTradeItemAConsumerUnit = 'true')                          
                            and ( not (exists(isTradeItemNonPhysical)) or (isTradeItemNonPhysical = 'false')) )  
        					then (exists(tradeItemInformation/extension/*:salesInformationModule/salesInformation/priceComparisonContentTypeCode) 
        					and exists(tradeItemInformation/extension/*:salesInformationModule/salesInformation/priceComparisonMeasurement)    					
        					and (every $node in (tradeItemInformation/extension/*:salesInformationModule/salesInformation) 
        					satisfies (($node/priceComparisonMeasurement != '') and ($node/priceComparisonContentTypeCode != ''))) )                  												
        							
				          				 else true()">				          		 
				          		 		
				          		 		        <targetMarketCountryCode><xsl:value-of select="targetMarket/targetMarketCountryCode"/></targetMarketCountryCode>	
							      		 		<errorMessage>For Country of Sale Code (#targetMarketCountryCode#), and Consumer Unit Indicator (isTradeItemAConsumerUnit) is 'true' and isTradeItemNonphysical is not 'true' then both priceComparisonContentTypeCode and priceComparisonMeasurement SHALL be used.</errorMessage>
							                
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
