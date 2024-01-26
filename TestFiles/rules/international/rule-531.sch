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
   <let name="units" value="doc('../data/data.xml')//data:units"/>
   <let name="gpc" value="doc('../data/data.xml')//data:gpc"/>
   <pattern>
      <title>Rule 531</title>
       <doc:description>If targetMarketCountryCode equals ('752' (Sweden)) and isTradeItemAConsumerUnit is equal to 'true' then functionalName must not contain a value from brandName or descriptiveSizeDimension.</doc:description>
       <doc:avenant>Modif. 3.1.21 Changed structured rule and error message.</doc:avenant>
       <doc:avenant1>Modif. 3.1.23 Updated Structured Rule and Xpaths based on changes from GDSN 3.1.23 Large release .</doc:avenant1>
       <doc:attribute1>targetMarketCountryCode, isTradeItemAConsumerUnit</doc:attribute1>
       <doc:attribute2>functionalName, brandName, descriptiveSizeDimension</doc:attribute2>
      <rule context="tradeItem">        
          <assert test="if((targetMarket/targetMarketCountryCode =  ('752'(: Sweden :) ))     
                        and (isTradeItemAConsumerUnit = 'true') 
        			    and exists(tradeItemInformation/extension/*:tradeItemDescriptionModule/tradeItemDescriptionInformation/functionalName)
        			    and exists(tradeItemInformation/extension/*:tradeItemDescriptionModule/tradeItemDescriptionInformation/brandNameInformation/brandName)
        		 	    and (not (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP007/gpcDP007Code))                                                                          									 					
        				and (not (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP008/gpcDP008Code))) 	  
                        then (every $node in (tradeItemInformation/extension/*:tradeItemDescriptionModule/tradeItemDescriptionInformation/functionalName) 
                        satisfies not((contains($node,tradeItemInformation/extension/*:tradeItemDescriptionModule/tradeItemDescriptionInformation/brandNameInformation/brandName)))
                        ) 
          
          			   	 else true()">
          			    
          			    		
          			    	   <errorMessage>functionalName may not contain the same text as brandName or descriptiveSizeDimension when IsTradeItemAConsumerUnit is equal to 'true'.</errorMessage>
				           
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
		  
		  <assert test="if((targetMarket/targetMarketCountryCode =  ('752'(: Sweden :) ))     
		  				and (isTradeItemAConsumerUnit = 'true') 
        			    and exists(tradeItemInformation/extension/*:tradeItemDescriptionModule/tradeItemDescriptionInformation/functionalName)
        			    and exists(tradeItemInformation/extension/*:tradeItemSizeModule/nonPackagedSizeDimension/descriptiveSizeDimension)
        		 	    and (not (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP007/gpcDP007Code))                                                                          									 					
        				and (not (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP008/gpcDP008Code))) 	  
                        then (every $node in (tradeItemInformation/extension/*:tradeItemDescriptionModule/tradeItemDescriptionInformation/functionalName) 
                        satisfies not((contains($node,tradeItemInformation/extension/*:tradeItemSizeModule/nonPackagedSizeDimension/descriptiveSizeDimension)))
                         ) 
          
          			   	 else true()">
          			    
          			    		
          			    	   <errorMessage>functionalName may not contain the same text as brandName or descriptiveSizeDimension when IsTradeItemAConsumerUnit is equal to 'true'.</errorMessage>
				           
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
