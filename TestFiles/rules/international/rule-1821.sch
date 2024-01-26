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
      <title>Rule 1821</title>
	    <doc:description>If targetMarketCountryCode equals '250' (France) and importClassificationTypeCode equals 'CUSTOMS_TARIFF_NUMBER', then the corresponding importClassificationValue SHALL have a value between 8 and 13 numeric characters in length</doc:description>
        <doc:attribute1>targetMarketCountryCode,importClassificationTypeCode</doc:attribute1>
        <doc:attribute2>importClassificationValue </doc:attribute2>        
        <rule context="importClassification">
            <assert test="if((ancestor::tradeItem/targetMarket/targetMarketCountryCode =  ('250'(: France :) ))                            
        			      and (importClassificationTypeCode ='CUSTOMS_TARIFF_NUMBER'))
            			  then  (exists(importClassificationValue)
                          and (every $node in (importClassificationValue)
                          satisfies (( (number($node) ge 0) and (string-length($node) &gt;= 8) and (string-length($node) &lt;= 13) ))))			 
            
		            			  else true()">
		            	 
		            	 	
								           	    <errorMessage>For Country Of Sale Code (France) and Customs Classification Type Code  equals 'CUSTOMS_TARIFF_NUMBER' then the corresponding Customs Classification Value shall have a value 8 to 13 numeric characters long.</errorMessage>
									                
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
