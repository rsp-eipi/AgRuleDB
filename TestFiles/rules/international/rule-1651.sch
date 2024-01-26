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
      <title>Rule 1651</title>
      <doc:description>If targetMarketCountryCode equals (276 (Germany), 528 (Netherlands), 208 (Denmark), 203 (Czech Republic), 246 (Finland),
                                                          056 (Belgium), 442 (Luxembourg), 250 (France) or 040 (Austria))
                        and tradeItemUnitDescriptorCode equals 'PALLET', 
                        then following attributes from nonGTINLogisticsUnitInformation class SHALL NOT be used: grossWeight, height, depth, width, logisticsUnitStackingFactor.                 
      </doc:description>
      <doc:attribute1>targetMarketCountryCode,tradeItemUnitDescriptorCode</doc:attribute1>
      <doc:attribute2>quantityOfLayersPerPallet</doc:attribute2>
      <rule context="tradeItem">
		  <assert test="if ((targetMarket/targetMarketCountryCode =  ('276', '528', '208', '203', '246', '056', '442', '250', '040'))
		                and (tradeItemUnitDescriptorCode = 'PALLET')) 		                
		                then (every $node in (tradeItemInformation/extension/*:nonGTINLogisticsUnitInformationModule/nonGTINLogisticsUnitInformation/grossWeight,
		                                      tradeItemInformation/extension/*:nonGTINLogisticsUnitInformationModule/nonGTINLogisticsUnitInformation/height,
		                                      tradeItemInformation/extension/*:nonGTINLogisticsUnitInformationModule/nonGTINLogisticsUnitInformation/depth,
		                                      tradeItemInformation/extension/*:nonGTINLogisticsUnitInformationModule/nonGTINLogisticsUnitInformation/width,
		                                      tradeItemInformation/extension/*:nonGTINLogisticsUnitInformationModule/nonGTINLogisticsUnitInformation/logisticsUnitStackingFactor) 
        				satisfies not (exists($node)) )                      
           							        							
				          				 else true()">				          		 
				          		 		
							      		 		<errorMessage>Attributes from nonGTINLogisticsUnitInformation class SHALL NOT be used when trade item is GTIN identified pallet.</errorMessage>
							                
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
