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
      <title>Rule 634</title>
	    <doc:description>If targetMarketCountryCode is equal to  ('040' (Austria) or '276' (Germany))
	                     and isReturnableAssetEmpty = 'TRUE' 
	                     then returnableAssetCapacityContent shall not be empty.
	    </doc:description>
        <doc:attribute1>targetMarketCountryCode,isReturnableAssetEmpty</doc:attribute1>
        <doc:attribute2>returnableAssetCapacityContent</doc:attribute2>
        <rule context="tradeItem">
            <assert test="if((targetMarket/targetMarketCountryCode =  ('040'(: Austria :) , '276'(: Germany :) ))                           
        			      and ((exists(tradeItemInformation/extension/*:packagingInformationModule/packaging/returnableAsset/isReturnableAssetEmpty))
        			      and (tradeItemInformation/extension/*:packagingInformationModule/packaging/returnableAsset/isReturnableAssetEmpty) = 'TRUE'))            			              			
            			  then (exists(tradeItemInformation/extension/*:packagingInformationModule/packaging/returnableAsset/returnableAssetCapacityContent)             			 
            			  and (every $node in (tradeItemInformation/extension/*:packagingInformationModule/packaging/returnableAsset/returnableAssetCapacityContent)
            			  satisfies ($node &gt; 0 )))            			 
            
		            			  else true()">
		            	 
		            	 	
					            	   <errorMessage>returnableAssetCapacityContent is missing. 
                                                     For Target Markets '040' (Austria) and '276' (Germany) 
                                                     returnableAssetCapacityContent is mandatory
                                                     if returnableAssetEmpty equals 'TRUE'.
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
