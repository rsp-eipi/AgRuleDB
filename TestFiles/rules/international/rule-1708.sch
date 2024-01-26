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
      <title>Rule 1708</title>      
      <doc:description>If dietTypeCode equals ’KOSHER’ and dietTypeSubcode is used, then dietTypeSubcode SHALL be a value in (‘MEAT’, ’FISH’, ‘DAIRY’, ‘PAREVE’, 'KOSHER_FOR_PASSOVER', ‘MEAT_FOR_PASSOVER’, ‘FISH_FOR_PASSOVER’, ‘DAIRY_FOR_PASSOVER’, ‘PAREVE_FOR_PASSOVER’, ‘DE’, ‘MEVUSHAL’, ‘KOSHER_FOR_PASSOVER_MEVUSHAL’).</doc:description>
      <doc:attribute1>gdsnTradeItemClassification/gpcCategoryCode, dietTypeInformation/dietTypeCode</doc:attribute1>
      <doc:attribute2>dietTypeInformation/dietTypeSubcode</doc:attribute2>
    
     <rule context="tradeItem">
		  <assert test="if ((gdsnTradeItemClassification/gpcCategoryCode!='10005844') and (gdsnTradeItemClassification/gpcCategoryCode!='10005845') 
       						and (gdsnTradeItemClassification/gpcCategoryCode!='10006412') and (gdsnTradeItemClassification/gpcCategoryCode!='10000514')			
		                and (exists(tradeItemInformation/extension/*:dietInformationModule/dietInformation/dietTypeInformation/dietTypeSubcode)
		  				and (exists(tradeItemInformation/extension/*:dietInformationModule/dietInformation/dietTypeInformation/dietTypeCode)
        			    and (tradeItemInformation/extension/*:dietInformationModule/dietInformation/dietTypeInformation/dietTypeCode) = 'KOSHER')))                                    
		                then (every $node in (tradeItemInformation/extension/*:dietInformationModule/dietInformation/dietTypeInformation/dietTypeSubcode)
         				satisfies  ( $node = ('MEAT', 'FISH', 'DAIRY', 'PAREVE', 'KOSHER_FOR_PASSOVER', 'MEAT_FOR_PASSOVER', 'FISH_FOR_PASSOVER',
         				                      'DAIRY_FOR_PASSOVER', 'PAREVE_FOR_PASSOVER', 'DE', 'MEVUSHAL', 'KOSHER_FOR_PASSOVER_MEVUSHAL') ) ) 
         				 				 
				          				 	else true()">				          		 
				          		 		
							      		 		<errorMessage>The dietTypeSubcodeCode is not valid for a Kosher diet.</errorMessage>
							                
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
