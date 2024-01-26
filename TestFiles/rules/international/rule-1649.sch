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
      <title>Rule 1649</title>
      <doc:description>If targetMarketCountryCode equals (056 (Belgium), 442 (Luxembourg), 276 (Germany), 528 (Netherlands), 208 (Denmark),
                                                          203 (Czech Republic), 246 (Finland), 380 (Italy), 250 (France) or 040 (Austria))
                       and tradeItemUnitDescriptorCode equals 'PALLET', then quantityOfTradeItemsPerPallet SHALL NOT be used.
      </doc:description>
      <doc:attribute1>targetMarketCountryCode,tradeItemUnitDescriptorCode</doc:attribute1>
      <doc:attribute2>quantityOfTradeItemsPerPallet</doc:attribute2>
      <rule context="tradeItem">
		  <assert test="if ((targetMarket/targetMarketCountryCode =  ('056', '442', '276', '528', '208', '203', '246', '380', '250', '040'))
		                and (tradeItemUnitDescriptorCode = 'PALLET')) 		                
		                then (every $node in (tradeItemInformation/extension/*:tradeItemHierarchyModule/tradeItemHierarchy/quantityOfTradeItemsPerPallet) 
        				satisfies not (exists($node)) )                      
           							        							
				          				 else true()">				          		 
				          		 		
							      		 		<errorMessage>Attribute quantityOfTradeItemsPerPallet shall only be used for non-GTIN logistic units.</errorMessage>
							                
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
