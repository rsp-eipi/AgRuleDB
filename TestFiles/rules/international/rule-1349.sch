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
      <title>Rule 1349</title>
      <doc:description>If targetMarketCountryCode equals '840' (United States)
                       and doesTradeItemMeetWholeGrainRichCriteria is used,
                       then doesTradeItemContainNoncreditableGrains, 
                       and creditableGrainGroupCode shall be used.
        </doc:description>
        <doc:attribute1>targetMarketCountryCode,doesTradeItemMeetWholeGrainRichCriteria</doc:attribute1>
        <doc:attribute2>doesTradeItemContainNoncreditableGrains,creditableGrainGroupCode</doc:attribute2>
        <rule context="tradeItem">
            <assert test="if((targetMarket/targetMarketCountryCode =  ('840'(: United States :) ))
                          and ((gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP006/gpcDP006Code)
                          or (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP015/gpcDP015Code))   
        			      and (exists(tradeItemInformation/extension/*:productFormulationStatementModule/productFormulationStatement/creditableIngredient/creditableIngredientDetails/creditableGrainsInformation/doesTradeItemMeetWholeGrainRichCriteria)))            			              			
            			  then (exists(tradeItemInformation/extension/*:productFormulationStatementModule/productFormulationStatement/creditableIngredient/creditableIngredientDetails/creditableGrainsInformation/doesTradeItemContainNoncreditableGrains)  
            			  and exists(tradeItemInformation/extension/*:productFormulationStatementModule/productFormulationStatement/creditableIngredient/creditableIngredientDetails/creditableGrainsInformation/creditableGrain/creditableGrainGroupCode)            			  
            			  and (every $node in (tradeItemInformation/extension/*:productFormulationStatementModule/productFormulationStatement/creditableIngredient/creditableIngredientDetails/creditableGrainsInformation)
            			  satisfies ($node/doesTradeItemContainNoncreditableGrains != '' and $node/creditableGrain/creditableGrainGroupCode != '')))            			 
            
		            			  else true()">
		            	 
		            	 	
					            	   <errorMessage>The attributes doesTradeItemContainNonCreditableGrains,
					            	                 and creditableGrainGroupCode  shall be used
					            	                 for Target Market '840' (United States)
					            	                 when the attribute doesTradeItemMeetWholeGrainRichCriteria is used.
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
