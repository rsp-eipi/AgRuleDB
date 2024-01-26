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
      <title>Rule 1438</title>
      <doc:description>If targetMarketCountryCode equals '752' (Sweden) 
                         and  (maximumOptimumConsumptionTemperature,  minimumOptimumConsumptionTemperature,  preparationInstructions, servingSuggestion, productYieldTypeCode or productYieldVariationPercentage) is used,
                         then preparationTypeCode shall be used.
        </doc:description>
        <doc:attribute1>targetMarketCountryCode,maximumOptimumConsumptionTemperature,minimumOptimumConsumptionTemperature,preparationInstructions,
                        servingSuggestion,productYieldTypeCode,productYieldVariationPercentage
        </doc:attribute1>
        <doc:attribute2>preparationTypeCode</doc:attribute2>
        <rule context="tradeItem">
            <assert test="if((targetMarket/targetMarketCountryCode =  ('752'(: Sweden :) ))
        			      and ((exists(tradeItemInformation/extension/*:foodAndBeveragePreparationServingModule/preparationServing/maximumOptimumConsumptionTemperature))
        			      or   (exists(tradeItemInformation/extension/*:foodAndBeveragePreparationServingModule/preparationServing/minimumOptimumConsumptionTemperature))
        			      or   (exists(tradeItemInformation/extension/*:foodAndBeveragePreparationServingModule/preparationServing/preparationInstructions))
        			      or   (exists(tradeItemInformation/extension/*:foodAndBeveragePreparationServingModule/preparationServing/servingSuggestion))
        			      or   (exists(tradeItemInformation/extension/*:foodAndBeveragePreparationServingModule/preparationServing/productYieldTypeCode))
        			      or   (exists(tradeItemInformation/extension/*:foodAndBeveragePreparationServingModule/preparationServing/productYieldVariationPercentage))
        			      ))            			
            			  then (exists(tradeItemInformation/extension/*:foodAndBeveragePreparationServingModule/preparationServing/preparationTypeCode)
            			  and (every $node in (tradeItemInformation/extension/*:foodAndBeveragePreparationServingModule/preparationServing/preparationTypeCode)
            			  satisfies ($node != '')))
            
            			  else true()">
            	 
            	 	
			            	   <errorMessage>preparationTypeCode is missing for this trade item.</errorMessage>
							                
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
