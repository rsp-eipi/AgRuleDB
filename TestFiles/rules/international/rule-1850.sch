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
      <title>Rule 1850</title>      
      <doc:description>If targetMarketCountryCode equals '246' (Finland) and tradeItemUnitDescriptorCode equals 'BASE_UNIT_OR_EACH'  then tradeItemTradeChannelCode SHALL be used.</doc:description>       
      <doc:attribute1>targetMarketCountryCode,gpcCategoryCode,tradeItemUnitDescriptorCode</doc:attribute1> 
      <doc:attribute2>tradeItemTradeChannelCode</doc:attribute2> 
      <rule context="tradeItem">     
          <assert test="if ((targetMarket/targetMarketCountryCode =  '246')
         				and (tradeItemUnitDescriptorCode = 'BASE_UNIT_OR_EACH')   		           
     		            and (not (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP007/gpcDP007Code))                                                                          									 					
        				and (not (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP008/gpcDP008Code))) 
     		            then ((exists(tradeItemTradeChannelCode))
     		            and (every $node in (tradeItemTradeChannelCode)
         				satisfies  ($node != '') ))                         
           							        							
				          				 else true()">			
                        		 
				          		 				<targetMarketCountryCode><xsl:value-of select="targetMarket/targetMarketCountryCode"/></targetMarketCountryCode>
				          		 				<tradeItemTradeChannelCode><xsl:value-of select="tradeItemTradeChannelCode"/></tradeItemTradeChannelCode>
							      		 		<errorMessage>For Country of Sale Code (#targetMarketCountryCode#), Trade Item Trade Channel Code (#tradeItemTradeChannelCode#) SHALL be used.</errorMessage>
							                
								                <location>
														<!-- Fichier SDBH -->
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
