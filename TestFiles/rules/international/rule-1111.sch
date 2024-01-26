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
      <title>Rule 1111</title>
      <doc:description>If targetMarketCountryCode equals ('249' (France) or '250' (France)) and dutyFeeTaxTypeCode equals '3001000002282' then dutyFeeTaxRate shall be empty and dutyFeeTaxAmount shall be used.</doc:description>
      <doc:attribute1>targetMarketCountryCode,dutyFeeTaxTypeCode</doc:attribute1>
      <doc:attribute2>dutyFeeTaxRate,dutyFeeTaxAmount</doc:attribute2>
      <rule context="dutyFeeTaxInformation">
          <assert test="if((ancestor::tradeItem/targetMarket/targetMarketCountryCode =  ('249'(: France :) , '250'(: France :) )) 
        					and (dutyFeeTaxTypeCode = '3001000002282') )          					
          				    then (exists(dutyFeeTax/dutyFeeTaxAmount) 
          				    and (not (exists(dutyFeeTax/dutyFeeTaxRate))) 
    					    and (every $node in (dutyFeeTax) 
        					satisfies (empty($node/dutyFeeTaxRate) and (not(empty($node/dutyFeeTaxAmount))))) )     
          				             				   
				          				 else true()">
				          		 
				          		 		
							      		 		<errorMessage>If targetMarketCountryCode equals ('249' (France) or '250' (France)) and dutyFeeTaxTypeCode equals '3001000002282' then dutyFeeTaxRate shall be empty and dutyFeeTaxAmount shall be used.
	                                            </errorMessage>
							                
								                <location>
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
