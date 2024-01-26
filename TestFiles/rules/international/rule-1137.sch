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
   <pattern>
      <title>Rule 1137</title>
      <doc:description>If targetMarketCountryCode equals ('249' (France) or '250' (France)) and tradeItemUnitDescriptorCode equals 'PALLET' and platformTypeCode equals  '25', then TradeItemMeasurements/depth shall be between and including ('1165 MMT' or '45.87 IN') and ('2330 MMT' or '91.74 IN'), and TradeItemMeasurements/width shall be between and including ('1165 MMT' or '45.87 IN') and ('2330 MMT' or '91.74 IN').</doc:description>
      <doc:attribute1>targetMarketCountryCode,tradeItemUnitDescriptorCode,platformTypeCode</doc:attribute1>
      <doc:attribute2>depth,width</doc:attribute2>
      <rule context="tradeItem">
		  <assert test="if((targetMarket/targetMarketCountryCode =  ('249'(: France :) , '250'(: France :) )) 
    					and (tradeItemUnitDescriptorCode = 'PALLET')
    					and (tradeItemInformation/extension/*:packagingInformationModule/packaging/platformTypeCode = '25'))
    					then (every $node in (tradeItemInformation/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements)
    					satisfies(
    					if ($node/depth and $node/width)        					
    					then if (($node/depth/@measurementUnitCode = 'MMT') and  ($node/width/@measurementUnitCode = 'MMT'))
    					then   ((number($node/depth) ge 1165) and (number($node/depth) le 2330)
            			and    (number($node/width) ge 1165) and (number($node/width) le 2330))                			
            			else  (: measurementUnitCode = 'IN' :)    
            			     if (($node/depth/@measurementUnitCode = 'IN') and  ($node/width/@measurementUnitCode = 'IN'))              			    
            			then   ((number($node/depth) ge 45.87) and (number($node/depth) le 91.74)
            			and    (number($node/width) ge 45.87) and (number($node/width) le 91.74))                   			 
            				else true()  
            					else true())) 												
        							
				          				 else true()">				          		 
				          		 		
							      		 		<errorMessage>If targetMarketCountryCode equals ('249' (France) or '250' (France)) and tradeItemUnitDescriptorCode equals 'PALLET' and platformTypeCode equals  '25', 
							      		 		              then TradeItemMeasurements/depth shall be between and including ('1165 MMT' or '45.87 IN') and ('2330 MMT' or '91.74 IN'), 
							      		 		              and TradeItemMeasurements/width shall be between and including ('1165 MMT' or '45.87 IN') and ('2330 MMT' or '91.74 IN').
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
