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
      <title>Rule 1342</title>
      <doc:description>If targetMarketCountryCode equals '840 (United States) 
                       and (ChildNutritionQualifier or any sub-class) is used,
                       then ChildNutritionQualifier/childNutritionQualifier,
                       ChildNutritionQualifier/childNutritionQualifiedValue,
                       ChildNutritionQualifier/childNutritionValue,
                       ChildNutritionLabel/ childNutritionLabelStatement,
                       ChildNutritionLabel/childNutritionProductIdentification shall be used.
        </doc:description>
        <doc:attribute1>targetMarketCountryCode,childNutritionQualifier</doc:attribute1>
        <doc:attribute2>childNutritionQualifiedValue,childNutritionValue,childNutritionLabelStatement,childNutritionProductIdentification</doc:attribute2>
        <rule context="tradeItem">
            <assert test="if((targetMarket/targetMarketCountryCode =  ('840'(: United States :) ))
                          and ((gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP006/gpcDP006Code)
                          or (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP015/gpcDP015Code))   
        			      and (exists(tradeItemInformation/extension/*:childNutritionInformationModule/childNutritionLabel/childNutritionQualifier)))            			              			
            			  then (exists(tradeItemInformation/extension/*:childNutritionInformationModule/childNutritionLabel/childNutritionQualifier/childNutritionQualifiedValue)
            			  and exists(tradeItemInformation/extension/*:childNutritionInformationModule/childNutritionLabel/childNutritionQualifier/childNutritionValue)
            			  and exists(tradeItemInformation/extension/*:childNutritionInformationModule/childNutritionLabel/childNutritionLabelStatement)
            			  and exists(tradeItemInformation/extension/*:childNutritionInformationModule/childNutritionLabel/childNutritionProductIdentification )            			  
            			  and (every $node in (tradeItemInformation/extension/*:childNutritionInformationModule/childNutritionLabel)
            			  satisfies (($node/childNutritionQualifier/childNutritionQualifiedValue) != ''
            			  and ($node/childNutritionQualifier/childNutritionValue) != '' 
            			  and ($node/childNutritionLabelStatement) != ''
            			  and ($node/childNutritionProductIdentification) != '')))
            
            			  else true()">
            	 
            	 	
			            	   <errorMessage>If targetMarketCountryCode equals '840 (United States)
			            	                 and (ChildNutritionQualifier or any sub-class) is used,
			            	                 then ChildNutritionQualifier/childNutritionQualifier, 
			            	                 ChildNutritionQualifier/childNutritionQualifiedValue,
			            	                 ChildNutritionQualifier/childNutritionValue,
			            	                 ChildNutritionLabel/ childNutritionLabelStatement
			            	                 ,  and  ChildNutritionLabel/childNutritionProductIdentification shall be used.
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
