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
      <title>Rule 1761</title>
      <doc:description>If targetMarketCountryCode equals '528' (the Netherlands) and one instance of preparationStateCode equals 'PREPARED' and at least one nutrientTypeCode is used, then there SHALL be at least
                        one instance of preparationInstructions with languageCode equal to 'nl'.</doc:description>
      <doc:attribute1>targetMarketCountryCode,gpcCategoryCode,preparationStateCode,nutrientTypeCode</doc:attribute1>
      <doc:attribute2>ipreparationInstructions</doc:attribute2>
      <rule context="tradeItem">
		  <assert test="if ((targetMarket/targetMarketCountryCode = '528')
		  				and (not (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP007/gpcDP007Code))                                                                          									 					
        				and (not (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP008/gpcDP008Code)) 	   
		  				and (tradeItemInformation/extension/*:nutritionalInformationModule/nutrientHeader/preparationStateCode = 'PREPARED')
		  				and (exists(tradeItemInformation/extension/*:nutritionalInformationModule/nutrientHeader/nutrientDetail/nutrientTypeCode)))		               	               	               
		                then (some $node in (tradeItemInformation/extension/*:foodAndBeveragePreparationServingModule/preparationServing) 
    					satisfies ($node/preparationInstructions/@languageCode = 'nl'))						
        							
				          				 else true()">				          		 
				          		 		
							      		 		<errorMessage>An instance of preparation instructions with the language code 'nl' shall be filled out in case preparation state code is filled out with 'PREPARED' and at least one nutrient type code is filled out.
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
