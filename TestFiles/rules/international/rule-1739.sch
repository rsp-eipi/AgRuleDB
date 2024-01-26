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
      <title>Rule 1739</title>      
      <doc:description>IF targetMarketCountryCode equals (203 (Czech Republic), 528 (Netherlands), 246 (Finland), '250' (France), or '752' (Sweden)) and any of nutrientTypeCode OR quantityContained OR measurementPrecisionCode is used THEN nutrientTypeCode AND quantityContained AND measurementPrecisionCode SHALL be used.</doc:description>    
      <doc:avenant>Modif. 3.1.21 Add Sweden as target market for this rule.</doc:avenant>   
      <doc:attribute1>targetMarketCountryCode,gpcCategoryCode</doc:attribute1>   
      <doc:attribute2>nutrientTypeCode,quantityContained, measurementPrecisionCode</doc:attribute2>     
     <rule context="tradeItem">
     		  <assert test="if ((targetMarket/targetMarketCountryCode =  ('203', '528', '246', '250'))	
     		            and (not (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP007/gpcDP007Code))                                                                          									 					
        				and (not (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP008/gpcDP008Code)) 	                
		                and (exists(tradeItemInformation/extension/*:nutritionalInformationModule/nutrientHeader/nutrientDetail/nutrientTypeCode) 
		                or 	 exists(tradeItemInformation/extension/*:nutritionalInformationModule/nutrientHeader/nutrientDetail/quantityContained) 
		                or 	 exists(tradeItemInformation/extension/*:nutritionalInformationModule/nutrientHeader/nutrientDetail/measurementPrecisionCode))) 	                
		                then (every $node in (tradeItemInformation/extension/*:nutritionalInformationModule/nutrientHeader/nutrientDetail)
         				  satisfies  ($node/nutrientTypeCode !='' and $node/quantityContained !='' and $node/measurementPrecisionCode !='') )                  
           							        							
				          				 else true()">			          		 
				          		 		
				          		 				<targetMarketCountryCode><xsl:value-of select="targetMarket/targetMarketCountryCode"/></targetMarketCountryCode>					          		 				
							      		 		<errorMessage>For Country of Sale Code (#targetMarketCountryCode#) , if any of the following attributes is provided, then all three must be provided: Nutrient Code, Nutrient Quantity, Nutrient Value Precision Code.</errorMessage>
							                
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
