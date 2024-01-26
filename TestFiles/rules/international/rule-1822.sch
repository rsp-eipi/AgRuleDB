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
      <title>Rule 1822</title>
	    <doc:description>If one iteration of targetMarketCountryCode equals '250' (France) and if importClassificationTypeCode equals 'CUSTOMS_TARIFF_NUMBER' then importClassificationValue SHALL have a value [less than or equal to] 13 characters long</doc:description>
        <doc:attribute1>targetMarketCountryCode,importClassificationTypeCode</doc:attribute1>
        <doc:attribute2>importClassificationValue </doc:attribute2>        
        <rule context="tradeItem">
            <assert test="if((targetMarket/targetMarketCountryCode =  ('250'(: France :) ))                            
        			      and (tradeItemInformation/extension/*:placeOfItemActivityModule/importClassification/importClassificationTypeCode ='CUSTOMS_TARIFF_NUMBER'))
            			  then  (exists(tradeItemInformation/extension/*:placeOfItemActivityModule/importClassification/importClassificationValue)
                          and (every $node in (tradeItemInformation/extension/*:placeOfItemActivityModule/importClassification/importClassificationValue)
                          satisfies ( (string-length($node) &lt;= 13) )))			 
            
		            			  else true()">
		            	 
		            	 	
								           	    <errorMessage>For the target market France, the customs nomenclature code shall have a value [less than or equal to] 13 characters.</errorMessage>
									                
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
