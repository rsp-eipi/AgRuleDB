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
      <title>Rule 1431</title>
	    <doc:description>If targetMarketCountryCode equals '752' (Sweden) and descriptiveSizeDimension is used, then one iteration of descriptiveSizeDimension/@languageCode shall equal 'sv' (Swedish).</doc:description>
	    <doc:avenant>Modif. 3.1.23 Updated Structured Rule and Xpaths based on changes from GDSN 3.1.23 Large release </doc:avenant>
        <doc:attribute1>targetMarketCountryCode, descriptiveSizeDimension</doc:attribute1>        
        <rule context="tradeItem">
            <assert test="if((targetMarket/targetMarketCountryCode =  ('752'(: Sweden :) ))                            
        			      and (exists(tradeItemInformation/extension/*:tradeItemSizeModule/nonPackagedSizeDimension/descriptiveSizeDimension)))
            			  then (some $node in (tradeItemInformation/extension/*:tradeItemSizeModule/nonPackagedSizeDimension/descriptiveSizeDimension)
            			  satisfies ($node/@languageCode = 'sv' ))           			 
            
		            			  else true()">
		            	 
		            	 	
								           	    <errorMessage>For descriptiveSizeDimension one of the values must be in Swedish. You are not allowed to populate descriptiveSizeDimension more than once in the same language.</errorMessage>
									                
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
