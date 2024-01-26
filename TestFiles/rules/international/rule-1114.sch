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
      <title>Rule 1114</title>
      <doc:description>If targetMarketCountryCode equals ('249' (France) or '250' (France)) and (TradeItemMeasurements/height or TradeItemMeasurements/width or TradeItemMeasurements/depth) is not empty and the associated measurementUnitCode equals ''CMT', then its associated value shall not have more than 1 decimal position.</doc:description>
      <doc:attribute1>targetMarketCountryCode</doc:attribute1>
      <doc:attribute2>height, depth, width</doc:attribute2>
      <rule context="tradeItem">
          <assert test="if((targetMarket/targetMarketCountryCode =  ('249'(: France :) , '250'(: France :) ))
                        and (gdsnTradeItemClassification/gpcCategoryCode!='10005844') and (gdsnTradeItemClassification/gpcCategoryCode!='10005845') 
       					and (gdsnTradeItemClassification/gpcCategoryCode!='10006412') and (gdsnTradeItemClassification/gpcCategoryCode!='10000514') ) 
          				then (every $node in (tradeItemInformation/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/height[@measurementUnitCode[.='CMT']],
          				                      tradeItemInformation/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/depth[@measurementUnitCode[.='CMT']], 
          				                      tradeItemInformation/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/width[@measurementUnitCode[.='CMT']])
          				                      satisfies((string-length(substring-after($node,'.'))) &lt; 2))                  												
        							
				          				 else true()">				          		 
				          		 		
							      		 		<errorMessage>If targetMarketCountryCode equals ('249' (France) or '250' (France)) and (TradeItemMeasurements/height or TradeItemMeasurements/width or TradeItemMeasurements/depth) is not empty and the associated measurementUnitCode equals ''CMT', then its associated value shall not have more than 1 decimal position.
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
