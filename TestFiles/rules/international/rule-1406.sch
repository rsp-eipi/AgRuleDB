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
      <title>Rule 1351</title>
	    <doc:description>If targetMarketCountryCode is equal to ('840' (United States) 
	                     and MarketingInformationModule/MarketingInformation/couponFamilyCode is not empty 
	                     it shall be exactly 3 characters.
	    </doc:description>
        <doc:attribute1>targetMarketCountryCode,couponFamilyCode</doc:attribute1>
       
        <rule context="tradeItem">
            <assert test="if((targetMarket/targetMarketCountryCode =  ('840'(: United States :) ))                           
        			      and ((exists(tradeItemInformation/extension/*:marketingInformationModule/marketingInformation/couponFamilyCode))
        			      and (tradeItemInformation/extension/*:marketingInformationModule/marketingInformation/couponFamilyCode) != ''))            			              			
            			  then (every $node in (tradeItemInformation/extension/*:marketingInformationModule/marketingInformation/couponFamilyCode)
            			  satisfies( string-length($node) = 3))        			 
            
		            			  else true()">
		            	 
		            	 	
					            	   <errorMessage>The length of MarketingInformationModule/MarketingInformation/couponFamilyCode shall exactly be 3 characters 
					            	                 for targetMarketCountryCode equal to ('840' (United States).
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
