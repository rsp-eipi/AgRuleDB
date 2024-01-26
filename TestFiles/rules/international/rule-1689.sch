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
      <title>Rule 1689</title>
      <doc:description>If targetMarketCountryCode equals ‘250’ (France) and gpcCategoryCode is in GPC Family ('67010000' (Clothing) or ‘63010000’ (Footwear)) and tradeItemUnitDescriptorCode equals ‘BASE_UNIT_OR_EACH’ and isTradeItemAConsumerUnit equals ‘true’ then colourFamilyCode shall be populated.</doc:description>
      <doc:attribute1>targetMarketCountryCode,gpcCategoryCode,tradeItemUnitDescriptorCode,isTradeItemAConsumerUnit</doc:attribute1> 
      <doc:attribute2>colourFamilyCode</doc:attribute2>      
      <rule context="tradeItem">
          <assert test="if((targetMarket/targetMarketCountryCode =  ('250'(: France :) )) 
        				and ((gdsnTradeItemClassification/gpcCategoryCode =  '10006903')         			
        				or   (gdsnTradeItemClassification/gpcCategoryCode =  '10000400')
        				or   (gdsnTradeItemClassification/gpcCategoryCode =  '10000432')   
        				or   (gdsnTradeItemClassification/gpcCategoryCode =  '10000433')          			
        				or   (gdsnTradeItemClassification/gpcCategoryCode =  '10000700') 
        				or   (gdsnTradeItemClassification/gpcCategoryCode =  '10001070')     
        				or   (gdsnTradeItemClassification/gpcCategoryCode =  '10001071')   
        				or   (gdsnTradeItemClassification/gpcCategoryCode =  '10001074') 
        				or   (gdsnTradeItemClassification/gpcCategoryCode =  '10001076') 
        				or   (gdsnTradeItemClassification/gpcCategoryCode =  '10001077') 
        				or   (gdsnTradeItemClassification/gpcCategoryCode =  '10001078') 
        				or   (gdsnTradeItemClassification/gpcCategoryCode =  '10001079') 
        				or   (gdsnTradeItemClassification/gpcCategoryCode =  '10001080') 
        				or   (gdsnTradeItemClassification/gpcCategoryCode =  '10001081')  
        				or   (gdsnTradeItemClassification/gpcCategoryCode =  '10001082')  )        				                                                  
		                and  (tradeItemUnitDescriptorCode = 'BASE_UNIT_OR_EACH')
		                and (isTradeItemAConsumerUnit = 'true') )      									
    					then (exists(tradeItemInformation/extension/*:tradeItemDescriptionModule/tradeItemDescriptionInformation/colour/colourFamilyCode) 
    					and (every $node in (tradeItemInformation/extension/*:tradeItemDescriptionModule/tradeItemDescriptionInformation/colour/colourFamilyCode)
    					satisfies ($node != '')))   
    					
    						 else true()">			        		 
				          		 		
							      		 		<errorMessage>If the target market is France, the product has a GPC brick code belonging to the family ('67010000' (clothing) or'63010000' (footwear)), and the hierarchy level is a base unit that is also a consumer unit then the colour family code is mandatory.</errorMessage>
							                
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
