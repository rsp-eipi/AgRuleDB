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
      <title>Rule 1740</title>      
      <doc:description>If targetMarketCountryCode equals (203 (Czech Republic), 528 (Netherlands), or 246 (Finland)) and tradeItemUnitDescriptorCode is equal to 'PALLET' and isTradeItemPackedIrregularly is equal to 'FALSE' or not used, then quantityOfCompleteLayersContainedInATradeItem SHALL be greater than zero.</doc:description>    
      <doc:avenant>Modif. 3.1.21 Changed structured rule, error message and pass/fail examples.</doc:avenant>   
      <doc:attribute1>targetMarketCountryCode,gpcCategoryCode,tradeItemUnitDescriptorCode,isTradeItemPackedIrregularly</doc:attribute1>   
      <doc:attribute2>quantityOfCompleteLayersContainedInATradeItem</doc:attribute2>     
     <rule context="tradeItem">
     		  <assert test="if ((targetMarket/targetMarketCountryCode =  ('203', '528', '246'))	
     		            and (not (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP007/gpcDP007Code))                                                                          									 					
        				and (not (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP008/gpcDP008Code)) 	  	                
		                and (tradeItemUnitDescriptorCode = 'PALLET') 
		                and ( not (exists(tradeItemInformation/extension/*:tradeItemHierarchyModule/tradeItemHierarchy/isTradeItemPackedIrregularly))
		                or (tradeItemInformation/extension/*:tradeItemHierarchyModule/tradeItemHierarchy/isTradeItemPackedIrregularly = 'FALSE')) )  		                               
		                then  exists(tradeItemInformation/extension/*:tradeItemHierarchyModule/tradeItemHierarchy/quantityOfCompleteLayersContainedInATradeItem) 
         			    and (every $node in (tradeItemInformation/extension/*:tradeItemHierarchyModule/tradeItemHierarchy/quantityOfCompleteLayersContainedInATradeItem) 
         			    satisfies  ( $node  &gt; 0) )                
           							        							
				          				 else true()">			          		 
				          		 		
							      		 		<errorMessage>If Product Hierarchy Level Code (tradeItemUnitDescriptorCode) is equal to 'PALLET' and Irregularly Configured Pallet Indicator (isTradeItemPackedIrregularly) is equal to 'FALSE' or is not used, then Number of Layers per GTIN (quantityOfCompleteLayersContainedInATradeItem) shall be used and greater than zero.
.</errorMessage>
							                
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
