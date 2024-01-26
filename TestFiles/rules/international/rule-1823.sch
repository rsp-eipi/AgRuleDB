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
      <title>Rule 1823</title>
	    <doc:description>If targetMarketCountryCode equals '250' (France) and isTradeItemADespatchUnit equals 'true' and (isTradeItemPackedIrregularly equals 'FALSE' or is not used) and platformTypeCode is used, then quantityOfCompleteLayersContainedInATradeItem SHALL be greater than 0.</doc:description>
        <doc:attribute1>targetMarketCountryCode,isTradeItemADespatchUnit,isTradeItemPackedIrregularly,platformTypeCode</doc:attribute1>
        <doc:attribute2>quantityOfCompleteLayersContainedInATradeItem</doc:attribute2>        
        <rule context="tradeItem">
            <assert test="if((targetMarket/targetMarketCountryCode =  ('250'(: France :) )) 
                          and (isTradeItemADespatchUnit = 'true') 
                          and ( not (exists(tradeItemInformation/extension/*:tradeItemHierarchyModule/tradeItemHierarchy/isTradeItemPackedIrregularly))
		                  or (tradeItemInformation/extension/*:tradeItemHierarchyModule/tradeItemHierarchy/isTradeItemPackedIrregularly = 'FALSE'))                          
        			      and (exists(tradeItemInformation/extension/*:packagingInformationModule/packaging/platformTypeCode)))
            			  then  (exists(tradeItemInformation/extension/*:tradeItemHierarchyModule/tradeItemHierarchy/quantityOfCompleteLayersContainedInATradeItem)
                          and (every $node in (tradeItemInformation/extension/*:tradeItemHierarchyModule/tradeItemHierarchy/quantityOfCompleteLayersContainedInATradeItem)
                          satisfies ( $node &gt; 0) ))			 
            
		            			  else true()">
		            	 
		            	 	
								           	    <errorMessage>For Country Of Sale Code (France) and Pallet Type Code  is used, it is mandatory to provide a valid Number of Layers per GTIN for a pallet.</errorMessage>
									                
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
