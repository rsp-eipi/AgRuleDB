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
      <title>Rule 1756</title>      
      <doc:description>If targetMarketCountryCode equals '528' (Netherlands) and gpcCategoryCode equals one of the bricks in GPC segment '92000000', 
                       then isPackagingMarkedReturnable SHALL NOT be 'true'.
      </doc:description>    
      <doc:attribute1>targetMarketCountryCode,gpcCategoryCode</doc:attribute1> 
      <doc:attribute2>isPackagingMarkedReturnable</doc:attribute2>       
   	  <rule context="tradeItem">
		    <assert test="if((targetMarket/targetMarketCountryCode =  '528') 
                            and (gdsnTradeItemClassification/gpcCategoryCode = ('10005846' , '10005847' , '10005848' , '10005849' , '10005850' , '10005851' , '10005852' , '10005853' ,
                                                                                 '10005854' , '10005855' , '10005856' , '10005857' , '10005858' , '10005859' , '10005860' , '10005861' , '10005862' ))
        					and (exists (tradeItemInformation/extension/*:packagingMarkingModule/packagingMarking/isPackagingMarkedReturnable)))         					    					
        					then (every $node in (tradeItemInformation/extension/*:packagingMarkingModule/packagingMarking) 
        					satisfies ($node//isPackagingMarkedReturnable != 'true' ))                    												
        							
				          				 else true()">					          		 
				          		 		
							      		 		<errorMessage>Is packaging marked returnable shall not be 'true' for an empty article for target market Netherlands.</errorMessage>
							                
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
