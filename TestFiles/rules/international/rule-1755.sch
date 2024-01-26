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
      <title>Rule 1755</title>      
      <doc:description>If targetMarketCountryCode equals ('056' (Belgium), '442' (Luxembourg), '528' (Netherlands)) and levelOfContainmentCode is used,
                       then levelOfContainmentCode SHALL equal one of the following values: 'CONTAINS', 'FREE_FROM' or 'MAY_CONTAIN'.
      </doc:description>    
      <doc:attribute1>targetMarketCountryCode,gpcCategoryCode</doc:attribute1> 
      <doc:attribute2>levelOfContainmentCode</doc:attribute2>       
   	  <rule context="tradeItem">
		   <assert test="if((targetMarket/targetMarketCountryCode =  ('056' , '442' , '528'))
                            and (not (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP007/gpcDP007Code))                                                                          									 					
        				    and (not (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP008/gpcDP008Code)) 	          									 					
        					and (exists (tradeItemInformation/extension/*:allergenInformationModule/allergenRelatedInformation/allergen/levelOfContainmentCode)))        					     					
        					then (every $node in (tradeItemInformation/extension/*:allergenInformationModule/allergenRelatedInformation/allergen) 
        					satisfies ($node/levelOfContainmentCode = ('CONTAINS', 'FREE_FROM', 'MAY_CONTAIN')))                 												
        							
				          				 else true()">					          		 
				          		 		
							      		 		<errorMessage>The value for level of containment code is not valid; the allowed values are 'CONTAINS', 'FREE_FROM', 'MAY_CONTAIN' for the target market.</errorMessage>
							                
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
 		  
 		   <assert test="if((targetMarket/targetMarketCountryCode =  ('056' , '442' , '528'))
                            and (gdsnTradeItemClassification/gpcCategoryCode != $gpc/gpcDP007/gpcDP007Code)
                            and (gdsnTradeItemClassification/gpcCategoryCode != $gpc/gpcDP008/gpcDP008Code)          									 					
        					and (exists (tradeItemInformation/extension/*:foodAndBeverageIngredientModule/additiveInformation/levelOfContainmentCode)))        					     					
        					then (every $node in (tradeItemInformation/extension/*:foodAndBeverageIngredientModule/additiveInformation) 
        					satisfies ($node/levelOfContainmentCode = ('CONTAINS', 'FREE_FROM', 'MAY_CONTAIN')))                 												
        							
				          				 else true()">					          		 
				          		 		
							      		 		<errorMessage>The value for level of containment code is not valid; the allowed values are 'CONTAINS', 'FREE_FROM', 'MAY_CONTAIN' for the target market.</errorMessage>
							                
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
 		  
 		   <assert test="if((targetMarket/targetMarketCountryCode =  ('056' , '442' , '528'))
                            and (gdsnTradeItemClassification/gpcCategoryCode != $gpc/gpcDP007/gpcDP007Code)
                            and (gdsnTradeItemClassification/gpcCategoryCode != $gpc/gpcDP008/gpcDP008Code)          									 					
        					and (exists (tradeItemInformation/extension/*:nonfoodIngredientModule/additiveInformation/levelOfContainmentCode)))        					     					
        					then (every $node in (tradeItemInformation/extension/*:nonfoodIngredientModule/additiveInformation) 
        					satisfies ($node/levelOfContainmentCode = ('CONTAINS', 'FREE_FROM', 'MAY_CONTAIN')))                 												
        							
				          				 else true()">					          		 
				          		 		
							      		 		<errorMessage>The value for level of containment code is not valid; the allowed values are 'CONTAINS', 'FREE_FROM', 'MAY_CONTAIN' for the target market.</errorMessage>
							                
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
